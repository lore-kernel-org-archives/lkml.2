Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162615Ab2GMGBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 02:01:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030201Ab2GMGBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 02:01:46 -0400
Message-ID: <4FFFB9C5.5050602@redhat.com>
Date: Fri, 13 Jul 2012 03:01:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.5-rc7] media fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Plese pull from:
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for the fixes for the media subsystem, including:
	- Some regression fixes at the audio part for devices with cx23885/cx25840;
	- A DMA corruption fix at cx231xx;
	- two fixes at the winbond IR driver;
	- Several fixes for the EXYNOS media driver (s5p);
	- two fixes at the OMAP3 preview driver;
	- one fix at the dvb core failure path;
	- an include missing (slab.h) at smiapp-core causing compilation breakage;
	- em28xx was not loading the IR driver driver anymore.

PS.: I'll be out next week due to holidays.

Thanks!
Mauro

Latest commit at the branch: 
ec3ed85f926f4e900bc48cec6e72abbe6475321f [media] Revert "[media] V4L: JPEG class documentation corrections"
The following changes since commit 099987f0aaf28771261b91a41240b9228f2e32b2:

  [media] smia: Fix compile failures (2012-06-18 19:52:05 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to ec3ed85f926f4e900bc48cec6e72abbe6475321f:

  [media] Revert "[media] V4L: JPEG class documentation corrections" (2012-07-07 00:12:50 -0300)

----------------------------------------------------------------
Anton Blanchard (3):
      [media] cx23885: Silence unknown command warnings
      [media] winbond-cir: Fix txandrx module info
      [media] winbond-cir: Initialise timeout, driver_type and allowed_protos

David Dillow (1):
      [media] cx231xx: don't DMA to random addresses

Devin Heitmueller (6):
      [media] cx25840: fix regression in HVR-1800 analog support
      [media] cx25840: fix regression in analog support hue/saturation controls
      [media] cx25840: fix regression in HVR-1800 analog audio
      [media] cx25840: fix vsrc/hsrc usage on cx23888 designs
      [media] cx23885: make analog support work for HVR_1250 (cx23885 variant)
      [media] cx23885: add support for HVR-1255 analog (cx23888 variant)

Fengguang Wu (1):
      [media] pms: fix build error in pms_probe()

Kamil Debski (1):
      [media] s5p-mfc: Fixed setup of custom controls in decoder and encoder

Laurent Pinchart (2):
      [media] omap3isp: preview: Fix output size computation depending on input format
      [media] omap3isp: preview: Fix contrast and brightness handling

Mauro Carvalho Chehab (2):
      [media] smiapp-core: fix compilation build error
      [media] em28xx: fix em28xx-rc load

Randy Dunlap (1):
      [media] media: pms.c needs linux/slab.h

Sachin Kamat (2):
      [media] s5p-fimc: Fix compiler warning in fimc-lite.c
      [media] s5p-fimc: Stop media entity pipeline if fimc_pipeline_validate fails

Sakari Ailus (1):
      [media] s5p-fimc: media_entity_pipeline_start() may fail

Santosh Nayak (1):
      [media] dvb-core: Release semaphore on error path dvb_register_device()

Sylwester Nawrocki (10):
      [media] s5p-fimc: Fix bug in capture node open()
      [media] s5p-fimc: Don't create multiple active links to same sink entity
      [media] s5p-fimc: Honour sizeimage in VIDIOC_S_FMT
      [media] s5p-fimc: Remove superfluous checks for buffer type
      [media] s5p-fimc: Prevent lock-up in multiple sensor systems
      [media] s5p-fimc: Fix fimc-lite system wide suspend procedure
      [media] s5p-fimc: Shorten pixel formats description
      [media] s5p-fimc: Update to the control handler lock changes
      [media] s5p-fimc: Add missing FIMC-LITE file operations locking
      [media] Revert "[media] V4L: JPEG class documentation corrections"

 Documentation/DocBook/media/v4l/controls.xml       |    2 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    7 --
 drivers/media/dvb/dvb-core/dvbdev.c                |    1 +
 drivers/media/rc/winbond-cir.c                     |    4 +-
 drivers/media/video/cx231xx/cx231xx-audio.c        |    4 +-
 drivers/media/video/cx231xx/cx231xx-vbi.c          |    2 +-
 drivers/media/video/cx23885/cx23885-cards.c        |   89 +++++++++++++++++---
 drivers/media/video/cx23885/cx23885-dvb.c          |    6 ++
 drivers/media/video/cx23885/cx23885-video.c        |    9 +-
 drivers/media/video/cx23885/cx23885.h              |    1 +
 drivers/media/video/cx25840/cx25840-core.c         |   76 ++++++++++++-----
 drivers/media/video/em28xx/em28xx-cards.c          |    2 +-
 drivers/media/video/omap3isp/isppreview.c          |    6 +-
 drivers/media/video/pms.c                          |    2 +
 drivers/media/video/s5p-fimc/fimc-capture.c        |   69 ++++++++-------
 drivers/media/video/s5p-fimc/fimc-core.c           |   19 +++--
 drivers/media/video/s5p-fimc/fimc-lite.c           |   73 +++++++++++-----
 drivers/media/video/s5p-fimc/fimc-mdevice.c        |   48 +++++------
 drivers/media/video/s5p-fimc/fimc-mdevice.h        |    2 -
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c          |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c          |    1 +
 drivers/media/video/smiapp/smiapp-core.c           |    1 +
 22 files changed, 287 insertions(+), 138 deletions(-)

