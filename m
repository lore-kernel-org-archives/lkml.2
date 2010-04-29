Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab0D2Dmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 23:42:55 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:40342 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab0D2Dmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 23:42:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=VU92OG2RDxDhSrQHwwGKqF92Zt7jO5nwYwjMzRIMyTpwXccarRXnt1VwG4/iD5pis1
         qP3SFdgVOr6NevWqPFrbBoO+WyPLo0iPRNUfZi2oGZg4PcYbV6JOIYsppdWwaGNBymUD
         udOhtJ3q8E14vdXXUQwPLr3u6793k41CmCwFU=
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
Subject: [PATCH 3/5] v4l: Change users of video_ioctl2 to use unlocked_ioctl
Date: Thu, 29 Apr 2010 05:42:42 +0200
Message-Id: <1272512564-14683-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that video_ioctl2() got the bkl pushed down, update its users
to use .unlocked_ioctl instead of ioctl.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 drivers/media/common/saa7146_fops.c              |    2 +-
 drivers/media/radio/dsbr100.c                    |    2 +-
 drivers/media/radio/radio-aimslab.c              |    2 +-
 drivers/media/radio/radio-aztech.c               |    2 +-
 drivers/media/radio/radio-cadet.c                |    2 +-
 drivers/media/radio/radio-gemtek-pci.c           |    2 +-
 drivers/media/radio/radio-gemtek.c               |    2 +-
 drivers/media/radio/radio-maestro.c              |    2 +-
 drivers/media/radio/radio-maxiradio.c            |    2 +-
 drivers/media/radio/radio-miropcm20.c            |    2 +-
 drivers/media/radio/radio-mr800.c                |    2 +-
 drivers/media/radio/radio-rtrack2.c              |    2 +-
 drivers/media/radio/radio-sf16fmi.c              |    2 +-
 drivers/media/radio/radio-sf16fmr2.c             |    2 +-
 drivers/media/radio/radio-si4713.c               |    2 +-
 drivers/media/radio/radio-tea5764.c              |    2 +-
 drivers/media/radio/radio-terratec.c             |    2 +-
 drivers/media/radio/radio-timb.c                 |    2 +-
 drivers/media/radio/radio-trust.c                |    2 +-
 drivers/media/radio/radio-typhoon.c              |    2 +-
 drivers/media/radio/radio-zoltrix.c              |    2 +-
 drivers/media/radio/si470x/radio-si470x-common.c |    2 +-
 drivers/media/video/arv.c                        |    2 +-
 drivers/media/video/au0828/au0828-video.c        |   14 ++++++------
 drivers/media/video/bt8xx/bttv-driver.c          |   26 +++++++++++-----------
 drivers/media/video/cafe_ccic.c                  |   14 ++++++------
 drivers/media/video/cx18/cx18-streams.c          |   12 +++++-----
 drivers/media/video/cx231xx/cx231xx-video.c      |    4 +-
 drivers/media/video/cx23885/cx23885-417.c        |    2 +-
 drivers/media/video/cx23885/cx23885-video.c      |    4 +-
 drivers/media/video/cx88/cx88-blackbird.c        |    2 +-
 drivers/media/video/cx88/cx88-video.c            |    4 +-
 drivers/media/video/davinci/vpif_capture.c       |    2 +-
 drivers/media/video/davinci/vpif_display.c       |    2 +-
 drivers/media/video/em28xx/em28xx-video.c        |    4 +-
 drivers/media/video/meye.c                       |    2 +-
 drivers/media/video/omap24xxcam.c                |   10 ++++----
 drivers/media/video/pms.c                        |    2 +-
 drivers/media/video/s2255drv.c                   |   12 +++++-----
 drivers/media/video/saa7134/saa7134-empress.c    |   14 ++++++------
 drivers/media/video/saa7134/saa7134-video.c      |   26 +++++++++++-----------
 drivers/media/video/soc_camera.c                 |    2 +-
 drivers/media/video/stk-webcam.c                 |   14 ++++++------
 drivers/media/video/tlg2300/pd-radio.c           |    8 +++---
 drivers/media/video/tlg2300/pd-video.c           |    2 +-
 drivers/media/video/usbvision/usbvision-video.c  |    4 +-
 drivers/media/video/w9966.c                      |    2 +-
 drivers/media/video/zoran/zoran_driver.c         |   16 ++++++------
 drivers/media/video/zr364xx.c                    |   14 ++++++------
 drivers/staging/cx25821/cx25821-video0.c         |   14 ++++++------
 drivers/staging/cx25821/cx25821-video1.c         |   14 ++++++------
 drivers/staging/cx25821/cx25821-video2.c         |   14 ++++++------
 drivers/staging/cx25821/cx25821-video3.c         |   14 ++++++------
 drivers/staging/cx25821/cx25821-video4.c         |   14 ++++++------
 drivers/staging/cx25821/cx25821-video5.c         |   14 ++++++------
 drivers/staging/cx25821/cx25821-video6.c         |   14 ++++++------
 drivers/staging/cx25821/cx25821-video7.c         |   14 ++++++------
 drivers/staging/go7007/go7007-v4l2.c             |    2 +-
 drivers/staging/tm6000/tm6000-video.c            |    2 +-
 sound/i2c/other/tea575x-tuner.c                  |    2 +-
 60 files changed, 191 insertions(+), 191 deletions(-)

diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index fd8e1f4..2e76112 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -396,7 +396,7 @@ static const struct v4l2_file_operations video_fops =
 	.write		= fops_write,
 	.poll		= fops_poll,
 	.mmap		= fops_mmap,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static void vv_callback(struct saa7146_dev *dev, unsigned long status)
diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index ed9cd7a..c3e952f 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -605,7 +605,7 @@ static void usb_dsbr100_video_device_release(struct video_device *videodev)
 /* File system interface */
 static const struct v4l2_file_operations usb_dsbr100_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops usb_dsbr100_ioctl_ops = {
diff --git a/drivers/media/radio/radio-aimslab.c b/drivers/media/radio/radio-aimslab.c
index 5bf4985..39a647e 100644
--- a/drivers/media/radio/radio-aimslab.c
+++ b/drivers/media/radio/radio-aimslab.c
@@ -361,7 +361,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations rtrack_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops rtrack_ioctl_ops = {
diff --git a/drivers/media/radio/radio-aztech.c b/drivers/media/radio/radio-aztech.c
index c223113..53d48bb 100644
--- a/drivers/media/radio/radio-aztech.c
+++ b/drivers/media/radio/radio-aztech.c
@@ -324,7 +324,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 static const struct v4l2_file_operations aztech_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops aztech_ioctl_ops = {
diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 482d0f3..bf1656e 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -558,7 +558,7 @@ static const struct v4l2_file_operations cadet_fops = {
 	.open		= cadet_open,
 	.release       	= cadet_release,
 	.read		= cadet_read,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.poll		= cadet_poll,
 };
 
diff --git a/drivers/media/radio/radio-gemtek-pci.c b/drivers/media/radio/radio-gemtek-pci.c
index 7903967..7ab33e0 100644
--- a/drivers/media/radio/radio-gemtek-pci.c
+++ b/drivers/media/radio/radio-gemtek-pci.c
@@ -361,7 +361,7 @@ MODULE_DEVICE_TABLE(pci, gemtek_pci_id);
 
 static const struct v4l2_file_operations gemtek_pci_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops gemtek_pci_ioctl_ops = {
diff --git a/drivers/media/radio/radio-gemtek.c b/drivers/media/radio/radio-gemtek.c
index 73985f6..43d5466 100644
--- a/drivers/media/radio/radio-gemtek.c
+++ b/drivers/media/radio/radio-gemtek.c
@@ -378,7 +378,7 @@ static int gemtek_probe(struct gemtek *gt)
 
 static const struct v4l2_file_operations gemtek_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static int vidioc_querycap(struct file *file, void *priv,
diff --git a/drivers/media/radio/radio-maestro.c b/drivers/media/radio/radio-maestro.c
index 08f1051..0ad65ef 100644
--- a/drivers/media/radio/radio-maestro.c
+++ b/drivers/media/radio/radio-maestro.c
@@ -299,7 +299,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations maestro_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops maestro_ioctl_ops = {
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 4349213..2975f1c 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -346,7 +346,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 static const struct v4l2_file_operations maxiradio_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl          = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops maxiradio_ioctl_ops = {
diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 4ff8854..df4869f 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -72,7 +72,7 @@ static int pcm20_setfreq(struct pcm20 *dev, unsigned long freq)
 
 static const struct v4l2_file_operations pcm20_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static int vidioc_querycap(struct file *file, void *priv,
diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 02a9cef..8de8b2f 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -613,7 +613,7 @@ static const struct v4l2_file_operations usb_amradio_fops = {
 	.owner		= THIS_MODULE,
 	.open		= usb_amradio_open,
 	.release	= usb_amradio_close,
-	.ioctl		= usb_amradio_ioctl,
+	.unlocked_ioctl	= usb_amradio_ioctl,
 };
 
 static const struct v4l2_ioctl_ops usb_amradio_ioctl_ops = {
diff --git a/drivers/media/radio/radio-rtrack2.c b/drivers/media/radio/radio-rtrack2.c
index a79296a..12f4c1a 100644
--- a/drivers/media/radio/radio-rtrack2.c
+++ b/drivers/media/radio/radio-rtrack2.c
@@ -266,7 +266,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations rtrack2_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops rtrack2_ioctl_ops = {
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index 985359d..c3d1415 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -260,7 +260,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations fmi_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops fmi_ioctl_ops = {
diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index 52c7bbb..5a63e5c 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -376,7 +376,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations fmr2_fops = {
 	.owner          = THIS_MODULE,
-	.ioctl          = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops fmr2_ioctl_ops = {
diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 13554ab..9b6264d 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -53,7 +53,7 @@ struct radio_si4713_device {
 /* radio_si4713_fops - file operations interface */
 static const struct v4l2_file_operations radio_si4713_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 /* Video4Linux Interface */
diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 789d2ec..9d24996 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -492,7 +492,7 @@ static const struct v4l2_file_operations tea5764_fops = {
 	.owner		= THIS_MODULE,
 	.open           = tea5764_open,
 	.release        = tea5764_close,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops tea5764_ioctl_ops = {
diff --git a/drivers/media/radio/radio-terratec.c b/drivers/media/radio/radio-terratec.c
index fc1c860..e9f89e5 100644
--- a/drivers/media/radio/radio-terratec.c
+++ b/drivers/media/radio/radio-terratec.c
@@ -338,7 +338,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations terratec_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops terratec_ioctl_ops = {
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index b8bb3ef..083609d 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -142,7 +142,7 @@ static const struct v4l2_ioctl_ops timbradio_ioctl_ops = {
 
 static const struct v4l2_file_operations timbradio_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static int __devinit timbradio_probe(struct platform_device *pdev)
diff --git a/drivers/media/radio/radio-trust.c b/drivers/media/radio/radio-trust.c
index 9d6dcf8..c5813ff 100644
--- a/drivers/media/radio/radio-trust.c
+++ b/drivers/media/radio/radio-trust.c
@@ -344,7 +344,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 
 static const struct v4l2_file_operations trust_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops trust_ioctl_ops = {
diff --git a/drivers/media/radio/radio-typhoon.c b/drivers/media/radio/radio-typhoon.c
index 0343928..6c0431d 100644
--- a/drivers/media/radio/radio-typhoon.c
+++ b/drivers/media/radio/radio-typhoon.c
@@ -320,7 +320,7 @@ static int vidioc_log_status(struct file *file, void *priv)
 
 static const struct v4l2_file_operations typhoon_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops typhoon_ioctl_ops = {
diff --git a/drivers/media/radio/radio-zoltrix.c b/drivers/media/radio/radio-zoltrix.c
index f31eab9..72e4ecf 100644
--- a/drivers/media/radio/radio-zoltrix.c
+++ b/drivers/media/radio/radio-zoltrix.c
@@ -377,7 +377,7 @@ static int vidioc_s_audio(struct file *file, void *priv,
 static const struct v4l2_file_operations zoltrix_fops =
 {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops zoltrix_ioctl_ops = {
diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 47075fc..293f30a 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -516,7 +516,7 @@ static const struct v4l2_file_operations si470x_fops = {
 	.owner			= THIS_MODULE,
 	.read			= si470x_fops_read,
 	.poll			= si470x_fops_poll,
-	.ioctl			= video_ioctl2,
+	.unlocked_ioctl		= video_ioctl2,
 	.open			= si470x_fops_open,
 	.release		= si470x_fops_release,
 };
diff --git a/drivers/media/video/arv.c b/drivers/media/video/arv.c
index 31e7a12..f989f28 100644
--- a/drivers/media/video/arv.c
+++ b/drivers/media/video/arv.c
@@ -712,7 +712,7 @@ static int ar_initialize(struct ar *ar)
 static const struct v4l2_file_operations ar_fops = {
 	.owner		= THIS_MODULE,
 	.read		= ar_read,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops ar_ioctl_ops = {
diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index 6615021..206b31b 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -1512,13 +1512,13 @@ static int vidiocgmbuf(struct file *file, void *priv, struct video_mbuf *mbuf)
 #endif
 
 static struct v4l2_file_operations au0828_v4l_fops = {
-	.owner      = THIS_MODULE,
-	.open       = au0828_v4l2_open,
-	.release    = au0828_v4l2_close,
-	.read       = au0828_v4l2_read,
-	.poll       = au0828_v4l2_poll,
-	.mmap       = au0828_v4l2_mmap,
-	.ioctl      = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= au0828_v4l2_open,
+	.release	= au0828_v4l2_close,
+	.read		= au0828_v4l2_read,
+	.poll		= au0828_v4l2_poll,
+	.mmap		= au0828_v4l2_mmap,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 350e7af..a40f76b 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3338,13 +3338,13 @@ bttv_mmap(struct file *file, struct vm_area_struct *vma)
 
 static const struct v4l2_file_operations bttv_fops =
 {
-	.owner	  = THIS_MODULE,
-	.open	  = bttv_open,
-	.release  = bttv_release,
-	.ioctl	  = video_ioctl2,
-	.read	  = bttv_read,
-	.mmap	  = bttv_mmap,
-	.poll     = bttv_poll,
+	.owner		= THIS_MODULE,
+	.open		= bttv_open,
+	.release	= bttv_release,
+	.unlocked_ioctl	= video_ioctl2,
+	.read		= bttv_read,
+	.mmap		= bttv_mmap,
+	.poll		= bttv_poll,
 };
 
 static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
@@ -3611,12 +3611,12 @@ static unsigned int radio_poll(struct file *file, poll_table *wait)
 
 static const struct v4l2_file_operations radio_fops =
 {
-	.owner	  = THIS_MODULE,
-	.open	  = radio_open,
-	.read     = radio_read,
-	.release  = radio_release,
-	.ioctl	  = video_ioctl2,
-	.poll     = radio_poll,
+	.owner		= THIS_MODULE,
+	.open		= radio_open,
+	.read		= radio_read,
+	.release	= radio_release,
+	.unlocked_ioctl	= video_ioctl2,
+	.poll		= radio_poll,
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index be35e69..8182477 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -1685,13 +1685,13 @@ static int cafe_vidioc_s_register(struct file *file, void *priv,
  */
 
 static const struct v4l2_file_operations cafe_v4l_fops = {
-	.owner = THIS_MODULE,
-	.open = cafe_v4l_open,
-	.release = cafe_v4l_release,
-	.read = cafe_v4l_read,
-	.poll = cafe_v4l_poll,
-	.mmap = cafe_v4l_mmap,
-	.ioctl = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= cafe_v4l_open,
+	.release	= cafe_v4l_release,
+	.read		= cafe_v4l_read,
+	.poll		= cafe_v4l_poll,
+	.mmap		= cafe_v4l_mmap,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops cafe_v4l_ioctl_ops = {
diff --git a/drivers/media/video/cx18/cx18-streams.c b/drivers/media/video/cx18/cx18-streams.c
index 054450f..85e4b73 100644
--- a/drivers/media/video/cx18/cx18-streams.c
+++ b/drivers/media/video/cx18/cx18-streams.c
@@ -37,13 +37,13 @@
 #define CX18_DSP0_INTERRUPT_MASK     	0xd0004C
 
 static struct v4l2_file_operations cx18_v4l2_enc_fops = {
-	.owner = THIS_MODULE,
-	.read = cx18_v4l2_read,
-	.open = cx18_v4l2_open,
+	.owner		= THIS_MODULE,
+	.read		= cx18_v4l2_read,
+	.open		= cx18_v4l2_open,
 	/* FIXME change to video_ioctl2 if serialization lock can be removed */
-	.ioctl = cx18_v4l2_ioctl,
-	.release = cx18_v4l2_close,
-	.poll = cx18_v4l2_enc_poll,
+	.unlocked_ioctl = cx18_v4l2_ioctl,
+	.release	= cx18_v4l2_close,
+	.poll		= cx18_v4l2_enc_poll,
 };
 
 /* offset from 0 to register ts v4l2 minors on */
diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index 597c416..148e17a 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -2231,7 +2231,7 @@ static const struct v4l2_file_operations cx231xx_v4l_fops = {
 	.read    = cx231xx_v4l2_read,
 	.poll    = cx231xx_v4l2_poll,
 	.mmap    = cx231xx_v4l2_mmap,
-	.ioctl   = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -2289,7 +2289,7 @@ static const struct v4l2_file_operations radio_fops = {
 	.owner   = THIS_MODULE,
 	.open   = cx231xx_v4l2_open,
 	.release = cx231xx_v4l2_close,
-	.ioctl   = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
index abd64e8..568f4d6 100644
--- a/drivers/media/video/cx23885/cx23885-417.c
+++ b/drivers/media/video/cx23885/cx23885-417.c
@@ -1681,7 +1681,7 @@ static struct v4l2_file_operations mpeg_fops = {
 	.read	       = mpeg_read,
 	.poll          = mpeg_poll,
 	.mmap	       = mpeg_mmap,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 543b854..e3bed13 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -1387,7 +1387,7 @@ static const struct v4l2_file_operations video_fops = {
 	.read	       = video_read,
 	.poll          = video_poll,
 	.mmap	       = video_mmap,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -1439,7 +1439,7 @@ static const struct v4l2_file_operations radio_fops = {
 	.owner         = THIS_MODULE,
 	.open          = video_open,
 	.release       = video_release,
-	.ioctl         = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 
diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index e46e1ce..ca63ce2 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1174,7 +1174,7 @@ static const struct v4l2_file_operations mpeg_fops =
 	.read	       = mpeg_read,
 	.poll          = mpeg_poll,
 	.mmap	       = mpeg_mmap,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 0fab65c..25b19dd 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1683,7 +1683,7 @@ static const struct v4l2_file_operations video_fops =
 	.read	       = video_read,
 	.poll          = video_poll,
 	.mmap	       = video_mmap,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -1736,7 +1736,7 @@ static const struct v4l2_file_operations radio_fops =
 	.owner         = THIS_MODULE,
 	.open          = video_open,
 	.release       = video_release,
-	.ioctl         = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 2e5a7fb..408ecdf 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -1836,7 +1836,7 @@ static struct v4l2_file_operations vpif_fops = {
 	.owner = THIS_MODULE,
 	.open = vpif_open,
 	.release = vpif_release,
-	.ioctl = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.mmap = vpif_mmap,
 	.poll = vpif_poll
 };
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index e5bab3d..1adfc36 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -1340,7 +1340,7 @@ static const struct v4l2_file_operations vpif_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vpif_open,
 	.release	= vpif_release,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.mmap		= vpif_mmap,
 	.poll		= vpif_poll
 };
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index b6ac99d..dc4bb70 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -2387,7 +2387,7 @@ static const struct v4l2_file_operations em28xx_v4l_fops = {
 	.read          = em28xx_v4l2_read,
 	.poll          = em28xx_v4l2_poll,
 	.mmap          = em28xx_v4l2_mmap,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -2449,7 +2449,7 @@ static const struct v4l2_file_operations radio_fops = {
 	.owner         = THIS_MODULE,
 	.open          = em28xx_v4l2_open,
 	.release       = em28xx_v4l2_close,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
diff --git a/drivers/media/video/meye.c b/drivers/media/video/meye.c
index bb9fdb7..b581a3d 100644
--- a/drivers/media/video/meye.c
+++ b/drivers/media/video/meye.c
@@ -1659,7 +1659,7 @@ static const struct v4l2_file_operations meye_fops = {
 	.open		= meye_open,
 	.release	= meye_release,
 	.mmap		= meye_mmap,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.poll		= meye_poll,
 };
 
diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index 1c05017..6f15bd1 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -1554,11 +1554,11 @@ static int omap24xxcam_release(struct file *file)
 }
 
 static struct v4l2_file_operations omap24xxcam_fops = {
-	.ioctl	 = video_ioctl2,
-	.poll	 = omap24xxcam_poll,
-	.mmap	 = omap24xxcam_mmap,
-	.open	 = omap24xxcam_open,
-	.release = omap24xxcam_release,
+	.unlocked_ioctl	= video_ioctl2,
+	.poll		= omap24xxcam_poll,
+	.mmap		= omap24xxcam_mmap,
+	.open		= omap24xxcam_open,
+	.release	= omap24xxcam_release,
 };
 
 /*
diff --git a/drivers/media/video/pms.c b/drivers/media/video/pms.c
index 7129b50..7551907 100644
--- a/drivers/media/video/pms.c
+++ b/drivers/media/video/pms.c
@@ -932,7 +932,7 @@ static ssize_t pms_read(struct file *file, char __user *buf,
 
 static const struct v4l2_file_operations pms_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.read           = pms_read,
 };
 
diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 4dc001b..9db5968 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -1890,12 +1890,12 @@ static int s2255_mmap_v4l(struct file *file, struct vm_area_struct *vma)
 }
 
 static const struct v4l2_file_operations s2255_fops_v4l = {
-	.owner = THIS_MODULE,
-	.open = s2255_open,
-	.release = s2255_release,
-	.poll = s2255_poll,
-	.ioctl = video_ioctl2,	/* V4L2 ioctl handler */
-	.mmap = s2255_mmap_v4l,
+	.owner		= THIS_MODULE,
+	.open		= s2255_open,
+	.release	= s2255_release,
+	.poll		= s2255_poll,
+	.unlocked_ioctl	= video_ioctl2,	/* V4L2 ioctl handler */
+	.mmap		= s2255_mmap_v4l,
 };
 
 static const struct v4l2_ioctl_ops s2255_ioctl_ops = {
diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
index ea877a5..d503aae 100644
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -438,13 +438,13 @@ static int empress_g_std(struct file *file, void *priv, v4l2_std_id *id)
 
 static const struct v4l2_file_operations ts_fops =
 {
-	.owner	  = THIS_MODULE,
-	.open	  = ts_open,
-	.release  = ts_release,
-	.read	  = ts_read,
-	.poll	  = ts_poll,
-	.mmap	  = ts_mmap,
-	.ioctl	  = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= ts_open,
+	.release	= ts_release,
+	.read		= ts_read,
+	.poll		= ts_poll,
+	.mmap		= ts_mmap,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops ts_ioctl_ops = {
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 7806fb1..c142071 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -2409,13 +2409,13 @@ static int radio_queryctrl(struct file *file, void *priv,
 
 static const struct v4l2_file_operations video_fops =
 {
-	.owner	  = THIS_MODULE,
-	.open	  = video_open,
-	.release  = video_release,
-	.read	  = video_read,
-	.poll     = video_poll,
-	.mmap	  = video_mmap,
-	.ioctl	  = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.release	= video_release,
+	.read		= video_read,
+	.poll		= video_poll,
+	.mmap		= video_mmap,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -2470,12 +2470,12 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 };
 
 static const struct v4l2_file_operations radio_fops = {
-	.owner	  = THIS_MODULE,
-	.open	  = video_open,
-	.read     = radio_read,
-	.release  = video_release,
-	.ioctl	  = video_ioctl2,
-	.poll     = radio_poll,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.read		= radio_read,
+	.release	= video_release,
+	.unlocked_ioctl	= video_ioctl2,
+	.poll		= radio_poll,
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 30f5c41..04fb6cf 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -513,7 +513,7 @@ static struct v4l2_file_operations soc_camera_fops = {
 	.owner		= THIS_MODULE,
 	.open		= soc_camera_open,
 	.release	= soc_camera_close,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.read		= soc_camera_read,
 	.mmap		= soc_camera_mmap,
 	.poll		= soc_camera_poll,
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index f07a0f6..fb993c8 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -1263,13 +1263,13 @@ static int stk_vidioc_enum_framesizes(struct file *filp,
 }
 
 static struct v4l2_file_operations v4l_stk_fops = {
-	.owner = THIS_MODULE,
-	.open = v4l_stk_open,
-	.release = v4l_stk_release,
-	.read = v4l_stk_read,
-	.poll = v4l_stk_poll,
-	.mmap = v4l_stk_mmap,
-	.ioctl = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= v4l_stk_open,
+	.release	= v4l_stk_release,
+	.read		= v4l_stk_read,
+	.poll		= v4l_stk_poll,
+	.mmap		= v4l_stk_mmap,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops v4l_stk_ioctl_ops = {
diff --git a/drivers/media/video/tlg2300/pd-radio.c b/drivers/media/video/tlg2300/pd-radio.c
index fae84c2..29a4d7f 100644
--- a/drivers/media/video/tlg2300/pd-radio.c
+++ b/drivers/media/video/tlg2300/pd-radio.c
@@ -155,10 +155,10 @@ static int vidioc_querycap(struct file *file, void *priv,
 }
 
 static const struct v4l2_file_operations poseidon_fm_fops = {
-	.owner         = THIS_MODULE,
-	.open          = poseidon_fm_open,
-	.release       = poseidon_fm_close,
-	.ioctl	       = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= poseidon_fm_open,
+	.release	= poseidon_fm_close,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static int tlg_fm_vidioc_g_tuner(struct file *file, void *priv,
diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/video/tlg2300/pd-video.c
index c750fd1..0e95a3d 100644
--- a/drivers/media/video/tlg2300/pd-video.c
+++ b/drivers/media/video/tlg2300/pd-video.c
@@ -1542,7 +1542,7 @@ static const struct v4l2_file_operations pd_video_fops = {
 	.read		= pd_video_read,
 	.poll		= pd_video_poll,
 	.mmap		= pd_video_mmap,
-	.ioctl		= video_ioctl2, /* maybe changed in future */
+	.unlocked_ioctl	= video_ioctl2, /* maybe changed in future */
 };
 
 static const struct v4l2_ioctl_ops pd_video_ioctl_ops = {
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index d91f016..0f47f4a 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -1251,7 +1251,7 @@ static const struct v4l2_file_operations usbvision_fops = {
 	.release	= usbvision_v4l2_close,
 	.read		= usbvision_v4l2_read,
 	.mmap		= usbvision_v4l2_mmap,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 /* 	.poll          = video_poll, */
 };
 
@@ -1304,7 +1304,7 @@ static const struct v4l2_file_operations usbvision_radio_fops = {
 	.owner             = THIS_MODULE,
 	.open		= usbvision_radio_open,
 	.release	= usbvision_radio_close,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops usbvision_radio_ioctl_ops = {
diff --git a/drivers/media/video/w9966.c b/drivers/media/video/w9966.c
index 635420d..42d5661 100644
--- a/drivers/media/video/w9966.c
+++ b/drivers/media/video/w9966.c
@@ -815,7 +815,7 @@ out:
 
 static const struct v4l2_file_operations w9966_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl          = video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.read           = w9966_v4l_read,
 };
 
diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
index 6f89d0a..85bbf58 100644
--- a/drivers/media/video/zoran/zoran_driver.c
+++ b/drivers/media/video/zoran/zoran_driver.c
@@ -3371,14 +3371,14 @@ static const struct v4l2_ioctl_ops zoran_ioctl_ops = {
 };
 
 static const struct v4l2_file_operations zoran_fops = {
-	.owner = THIS_MODULE,
-	.open = zoran_open,
-	.release = zoran_close,
-	.ioctl = video_ioctl2,
-	.read = zoran_read,
-	.write = zoran_write,
-	.mmap = zoran_mmap,
-	.poll = zoran_poll,
+	.owner		= THIS_MODULE,
+	.open		= zoran_open,
+	.release	= zoran_close,
+	.unlocked_ioctl	= video_ioctl2,
+	.read		= zoran_read,
+	.write		= zoran_write,
+	.mmap		= zoran_mmap,
+	.poll		= zoran_poll,
 };
 
 struct video_device zoran_template __devinitdata = {
diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index a82b5bd..35a53e0 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -1438,13 +1438,13 @@ static unsigned int zr364xx_poll(struct file *file,
 }
 
 static const struct v4l2_file_operations zr364xx_fops = {
-	.owner = THIS_MODULE,
-	.open = zr364xx_open,
-	.release = zr364xx_release,
-	.read = zr364xx_read,
-	.mmap = zr364xx_mmap,
-	.ioctl = video_ioctl2,
-	.poll = zr364xx_poll,
+	.owner		= THIS_MODULE,
+	.open		= zr364xx_open,
+	.release	= zr364xx_release,
+	.read		= zr364xx_read,
+	.mmap		= zr364xx_mmap,
+	.unlocked_ioctl	= video_ioctl2,
+	.poll		= zr364xx_poll,
 };
 
 static const struct v4l2_ioctl_ops zr364xx_ioctl_ops = {
diff --git a/drivers/staging/cx25821/cx25821-video0.c b/drivers/staging/cx25821/cx25821-video0.c
index 1f95ddb..c8727db 100644
--- a/drivers/staging/cx25821/cx25821-video0.c
+++ b/drivers/staging/cx25821/cx25821-video0.c
@@ -373,13 +373,13 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 // exported stuff
 static const struct v4l2_file_operations video_fops = {
-	.owner = THIS_MODULE,
-	.open = video_open,
-	.release = video_release,
-	.read = video_read,
-	.poll = video_poll,
-	.mmap = cx25821_video_mmap,
-	.ioctl = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.release	= video_release,
+	.read		= video_read,
+	.poll		= video_poll,
+	.mmap		= cx25821_video_mmap,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
diff --git a/drivers/staging/cx25821/cx25821-video1.c b/drivers/staging/cx25821/cx25821-video1.c
index 9b94462..2fd02d7 100644
--- a/drivers/staging/cx25821/cx25821-video1.c
+++ b/drivers/staging/cx25821/cx25821-video1.c
@@ -373,13 +373,13 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 //exported stuff
 static const struct v4l2_file_operations video_fops = {
-	.owner = THIS_MODULE,
-	.open = video_open,
-	.release = video_release,
-	.read = video_read,
-	.poll = video_poll,
-	.mmap = cx25821_video_mmap,
-	.ioctl = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.release	= video_release,
+	.read		= video_read,
+	.poll		= video_poll,
+	.mmap		= cx25821_video_mmap,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
diff --git a/drivers/staging/cx25821/cx25821-video2.c b/drivers/staging/cx25821/cx25821-video2.c
index 31c46aa..bdcca2b 100644
--- a/drivers/staging/cx25821/cx25821-video2.c
+++ b/drivers/staging/cx25821/cx25821-video2.c
@@ -375,13 +375,13 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 // exported stuff
 static const struct v4l2_file_operations video_fops = {
-	.owner = THIS_MODULE,
-	.open = video_open,
-	.release = video_release,
-	.read = video_read,
-	.poll = video_poll,
-	.mmap = cx25821_video_mmap,
-	.ioctl = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.release	= video_release,
+	.read		= video_read,
+	.poll		= video_poll,
+	.mmap		= cx25821_video_mmap,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
diff --git a/drivers/staging/cx25821/cx25821-video3.c b/drivers/staging/cx25821/cx25821-video3.c
index cbc5cad..48e54af 100644
--- a/drivers/staging/cx25821/cx25821-video3.c
+++ b/drivers/staging/cx25821/cx25821-video3.c
@@ -374,13 +374,13 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 // exported stuff
 static const struct v4l2_file_operations video_fops = {
-	.owner = THIS_MODULE,
-	.open = video_open,
-	.release = video_release,
-	.read = video_read,
-	.poll = video_poll,
-	.mmap = cx25821_video_mmap,
-	.ioctl = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.release	= video_release,
+	.read		= video_read,
+	.poll		= video_poll,
+	.mmap		= cx25821_video_mmap,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
diff --git a/drivers/staging/cx25821/cx25821-video4.c b/drivers/staging/cx25821/cx25821-video4.c
index 101074a..abd8bda 100644
--- a/drivers/staging/cx25821/cx25821-video4.c
+++ b/drivers/staging/cx25821/cx25821-video4.c
@@ -373,13 +373,13 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 // exported stuff
 static const struct v4l2_file_operations video_fops = {
-	.owner = THIS_MODULE,
-	.open = video_open,
-	.release = video_release,
-	.read = video_read,
-	.poll = video_poll,
-	.mmap = cx25821_video_mmap,
-	.ioctl = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.release	= video_release,
+	.read		= video_read,
+	.poll		= video_poll,
+	.mmap		= cx25821_video_mmap,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
diff --git a/drivers/staging/cx25821/cx25821-video5.c b/drivers/staging/cx25821/cx25821-video5.c
index 2019c5e..003266e 100644
--- a/drivers/staging/cx25821/cx25821-video5.c
+++ b/drivers/staging/cx25821/cx25821-video5.c
@@ -373,13 +373,13 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 // exported stuff
 static const struct v4l2_file_operations video_fops = {
-	.owner = THIS_MODULE,
-	.open = video_open,
-	.release = video_release,
-	.read = video_read,
-	.poll = video_poll,
-	.mmap = cx25821_video_mmap,
-	.ioctl = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.release	= video_release,
+	.read		= video_read,
+	.poll		= video_poll,
+	.mmap		= cx25821_video_mmap,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
diff --git a/drivers/staging/cx25821/cx25821-video6.c b/drivers/staging/cx25821/cx25821-video6.c
index d19c786..a838251 100644
--- a/drivers/staging/cx25821/cx25821-video6.c
+++ b/drivers/staging/cx25821/cx25821-video6.c
@@ -373,13 +373,13 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 // exported stuff
 static const struct v4l2_file_operations video_fops = {
-	.owner = THIS_MODULE,
-	.open = video_open,
-	.release = video_release,
-	.read = video_read,
-	.poll = video_poll,
-	.mmap = cx25821_video_mmap,
-	.ioctl = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.release	= video_release,
+	.read		= video_read,
+	.poll		= video_poll,
+	.mmap		= cx25821_video_mmap,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
diff --git a/drivers/staging/cx25821/cx25821-video7.c b/drivers/staging/cx25821/cx25821-video7.c
index 8a7c854..6fd6115 100644
--- a/drivers/staging/cx25821/cx25821-video7.c
+++ b/drivers/staging/cx25821/cx25821-video7.c
@@ -372,13 +372,13 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 
 // exported stuff
 static const struct v4l2_file_operations video_fops = {
-	.owner = THIS_MODULE,
-	.open = video_open,
-	.release = video_release,
-	.read = video_read,
-	.poll = video_poll,
-	.mmap = cx25821_video_mmap,
-	.ioctl = video_ioctl2,
+	.owner		= THIS_MODULE,
+	.open		= video_open,
+	.release	= video_release,
+	.read		= video_read,
+	.poll		= video_poll,
+	.mmap		= cx25821_video_mmap,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
diff --git a/drivers/staging/go7007/go7007-v4l2.c b/drivers/staging/go7007/go7007-v4l2.c
index 723c1a6..b71fb3f 100644
--- a/drivers/staging/go7007/go7007-v4l2.c
+++ b/drivers/staging/go7007/go7007-v4l2.c
@@ -1743,7 +1743,7 @@ static struct v4l2_file_operations go7007_fops = {
 	.owner		= THIS_MODULE,
 	.open		= go7007_open,
 	.release	= go7007_release,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 	.read		= go7007_read,
 	.mmap		= go7007_mmap,
 	.poll		= go7007_poll,
diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
index c53de47..b2db64b 100644
--- a/drivers/staging/tm6000/tm6000-video.c
+++ b/drivers/staging/tm6000/tm6000-video.c
@@ -1455,7 +1455,7 @@ static struct v4l2_file_operations tm6000_fops = {
 	.owner		= THIS_MODULE,
 	.open           = tm6000_open,
 	.release        = tm6000_release,
-	.ioctl          = video_ioctl2, /* V4L2 ioctl handler */
+	.unlocked_ioctl	= video_ioctl2, /* V4L2 ioctl handler */
 	.read           = tm6000_read,
 	.poll		= tm6000_poll,
 	.mmap		= tm6000_mmap,
diff --git a/sound/i2c/other/tea575x-tuner.c b/sound/i2c/other/tea575x-tuner.c
index ee538f1..aad79f4 100644
--- a/sound/i2c/other/tea575x-tuner.c
+++ b/sound/i2c/other/tea575x-tuner.c
@@ -265,7 +265,7 @@ static const struct v4l2_file_operations tea575x_fops = {
 	.owner		= THIS_MODULE,
 	.open           = snd_tea575x_exclusive_open,
 	.release        = snd_tea575x_exclusive_release,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops tea575x_ioctl_ops = {
-- 
1.6.2.3

