Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab1GRRnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 13:43:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43520 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab1GRRno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 13:43:44 -0400
Date: Mon, 18 Jul 2011 10:43:21 -0700 (PDT)
Message-Id: <20110718.104321.439108421929344070.davem@davemloft.net>
To: mst@redhat.com
Cc: mashirle@us.ibm.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jj@chaosbits.net
Subject: Re: [PATCHv11] vhost: vhost TX zero-copy support
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110718134846.GA7107@redhat.com>
References: <20110718134846.GA7107@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 18 Jul 2011 10:43:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Mon, 18 Jul 2011 16:48:46 +0300

>>From: Shirley Ma <mashirle@us.ibm.com>
> 
> This adds experimental zero copy support in vhost-net,
> disabled by default. To enable, set
> experimental_zcopytx module option to 1.
> 
> This patch maintains the outstanding userspace buffers in the
> sequence it is delivered to vhost. The outstanding userspace buffers
> will be marked as done once the lower device buffers DMA has finished.
> This is monitored through last reference of kfree_skb callback. Two
> buffer indices are used for this purpose.
> 
> The vhost-net device passes the userspace buffers info to lower device
> skb through message control. DMA done status check and guest
> notification are handled by handle_tx: in the worst case is all buffers
> in the vq are in pending/done status, so we need to notify guest to
> release DMA done buffers first before we get any new buffers from the
> vq.
> 
> One known problem is that if the guest stops submitting
> buffers, buffers might never get used until some
> further action, e.g. device reset. This does not
> seem to affect linux guests.
> 
> Signed-off-by: Shirley <xma@us.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied, thanks!
