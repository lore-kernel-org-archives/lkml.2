Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966Ab1D2S6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:58:20 -0400
Received: from kroah.org ([198.145.64.141]:50197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686Ab1D2S6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:53 2011
Message-Id: <20110429185653.460564522@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [09/55] virtio: Decrement avail idx on buffer detach
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit b3258ff1d6086bd2b9eeb556844a868ad7d49bc8 upstream.

When detaching a buffer from a vq, the avail.idx value should be
decremented as well.

This was noticed by hot-unplugging a virtio console port and then
plugging in a new one on the same number (re-using the vqs which were
just 'disowned').  qemu reported

   'Guest moved used index from 0 to 256'

when any IO was attempted on the new port.

Reported-by: juzhang <juzhang@redhat.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/virtio/virtio_ring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -371,6 +371,7 @@ void *virtqueue_detach_unused_buf(struct
 		/* detach_buf clears data, so grab it now. */
 		buf = vq->data[i];
 		detach_buf(vq, i);
+		vq->vring.avail->idx--;
 		END_USE(vq);
 		return buf;
 	}


