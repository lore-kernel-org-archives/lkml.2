Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438Ab0HLRqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:46:11 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:50286 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab0HLRqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:46:10 -0400
Date: Thu, 12 Aug 2010 20:46:07 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: linux-media@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix v4l2-ctrls compilation
Message-ID: <alpine.SOC.1.00.1008122042270.24365@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current git has broken v4l2-ctrls compilation - kzalloc et al are 
missing prototypes. Fix it by including linux/slab.h that contains the 
definitions.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 84c1a53..ea8d32c 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -19,6 +19,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>

-- 
Meelis Roos <mroos@linux.ee>
