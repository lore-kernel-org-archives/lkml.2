Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2DOHUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 03:20:17 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:34533 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab2DOHUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 03:20:15 -0400
Date: Sun, 15 Apr 2012 03:20:03 -0400 (EDT)
Message-Id: <20120415.032003.138761548777211783.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, netdev@vger.kernel.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next V7 PATCH] virtio-net: send gratuitous packets when
 needed
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120415071223.GC3070@redhat.com>
References: <20120412064351.23243.84912.stgit@amd-6168-8-1.englab.nay.redhat.com>
	<20120415071223.GC3070@redhat.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 15 Apr 2012 00:20:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 15 Apr 2012 10:12:23 +0300

> On Thu, Apr 12, 2012 at 02:43:52PM +0800, Jason Wang wrote:
>> As hypervior does not have the knowledge of guest network configuration, it's
>> better to ask guest to send gratuitous packets when needed.
>> 
>> This patch implements VIRTIO_NET_F_GUEST_ANNOUNCE feature: hypervisor would
>> notice the guest when it thinks it's time for guest to announce the link
>> presnece. Guest tests VIRTIO_NET_S_ANNOUNCE bit during config change interrupt
>> and woule send gratuitous packets through netif_notify_peers() and ack the
>> notification through ctrl vq.
>> 
>> We need to make sure the atomicy of read and ack in guest otherwise we may ack
>> more times than being notified. This is done through handling the whole config
>> change interrupt in an non-reentrant workqueue.
>> 
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Applied, thanks everyone.
