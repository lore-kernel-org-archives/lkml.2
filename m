Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab2J3DDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 23:03:19 -0400
Received: from plane.gmane.org ([80.91.229.3]:34622 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab2J3DDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 23:03:17 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] bonding: fix bond 6 mode change MAC of arp reply from
 vif to cause Domu's network unreachable intermittently
Date: Tue, 30 Oct 2012 03:03:05 +0000 (UTC)
Message-ID: <k6ng19$fvd$1@ger.gmane.org>
References: <1351565271-5888-1-git-send-email-zheng.x.li@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 112.132.138.96
User-Agent: slrn/0.9.9p1 (Linux)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012 at 02:47 GMT, Zheng Li <zheng.x.li@oracle.com> wrote:
> +			struct slave *tmp_slave = NULL;
> +			int i = 0, found_mac = 0;
> +			bond_for_each_slave(bond, tmp_slave, i) {
> +				if (ether_addr_equal_64bits(arp->mac_src,
> +						tmp_slave->dev->dev_addr)) {
> +					found_mac = 1;
> +					break;
> +				}
> +			}
> +			if (found_mac)
> +				memcpy(arp->mac_src, tx_slave->dev->dev_addr,
> +					ETH_ALEN);

A nitpick: found_mac can be a bool.

