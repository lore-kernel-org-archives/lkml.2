Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2JFHfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 03:35:48 -0400
Received: from ozlabs.org ([203.10.76.45]:34518 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab2JFHfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 03:35:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: virtio build breakage.
In-Reply-To: <20121004225943.GA32483@redhat.com>
References: <20121004225943.GA32483@redhat.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sat, 06 Oct 2012 17:04:31 +0930
Message-ID: <87d30wyry0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> After linking, I see this..
>
> ERROR: "virtqueue_kick" [net/9p/9pnet_virtio.ko] undefined!
> ERROR: "virtqueue_get_buf" [net/9p/9pnet_virtio.ko] undefined!

Cool!

Someone else spotted this recently, and the fix is in my recent pull
request to Linus:

commit 04679f34c141a0591e525d392929efc249440a7c
Author: Michael S. Tsirkin <mst@redhat.com>
Date:   Fri Sep 28 15:05:14 2012 +0930

    virtio-balloon: dependency fix
    
    Devices should depend on virtio, not select it.  It's supposed to be
    selected by the particular driver, e.g. VIRTIO_PCI.
    Make balloon depend on VIRTIO and EXPERIMENTAL
    (to match description).
    
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index f38b17a..271be80 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -27,8 +27,7 @@ config VIRTIO_PCI
 
 config VIRTIO_BALLOON
 	tristate "Virtio balloon driver (EXPERIMENTAL)"
-	select VIRTIO
-	select VIRTIO_RING
+	depends on EXPERIMENTAL && VIRTIO
 	---help---
 	 This driver supports increasing and decreasing the amount
 	 of memory within a KVM guest.
