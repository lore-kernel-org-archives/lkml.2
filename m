Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553Ab1F1Qfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:35:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758913Ab1F1QcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:32:16 -0400
Date: Mon, 27 Jun 2011 23:17:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 00/13] Remove linux/version.h from most drivers/media/
Message-ID: <20110627231735.3682c84a@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the V4L2 API, one of the fields of VIDIOC_QUERYCAP requires the usage
of KERNEL_VERSION macro, in order to provide the driver version. However,
this is not handled consistently across subsystems. There are very few
drivers that take it seriously.

So, instead of the current way, let's replace it by a subsystem version.
After this patch series, only 4 drivers will keep including linux/version.h
on their c files, as they don't use the V4L2 core ioctl handler
(uvc, pvrusb2, sn9c102 and et61x251).

After this patch series, if VIDIOC_QUERYCAP returns version 3.x.y,
with x > 0, then userspace applications can be sure that the V4L2 core
is using V4L2 API version 3.x.y.

-

The version 2 of this patch series removes the patches that were
replacing -EINVAL error code when an ioctl is not implemented, as
more changes will likely be needed at the DocBook and on drivers,
in order to fix the inconsistencies. I'll be working on that and
submit those changes later.

Per Jean-Francois request, I broke the gspca patch into a separate
one, and simplified the info() call.

Also added Hans ack into the patch series.

