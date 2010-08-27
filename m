Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab0H0F5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 01:57:50 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59068 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab0H0F5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 01:57:43 -0400
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] drivers/media/video/em28xx: Remove potential NULL dereference
Date: Fri, 27 Aug 2010 07:57:18 +0200
Message-Id: <1282888640-27042-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282888640-27042-1-git-send-email-julia@diku.dk>
References: <1282888640-27042-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the NULL test is necessary, the initialization involving a dereference of
the tested value should be moved after the NULL test.

The sematic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/em28xx/em28xx-video.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 7b9ec6e..95a4b60 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -277,12 +277,13 @@ static void em28xx_copy_vbi(struct em28xx *dev,
 {
 	void *startwrite, *startread;
 	int  offset;
-	int bytesperline = dev->vbi_width;
+	int bytesperline;
 
 	if (dev == NULL) {
 		em28xx_isocdbg("dev is null\n");
 		return;
 	}
+	bytesperline = dev->vbi_width;
 
 	if (dma_q == NULL) {
 		em28xx_isocdbg("dma_q is null\n");

