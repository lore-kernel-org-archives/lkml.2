Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1BHITP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 03:19:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50068 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1BHITO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 03:19:14 -0500
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, Tejun Heo <tj@kernel.org>,
        Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCHv2] media/video: Fix compilation of omap24xxcam
Date: Tue,  8 Feb 2011 09:18:21 +0100
Message-Id: <1297153101-23680-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.4.rc3
X-Provags-ID: V02:K0:ec2TvJcThZ74s4gTZcuTc07IajXxDMY/CJL8Ph48W4q
 tfr5xWPPMwdne2aJukW7WxJgl/fvsPRz4M07qA1DiEthcJ1Awg
 paxOFZ+pni5Yiesh8yDT2hnrUVC9xxlQFIBPZPnvz5Cix2IpbO
 zVKvpTn5ygET/W096jVzFinH9rQzeXFtYxfG6s5H4VzKWQ7E3z
 knTpkcC5t55FHf6A/pb8g==
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
Changelog:
	v2: Change subject line to media/video

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

