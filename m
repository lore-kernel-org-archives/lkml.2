Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2KIVZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:25:31 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38453 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab2KIVZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:25:30 -0500
Date: Fri, 09 Nov 2012 16:25:28 -0500 (EST)
Message-Id: <20121109.162528.1251308488326610816.davem@davemloft.net>
To: zheng.x.li@oracle.com
Cc: netdev@vger.kernel.org, fubar@us.ibm.com, andy@greyhouse.net,
        linux-kernel@vger.kernel.org, joe.jin@oracle.com
Subject: Re: [PATCH] bonding: rlb mode of bond should not alter ARP replies
 originating via bridge
From: David Miller <davem@davemloft.net>
In-Reply-To: <1352258580-8272-1-git-send-email-zheng.x.li@oracle.com>
References: <1352258580-8272-1-git-send-email-zheng.x.li@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zheng Li <zheng.x.li@oracle.com>
Date: Wed,  7 Nov 2012 11:23:00 +0800

> ARP traffic passing through a bridge and out via the bond (when the bond is a 
> port of the bridge) should not have its source MAC address adjusted by the 
> receive load balance code in rlb_arp_xmit.
> 
> Signed-off-by: Zheng Li <zheng.x.li@oracle.com>

Please format these change properly, this is not indented
correctly at all:

> +				if (ether_addr_equal_64bits(arp->mac_src,
> +						tmp_slave->dev->dev_addr)) {
> +					memcpy(arp->mac_src,
> +						tx_slave->dev->dev_addr,
> +						ETH_ALEN);
> +					break;

Arguments to functions should line up, always, with the first column
after the openning parenthesis of the function call.

If that makes the far right column of the line go too far past
80 columns, too bad.  Make and use a helper function to perform
this test in that case.

Thanks.
