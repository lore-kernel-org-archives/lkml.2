Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1BGIuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 03:50:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57379 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1BGIuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 03:50:16 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Tejun Heo <tj@kernel.org>,
        Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH resend] video: omap24xxcam: Fix compilation
Date: Mon,  7 Feb 2011 09:49:07 +0100
Message-Id: <1297068547-10635-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc3
X-Provags-ID: V02:K0:na7SrUfzrgc9dMp8HQ4m+Ox8OmC1iyoxD6UJVrCq2/4
 J0YcnBhEGz2uaTaPt1p4fli8PYVUCgqitZzw7TMduPHanqonKB
 ZVk2QIlpAp3k4aWKb3PZlqrnWulBf98QuRdsUReZJF19we8kEG
 ypQSI10uqXL6yFaXIi32Dtx4Jc5KvBq3xQSgRdyo17QkkyAlz1
 sxRnNlMJbNvi+hB8BiUIQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add linux/sched.h because of missing declaration of TASK_NORMAL.

This patch fixes the following error:

drivers/media/video/omap24xxcam.c: In function
'omap24xxcam_vbq_complete':
drivers/media/video/omap24xxcam.c:415: error: 'TASK_NORMAL' undeclared
(first use in this function)
drivers/media/video/omap24xxcam.c:415: error: (Each undeclared
identifier is reported only once
drivers/media/video/omap24xxcam.c:415: error: for each function it
appears in.)

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 drivers/media/video/omap24xxcam.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index 0175527..f6626e8 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -36,6 +36,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
-- 
1.7.4.rc3

