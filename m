Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab0D2Dmt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 23:42:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64193 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab0D2Dmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 23:42:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=SDgP0RdImSllNPGvoJIc0Nvu9xnt4nFd1qTHec5uGS+2bvCD3hPiVIVLo7JCO7Dr3n
         d/yVpNkiTuNY0smfCLth6Z7K/uTW9mwJ0k7H5iYkh41MCcmlq7CRdZ5T3lqppLA31zgU
         JdB2G2ayjKd/4MTbVcskAE9XQRhjdUXtBxjo0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, Greg KH <gregkh@suse.de>,
       Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/5] Pushdown bkl from v4l ioctls
Date: Thu, 29 Apr 2010 05:42:39 +0200
Message-Id: <1272512564-14683-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004280750330.3739@i5.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Linus suggested to rename struct v4l2_file_operations::ioctl
into bkl_ioctl to eventually get something greppable and make
its background explicit.

While at it I thought it could be a good idea to just pushdown
the bkl to every v4l drivers that have an .ioctl, so that we
actually remove struct v4l2_file_operations::ioctl for good.

It passed make allyesconfig on sparc.
Please tell me what you think.

Thanks.

Frederic Weisbecker (5):
      v4l: Pushdown bkl into video_ioctl2
      v4l: Use video_ioctl2_unlocked from drivers that don't want the bkl
      v4l: Change users of video_ioctl2 to use unlocked_ioctl
      v4l: Pushdown bkl to drivers that implement their own ioctl
      v4l: Remove struct v4l2_file_operations::ioctl

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
 drivers/media/video/au0828/au0828-video.c        |   14 ++++----
 drivers/media/video/bt8xx/bttv-driver.c          |   26 +++++++-------
 drivers/media/video/bw-qcam.c                    |   11 +++++-
 drivers/media/video/c-qcam.c                     |   11 +++++-
 drivers/media/video/cafe_ccic.c                  |   14 ++++----
 drivers/media/video/cpia.c                       |   11 +++++-
 drivers/media/video/cpia2/cpia2_v4l.c            |   11 +++++-
 drivers/media/video/cx18/cx18-streams.c          |   12 +++---
 drivers/media/video/cx231xx/cx231xx-video.c      |    4 +-
 drivers/media/video/cx23885/cx23885-417.c        |    2 +-
 drivers/media/video/cx23885/cx23885-video.c      |    4 +-
 drivers/media/video/cx88/cx88-blackbird.c        |    2 +-
 drivers/media/video/cx88/cx88-video.c            |    4 +-
 drivers/media/video/davinci/vpfe_capture.c       |    2 +-
 drivers/media/video/davinci/vpif_capture.c       |    2 +-
 drivers/media/video/davinci/vpif_display.c       |    2 +-
 drivers/media/video/em28xx/em28xx-video.c        |    4 +-
 drivers/media/video/et61x251/et61x251_core.c     |   27 +++++++++++----
 drivers/media/video/gspca/gspca.c                |    2 +-
 drivers/media/video/hdpvr/hdpvr-video.c          |    2 +-
 drivers/media/video/meye.c                       |    2 +-
 drivers/media/video/omap24xxcam.c                |   10 +++---
 drivers/media/video/ov511.c                      |   15 +++++---
 drivers/media/video/pms.c                        |    2 +-
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c       |   20 +++++++----
 drivers/media/video/pwc/pwc-if.c                 |   19 ++++++----
 drivers/media/video/s2255drv.c                   |   12 +++---
 drivers/media/video/saa5246a.c                   |   11 ++++--
 drivers/media/video/saa5249.c                    |    6 +++-
 drivers/media/video/saa7134/saa7134-empress.c    |   14 ++++----
 drivers/media/video/saa7134/saa7134-video.c      |   26 +++++++-------
 drivers/media/video/se401.c                      |   20 +++++++----
 drivers/media/video/sn9c102/sn9c102_core.c       |   27 +++++++++++----
 drivers/media/video/soc_camera.c                 |    2 +-
 drivers/media/video/stk-webcam.c                 |   14 ++++----
 drivers/media/video/stradis.c                    |   26 +++++++++++----
 drivers/media/video/stv680.c                     |   20 +++++++----
 drivers/media/video/tlg2300/pd-radio.c           |    8 ++--
 drivers/media/video/tlg2300/pd-video.c           |    2 +-
 drivers/media/video/usbvideo/usbvideo.c          |   21 ++++++++----
 drivers/media/video/usbvideo/vicam.c             |   14 +++++++-
 drivers/media/video/usbvision/usbvision-video.c  |    4 +-
 drivers/media/video/uvc/uvc_v4l2.c               |   11 +++++-
 drivers/media/video/v4l2-dev.c                   |   38 ++-------------------
 drivers/media/video/v4l2-ioctl.c                 |   17 ++++++++-
 drivers/media/video/vivi.c                       |    2 +-
 drivers/media/video/w9966.c                      |    2 +-
 drivers/media/video/w9968cf.c                    |   25 +++++++++++---
 drivers/media/video/zc0301/zc0301_core.c         |   27 +++++++++++----
 drivers/media/video/zoran/zoran_driver.c         |   16 ++++----
 drivers/media/video/zr364xx.c                    |   14 ++++----
 drivers/staging/cx25821/cx25821-audups11.c       |   18 ++++++----
 drivers/staging/cx25821/cx25821-video0.c         |   14 ++++----
 drivers/staging/cx25821/cx25821-video1.c         |   14 ++++----
 drivers/staging/cx25821/cx25821-video2.c         |   14 ++++----
 drivers/staging/cx25821/cx25821-video3.c         |   14 ++++----
 drivers/staging/cx25821/cx25821-video4.c         |   14 ++++----
 drivers/staging/cx25821/cx25821-video5.c         |   14 ++++----
 drivers/staging/cx25821/cx25821-video6.c         |   14 ++++----
 drivers/staging/cx25821/cx25821-video7.c         |   14 ++++----
 drivers/staging/cx25821/cx25821-videoioctl.c     |   27 +++++++++++----
 drivers/staging/cx25821/cx25821-vidups10.c       |   19 +++++++----
 drivers/staging/cx25821/cx25821-vidups9.c        |   18 ++++++----
 drivers/staging/dream/camera/msm_v4l2.c          |   27 +++++++++++----
 drivers/staging/go7007/go7007-v4l2.c             |    2 +-
 drivers/staging/tm6000/tm6000-video.c            |    2 +-
 include/media/v4l2-dev.h                         |    1 -
 include/media/v4l2-ioctl.h                       |    2 +
 sound/i2c/other/tea575x-tuner.c                  |    2 +-
 92 files changed, 530 insertions(+), 360 deletions(-)
