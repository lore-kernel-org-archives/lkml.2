Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1LLQr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 11:47:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab1LLQr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 11:47:57 -0500
Message-ID: <4EE63039.4040004@redhat.com>
Date: Mon, 12 Dec 2011 14:47:53 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.2-rc5] media fixes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For a couple fixes for media drivers.
The changes are:
	- ati_remote (new driver for 3.2): Fix the scancode tables;
	- af9015: fix some issues with firmware load;
	- au0828: (trivial) add device ID's for some devices;
	- omap3 and s5p: several small fixes;
	- Update MAINTAINERS entry to cover /drivers/staging/media and
	  media DocBook;
	- a few other small trivial fixes.

Thanks!
Mauro

-

The following changes since commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50:

   Linux 3.2-rc5 (2011-12-09 15:09:32 -0800)

are available in the git repository at:
   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

Anssi Hannula (1):
       [media] ati_remote: switch to single-byte scancodes

Antti Palosaari (3):
       [media] af9015: limit I2C access to keep FW happy
       [media] tda18218: fix 6 MHz default IF frequency
       [media] mxl5007t: fix reg read

Dan Carpenter (1):
       [media] V4L: mt9t112: use after free in mt9t112_probe()

Dmitry Artamonow (1):
       [media] omap3isp: fix compilation of ispvideo.c

Gary Thomas (1):
       [media] omap_vout: Fix compile error in 3.1

Guennadi Liakhovetski (2):
       [media] V4L: soc-camera: fix compiler warnings on 64-bit platforms
       [media] V4L: mt9m111: fix uninitialised mutex

Janusz Krzysztofik (1):
       [media] V4L: omap1_camera: fix missing <linux/module.h> include

Joe Perches (1):
       [media] [trivial] omap24xxcam-dma: Fix logical test

Marek Szyprowski (1):
       [media] media: video: s5p-tv: fix build break

Mauro Carvalho Chehab (1):
       MAINTAINERS: Update media entries

Michael Krufky (3):
       [media] au0828: add missing USB ID 2040:7260
       [media] au0828: add missing USB ID 2040:7213
       [media] au0828: add missing models 72101, 72201 & 72261 to the model matrix

Peter Korsgaard (1):
       [media] s5p_mfc_enc: fix s/H264/H263/ typo

Randy Dunlap (1):
       [media] media/staging: fix allyesconfig build error

Sylwester Nawrocki (10):
       [media] s5p-fimc: Fix wrong pointer dereference when unregistering sensors
       [media] s5p-fimc: Fix error in the capture subdev deinitialization
       [media] s5p-fimc: Fix initialization for proper system suspend support
       [media] s5p-fimc: Fix buffer dequeue order issue
       [media] s5p-fimc: Allow probe() to succeed with null platform data
       [media] s5p-fimc: Adjust pixel height alignments according to the IP revision
       [media] s5p-fimc: Fail driver probing when sensor configuration is wrong
       [media] s5p-fimc: Use correct fourcc for RGB565 colour format
       [media] m5mols: Fix set_fmt to return proper pixel format code
       [media] s5p-fimc: Fix camera input configuration in subdev operations

Thomas Jarosch (1):
       [media] m5mols: Fix logic in sanity check

Tomi Valkeinen (1):
       [media] omap_vout: fix crash if no driver for a display

  MAINTAINERS                                      |    2 +
  drivers/media/common/tuners/mxl5007t.c           |    3 +-
  drivers/media/common/tuners/tda18218.c           |    2 +-
  drivers/media/dvb/dvb-usb/af9015.c               |   97 ++++++++++++++++
  drivers/media/dvb/dvb-usb/af9015.h               |    7 +
  drivers/media/rc/ati_remote.c                    |  111 +++++++++----------
  drivers/media/rc/keymaps/rc-ati-x10.c            |   96 ++++++++--------
  drivers/media/rc/keymaps/rc-medion-x10.c         |  128 +++++++++++-----------
  drivers/media/rc/keymaps/rc-snapstream-firefly.c |  114 ++++++++++----------
  drivers/media/video/au0828/au0828-cards.c        |    7 +
  drivers/media/video/m5mols/m5mols.h              |    2 -
  drivers/media/video/m5mols/m5mols_core.c         |   22 ++--
  drivers/media/video/mt9m111.c                    |    1 +
  drivers/media/video/mt9t112.c                    |    4 +-
  drivers/media/video/omap/omap_vout.c             |    9 ++
  drivers/media/video/omap1_camera.c               |    1 +
  drivers/media/video/omap24xxcam-dma.c            |    2 +-
  drivers/media/video/omap3isp/ispvideo.c          |    1 +
  drivers/media/video/ov6650.c                     |    2 +-
  drivers/media/video/s5p-fimc/fimc-capture.c      |   14 ++-
  drivers/media/video/s5p-fimc/fimc-core.c         |   24 ++--
  drivers/media/video/s5p-fimc/fimc-core.h         |    2 +
  drivers/media/video/s5p-fimc/fimc-mdevice.c      |   43 +++++---
  drivers/media/video/s5p-fimc/fimc-reg.c          |   15 ++-
  drivers/media/video/s5p-mfc/s5p_mfc_enc.c        |    2 +-
  drivers/media/video/s5p-tv/mixer_video.c         |    1 +
  drivers/media/video/sh_mobile_ceu_camera.c       |   34 ++++--
  drivers/media/video/sh_mobile_csi2.c             |    4 +-
  drivers/media/video/soc_camera.c                 |    3 +-
  drivers/staging/media/as102/as102_drv.c          |    4 +-
  drivers/staging/media/as102/as102_drv.h          |    3 +-
  include/media/soc_camera.h                       |    7 +-
  32 files changed, 461 insertions(+), 306 deletions(-)

