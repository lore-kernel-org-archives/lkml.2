Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707Ab0G3RyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:54:12 -0400
Received: from kroah.org ([198.145.64.141]:57758 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759639Ab0G3RyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:06 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:33 2010
Message-Id: <20100730175133.786112036@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [002/205] virtio: return ENOMEM on out of memory
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

commit 686d363786a53ed28ee875b84ef24e6d5126ef6f upstream.

add_buf returns ring size on out of memory,
this is not what devices expect.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/virtio/virtio_ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -118,7 +118,7 @@ static int vring_add_indirect(struct vri
 
 	desc = kmalloc((out + in) * sizeof(struct vring_desc), GFP_ATOMIC);
 	if (!desc)
-		return vq->vring.num;
+		return -ENOMEM;
 
 	/* Transfer entries from the sg list into the indirect page */
 	for (i = 0; i < out; i++) {


