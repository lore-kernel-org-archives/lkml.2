Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab2KPG5J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:57:09 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57791 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab2KPG5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:57:07 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 03/14] [media] saa7134: Remove redundant check on unsigned variable
Date: Fri, 16 Nov 2012 12:20:35 +0530
Message-Id: <1353048646-10935-4-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to check whether the unsigned variable is less than 0.

CC: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/media/pci/saa7134/saa7134-video.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 4a77124..3abf527 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2511,7 +2511,7 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	/* sanitycheck insmod options */
 	if (gbuffers < 2 || gbuffers > VIDEO_MAX_FRAME)
 		gbuffers = 2;
-	if (gbufsize < 0 || gbufsize > gbufsize_max)
+	if (gbufsize > gbufsize_max)
 		gbufsize = gbufsize_max;
 	gbufsize = (gbufsize + PAGE_SIZE - 1) & PAGE_MASK;
 
-- 
1.7.4.1

