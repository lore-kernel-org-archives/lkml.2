Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab2DMRiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 13:38:15 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51028 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab2DMRiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 13:38:14 -0400
Date: Fri, 13 Apr 2012 13:38:04 -0400 (EDT)
Message-Id: <20120413.133804.1504347944886702242.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [net-next V7 PATCH] virtio-net: send gratuitous packets when
 needed
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120412064351.23243.84912.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120412064351.23243.84912.stgit@amd-6168-8-1.englab.nay.redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 13 Apr 2012 10:38:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu, 12 Apr 2012 14:43:52 +0800

> As hypervior does not have the knowledge of guest network configuration, it's
> better to ask guest to send gratuitous packets when needed.
> 
> This patch implements VIRTIO_NET_F_GUEST_ANNOUNCE feature: hypervisor would
> notice the guest when it thinks it's time for guest to announce the link
> presnece. Guest tests VIRTIO_NET_S_ANNOUNCE bit during config change interrupt
> and woule send gratuitous packets through netif_notify_peers() and ack the
> notification through ctrl vq.
> 
> We need to make sure the atomicy of read and ack in guest otherwise we may ack
> more times than being notified. This is done through handling the whole config
> change interrupt in an non-reentrant workqueue.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Michael, Rusty, et al.?