Mauro Carvalho Chehab (13):
  [media] v4l2-ioctl: Add a default value for kernel version
  [media] drxd, siano: Remove unused include linux/version.h
  [media] Stop using linux/version.h on most video drivers
  [media] pwc: Use the default version for VIDIOC_QUERYCAP
  [media] ivtv,cx18: Use default version control for VIDIOC_QUERYCAP
  [media] et61x251: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
  [media] pvrusb2: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
  [media] sn9c102: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
  [media] uvcvideo: Use LINUX_VERSION_CODE for VIDIOC_QUERYCAP
  [media] gspca: don't include linux/version.h
  [media] Stop using linux/version.h the remaining video drivers
  [media] radio: Use the subsystem version control for VIDIOC_QUERYCAP
  [media] DocBook/v4l: Document the new system-wide version behavior

 Documentation/DocBook/media/v4l/common.xml         |   10 ++++++++-
 Documentation/DocBook/media/v4l/v4l2.xml           |    6 +++++
 .../DocBook/media/v4l/vidioc-querycap.xml          |   15 ++++++++-----
 drivers/media/dvb/frontends/drxd_hard.c            |    1 -
 drivers/media/dvb/siano/smscoreapi.h               |    1 -
 drivers/media/radio/dsbr100.c                      |    7 +----
 drivers/media/radio/radio-aimslab.c                |    5 +---
 drivers/media/radio/radio-aztech.c                 |    5 +---
 drivers/media/radio/radio-cadet.c                  |    5 +---
 drivers/media/radio/radio-gemtek.c                 |    7 +----
 drivers/media/radio/radio-maxiradio.c              |   10 +++-----
 drivers/media/radio/radio-mr800.c                  |    6 +---
 drivers/media/radio/radio-rtrack2.c                |    5 +---
 drivers/media/radio/radio-sf16fmi.c                |    5 +---
 drivers/media/radio/radio-tea5764.c                |    6 +---
 drivers/media/radio/radio-terratec.c               |    5 +---
 drivers/media/radio/radio-timb.c                   |    3 +-
 drivers/media/radio/radio-trust.c                  |    5 +---
 drivers/media/radio/radio-typhoon.c                |    9 +++----
 drivers/media/radio/radio-zoltrix.c                |    5 +---
 drivers/media/radio/si470x/radio-si470x-i2c.c      |    4 +--
 drivers/media/radio/si470x/radio-si470x-usb.c      |    2 -
 drivers/media/radio/si470x/radio-si470x.h          |    1 -
 drivers/media/radio/wl128x/fmdrv.h                 |    5 +---
 drivers/media/radio/wl128x/fmdrv_v4l2.c            |    1 -
 drivers/media/video/arv.c                          |    5 +--
 drivers/media/video/au0828/au0828-core.c           |    1 +
 drivers/media/video/au0828/au0828-video.c          |    5 ----
 drivers/media/video/bt8xx/bttv-driver.c            |   14 +++---------
 drivers/media/video/bt8xx/bttvp.h                  |    3 --
 drivers/media/video/bw-qcam.c                      |    3 +-
 drivers/media/video/c-qcam.c                       |    3 +-
 drivers/media/video/cpia2/cpia2.h                  |    5 ----
 drivers/media/video/cpia2/cpia2_v4l.c              |   12 +++-------
 drivers/media/video/cx18/cx18-driver.h             |    1 -
 drivers/media/video/cx18/cx18-ioctl.c              |    1 -
 drivers/media/video/cx18/cx18-version.h            |    8 +------
 drivers/media/video/cx231xx/cx231xx-video.c        |   14 +++---------
 drivers/media/video/cx231xx/cx231xx.h              |    1 -
 drivers/media/video/cx23885/altera-ci.c            |    1 -
 drivers/media/video/cx23885/cx23885-417.c          |    1 -
 drivers/media/video/cx23885/cx23885-core.c         |   13 ++---------
 drivers/media/video/cx23885/cx23885-video.c        |    1 -
 drivers/media/video/cx23885/cx23885.h              |    3 +-
 drivers/media/video/cx88/cx88-alsa.c               |   19 +++--------------
 drivers/media/video/cx88/cx88-blackbird.c          |   20 ++----------------
 drivers/media/video/cx88/cx88-dvb.c                |   18 ++--------------
 drivers/media/video/cx88/cx88-mpeg.c               |   11 ++-------
 drivers/media/video/cx88/cx88-video.c              |   21 ++-----------------
 drivers/media/video/cx88/cx88.h                    |    4 +-
 drivers/media/video/davinci/vpif_capture.c         |    9 ++-----
 drivers/media/video/davinci/vpif_capture.h         |    7 +-----
 drivers/media/video/davinci/vpif_display.c         |    9 ++-----
 drivers/media/video/davinci/vpif_display.h         |    8 +------
 drivers/media/video/em28xx/em28xx-video.c          |   14 ++++--------
 drivers/media/video/et61x251/et61x251.h            |    1 -
 drivers/media/video/et61x251/et61x251_core.c       |    6 ++--
 drivers/media/video/fsl-viu.c                      |   10 +-------
 drivers/media/video/gspca/gl860/gl860.h            |    1 -
 drivers/media/video/gspca/gspca.c                  |   12 +++-------
 drivers/media/video/hdpvr/hdpvr-core.c             |    1 +
 drivers/media/video/hdpvr/hdpvr-video.c            |    2 -
 drivers/media/video/hdpvr/hdpvr.h                  |    6 -----
 drivers/media/video/ivtv/ivtv-driver.h             |    1 -
 drivers/media/video/ivtv/ivtv-ioctl.c              |    1 -
 drivers/media/video/ivtv/ivtv-version.h            |    7 +-----
 drivers/media/video/m5mols/m5mols_capture.c        |    2 -
 drivers/media/video/m5mols/m5mols_core.c           |    1 -
 drivers/media/video/mem2mem_testdev.c              |    4 +--
 drivers/media/video/mx1_camera.c                   |    5 +--
 drivers/media/video/mx2_camera.c                   |    5 +--
 drivers/media/video/mx3_camera.c                   |    3 +-
 drivers/media/video/omap1_camera.c                 |    5 +--
 drivers/media/video/omap24xxcam.c                  |    5 +--
 drivers/media/video/omap3isp/isp.c                 |    1 +
 drivers/media/video/omap3isp/ispvideo.c            |    1 -
 drivers/media/video/omap3isp/ispvideo.h            |    3 +-
 drivers/media/video/pms.c                          |    4 +--
 drivers/media/video/pvrusb2/pvrusb2-main.c         |    1 +
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c         |    2 +-
 drivers/media/video/pwc/pwc-ioctl.h                |    1 -
 drivers/media/video/pwc/pwc-v4l.c                  |    1 -
 drivers/media/video/pwc/pwc.h                      |    7 +-----
 drivers/media/video/pxa_camera.c                   |    5 +--
 drivers/media/video/s2255drv.c                     |   15 +++----------
 drivers/media/video/s5p-fimc/fimc-capture.c        |    2 -
 drivers/media/video/s5p-fimc/fimc-core.c           |    3 +-
 drivers/media/video/saa7134/saa7134-core.c         |   12 +++-------
 drivers/media/video/saa7134/saa7134-empress.c      |    1 -
 drivers/media/video/saa7134/saa7134-video.c        |    2 -
 drivers/media/video/saa7134/saa7134.h              |    3 +-
 drivers/media/video/saa7164/saa7164.h              |    1 -
 drivers/media/video/sh_mobile_ceu_camera.c         |    3 +-
 drivers/media/video/sh_vou.c                       |    3 +-
 drivers/media/video/sn9c102/sn9c102.h              |    1 -
 drivers/media/video/sn9c102/sn9c102_core.c         |    6 ++--
 drivers/media/video/timblogiw.c                    |    1 -
 drivers/media/video/tlg2300/pd-common.h            |    1 -
 drivers/media/video/tlg2300/pd-main.c              |    1 +
 drivers/media/video/tlg2300/pd-radio.c             |    2 -
 drivers/media/video/usbvision/usbvision-video.c    |   12 +----------
 drivers/media/video/uvc/uvc_driver.c               |    3 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |    2 +-
 drivers/media/video/uvc/uvcvideo.h                 |    3 +-
 drivers/media/video/v4l2-ioctl.c                   |    2 +
 drivers/media/video/vino.c                         |    5 +---
 drivers/media/video/vivi.c                         |   14 +++---------
 drivers/media/video/w9966.c                        |    4 +--
 drivers/media/video/zoran/zoran.h                  |    4 ---
 drivers/media/video/zoran/zoran_card.c             |    7 ++++-
 drivers/media/video/zoran/zoran_driver.c           |    3 --
 drivers/media/video/zr364xx.c                      |    6 +---
 112 files changed, 169 insertions(+), 426 deletions(-)

