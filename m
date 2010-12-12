Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab0LMAMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:12:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36137 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab0LLXqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:44 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: mclaren@tulane.edu, j@jannau.net, mchehab@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [102/223] hdpvr: Add missing URB_NO_TRANSFER_DMA_MAP flag
Message-Id: <20101212234642.95691B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:42 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: James M McLaren <mclaren@tulane.edu>

commit 4f5c933abb34532dc962185c999509b97a97fa1b upstream.

Necessary on arm.

Signed-off-by: Janne Grunau <j@jannau.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/media/video/hdpvr/hdpvr-video.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/media/video/hdpvr/hdpvr-video.c
===================================================================
--- linux.orig/drivers/media/video/hdpvr/hdpvr-video.c
+++ linux/drivers/media/video/hdpvr/hdpvr-video.c
@@ -157,6 +157,7 @@ int hdpvr_alloc_buffers(struct hdpvr_dev
 				  mem, dev->bulk_in_size,
 				  hdpvr_read_bulk_callback, buf);
 
+		buf->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 		buf->status = BUFSTAT_AVAILABLE;
 		list_add_tail(&buf->buff_list, &dev->free_buff_list);
 	}
