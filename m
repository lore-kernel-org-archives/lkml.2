Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab0D2Dnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 23:43:51 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44510 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab0D2Dmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 23:42:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=TDhojqi+5CrTwkAFPdieSqYAcAS/HPQgkkrPa4UsssqZvnGCglhYOxn5Gz76spULKy
         zaAJh1QGLomBJbh/9q1VJrH969Z7m6GcE/oMyMy2YPjKk9FPq+bY9fmqlESSMnR4rZLH
         BGQCmhz6Bkrd9PvmVtrZU/8J5jyoQWam4WJ6A=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/5] v4l: Use video_ioctl2_unlocked from drivers that don't want the bkl
Date: Thu, 29 Apr 2010 05:42:41 +0200
Message-Id: <1272512564-14683-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three drivers that use video_ioctl2() as an unlocked_ioctl,
let them use the new video_ioctl2_unlocked.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/media/video/davinci/vpfe_capture.c |    2 +-
 drivers/media/video/gspca/gspca.c          |    2 +-
 drivers/media/video/hdpvr/hdpvr-video.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index aa1411f..61a3514 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -786,7 +786,7 @@ static const struct v4l2_file_operations vpfe_fops = {
 	.owner = THIS_MODULE,
 	.open = vpfe_open,
 	.release = vpfe_release,
-	.unlocked_ioctl = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2_unlocked,
 	.mmap = vpfe_mmap,
 	.poll = vpfe_poll
 };
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 68a8431..a424c1d 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -2184,7 +2184,7 @@ static struct v4l2_file_operations dev_fops = {
 	.release = dev_close,
 	.read = dev_read,
 	.mmap = dev_mmap,
-	.unlocked_ioctl = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2_unlocked,
 	.poll	= dev_poll,
 };
 
diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/video/hdpvr/hdpvr-video.c
index 196f82d..01b8a34 100644
--- a/drivers/media/video/hdpvr/hdpvr-video.c
+++ b/drivers/media/video/hdpvr/hdpvr-video.c
@@ -559,7 +559,7 @@ static const struct v4l2_file_operations hdpvr_fops = {
 	.release	= hdpvr_release,
 	.read		= hdpvr_read,
 	.poll		= hdpvr_poll,
-	.unlocked_ioctl	= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2_unlocked,
 };
 
 /*=======================================================================*/
-- 
1.6.2.3

