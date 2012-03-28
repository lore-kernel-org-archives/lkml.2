Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab2C1CbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 22:31:23 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47810 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab2C1CbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 22:31:21 -0400
Date: Tue, 27 Mar 2012 22:31:12 -0400 (EDT)
Message-Id: <20120327.223112.2032989102915830685.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [V5 PATCH] virtio-net: send gratuitous packets when needed
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120316090100.5223.50783.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120316090100.5223.50783.stgit@amd-6168-8-1.englab.nay.redhat.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 27 Mar 2012 19:31:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 16 Mar 2012 17:01:01 +0800

> As hypervior does not have the knowledge of guest network configuration, it's
> better to ask guest to send gratuitous packets when needed.
> 
> Guest tests VIRTIO_NET_S_ANNOUNCE bit during config change interrupt and when it
> is set, a workqueue is scheduled to send gratuitous packet through
> NETDEV_NOTIFY_PEERS. This feature is negotiated through bit
> VIRTIO_NET_F_GUEST_ANNOUNCE.
> 
> Changes from v4:
> - typos
> - handle workqueue unconditionally
> - move VIRTIO_NET_S_ANNOUNCE to bit 8 to separate rw bits from ro bits
> 
> Changes from v3:
> - cancel the workqueue during freeze
> 
> Changes from v2:
> - fix the race between unregister_dev() and workqueue
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

What's happening with this patch?
