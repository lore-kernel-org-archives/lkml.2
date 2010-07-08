Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab0GHEqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 00:46:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40300 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0GHEqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 00:46:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MmjbPIgFEGiSgm1itIOKTwUCukAQUA2xReZQUdC+IkFLHPTq3OjiKT3SpApmP2BFHo
         WfaY8vDc26TAyhqFXBBUhq5gRko4ILtwdWMwgN9irJ+kaL5Mywnt1GJkSVx1gF9DACE8
         7rV8AQqY/i7023HsEndw6ikR9wXXUwbvjPxRk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-media@vger.kernel.org
Cc: moinejf@free.fr, mchehab@infradead.org, linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]video:gspca.c Fix  warning: case value '7' not in enumerated type 'enum v4l2_memory'
Date: Wed,  7 Jul 2010 21:46:18 -0700
Message-Id: <1278564378-19855-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a warning I'm seeing when building:
  CC [M]  drivers/media/video/gspca/gspca.o
drivers/media/video/gspca/gspca.c: In function 'vidioc_reqbufs':
drivers/media/video/gspca/gspca.c:1508:2: warning: case value '7' not in enumerated type 'enum v4l2_memory'

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/video/gspca/gspca.c |    1 -
 include/linux/videodev2.h         |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 678675b..a9b4d97 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -84,7 +84,6 @@ static void PDEBUG_MODE(char *txt, __u32 pixfmt, int w, int h)
 
 /* specific memory types - !! should be different from V4L2_MEMORY_xxx */
 #define GSPCA_MEMORY_NO 0	/* V4L2_MEMORY_xxx starts from 1 */
-#define GSPCA_MEMORY_READ 7
 
 #define BUF_ALL_FLAGS (V4L2_BUF_FLAG_QUEUED | V4L2_BUF_FLAG_DONE)
 
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 047f7e6..b73aa18 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -170,6 +170,7 @@ enum v4l2_memory {
 	V4L2_MEMORY_MMAP             = 1,
 	V4L2_MEMORY_USERPTR          = 2,
 	V4L2_MEMORY_OVERLAY          = 3,
+	GSPCA_MEMORY_READ 	     = 7,
 };
 
 /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
-- 
1.7.1.rc1.21.gf3bd6

