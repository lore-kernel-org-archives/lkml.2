Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab0LHBBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:44 -0500
Received: from kroah.org ([198.145.64.141]:49054 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab0LHBBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:41 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:35 2010
Message-Id: <20101208005735.915069854@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Janne Grunau <j@jannau.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [145/289] [media] hdpvr: Add missing URB_NO_TRANSFER_DMA_MAP flag
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James M McLaren <mclaren@tulane.edu>

commit 4f5c933abb34532dc962185c999509b97a97fa1b upstream.

Necessary on arm.

Signed-off-by: Janne Grunau <j@jannau.net>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/hdpvr/hdpvr-video.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -157,6 +157,7 @@ int hdpvr_alloc_buffers(struct hdpvr_dev
 				  mem, dev->bulk_in_size,
 				  hdpvr_read_bulk_callback, buf);
 
+		buf->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 		buf->status = BUFSTAT_AVAILABLE;
 		list_add_tail(&buf->buff_list, &dev->free_buff_list);
 	}


