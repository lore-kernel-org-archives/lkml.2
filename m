Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab2DXXM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:12:57 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:3501 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2DXXMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:12:55 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1335309174!4683563!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] media: videobuf2-dma-contig: quiet sparse noise about plain integer as NULL pointer
Date: Tue, 24 Apr 2012 16:12:48 -0700
User-Agent: KMail/1.9.9
CC: <linux-media@vger.kernel.org>, <pawel@osciak.com>,
        <m.szyprowski@samsung.com>, <kyungmin.park@samsung.com>,
        <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201204241612.49058.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function vb2_dma_contig_vaddr returns a void * not an integer.

Quiets the sparse noise:

warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Pawel Osciak <pawel@osciak.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---

diff --git a/drivers/media/video/videobuf2-dma-contig.c b/drivers/media/video/videobuf2-dma-contig.c
index f17ad98..7de6843 100644
--- a/drivers/media/video/videobuf2-dma-contig.c
+++ b/drivers/media/video/videobuf2-dma-contig.c
@@ -85,7 +85,7 @@ static void *vb2_dma_contig_vaddr(void *buf_priv)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 	if (!buf)
-		return 0;
+		return NULL;
 
 	return buf->vaddr;
 }
