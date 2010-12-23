Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab0LWOnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 09:43:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab0LWOnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 09:43:07 -0500
Message-ID: <4D135FF3.1090903@redhat.com>
Date: Thu, 23 Dec 2010 12:42:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.37-rc8] V4L/RC fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For a series of fixes for V4L and RC. Most of the patches are due to a bug 
at the mceusb parser that weren't working with some MCE Remote Controller variants.
There are also some regressions and bugs at s5p-fimc driver and a few other
bugs at soc_camera/mx2_camera, nuvoton, lirc and streamzap drivers. 

Thanks!
Mauro

-

The following changes since commit 90a8a73c06cc32b609a880d48449d7083327e11a:

  Linux 2.6.37-rc7 (2010-12-21 11:26:40 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Baruch Siach (1):
      [media] mx2_camera: fix pixel clock polarity configuration

Dan Carpenter (2):
      [media] lirc_dev: stray unlock in lirc_dev_fop_poll()
      [media] lirc_dev: fixes in lirc_dev_fop_read()

Guennadi Liakhovetski (1):
      [media] soc-camera: fix static build of the sh_mobile_csi2.c driver

Jarod Wilson (10):
      [media] mceusb: add support for Conexant Hybrid TV RDU253S
      [media] nuvoton-cir: improve buffer parsing responsiveness
      [media] mceusb: fix up reporting of trailing space
      [media] mceusb: buffer parsing fixups for 1st-gen device
      [media] IR: add tv power scancode to rc6 mce keymap
      [media] mceusb: fix keybouce issue after parser simplification
      [media] streamzap: merge timeout space with trailing space
      [media] mceusb: add another Fintek device ID
      [media] mceusb: fix inverted mask inversion logic
      [media] mceusb: set a default rx timeout

Paul Bender (1):
      [media] rc: fix sysfs entry for mceusb and streamzap

Sylwester Nawrocki (6):
      [media] s5p-fimc: BKL lock removal - compilation fix
      [media] s5p-fimc: Fix vidioc_g_crop/cropcap on camera sensor
      [media] s5p-fimc: Explicitly add required header file
      [media] s5p-fimc: Convert m2m driver to unlocked_ioctl
      [media] s5p-fimc: Use correct fourcc code for 32-bit RGB format
      [media] s5p-fimc: Fix output DMA handling in S5PV310 IP revisions

 drivers/media/IR/keymaps/rc-rc6-mce.c       |   21 ++--
 drivers/media/IR/lirc_dev.c                 |   29 +++--
 drivers/media/IR/mceusb.c                   |  174 +++++++++++++++++----------
 drivers/media/IR/nuvoton-cir.c              |   10 ++-
 drivers/media/IR/streamzap.c                |   21 ++--
 drivers/media/video/mx2_camera.c            |    2 -
 drivers/media/video/s5p-fimc/fimc-capture.c |   51 ++++++++-
 drivers/media/video/s5p-fimc/fimc-core.c    |   54 +++++----
 drivers/media/video/s5p-fimc/fimc-core.h    |   24 +++--
 drivers/media/video/s5p-fimc/regs-fimc.h    |    3 +
 drivers/media/video/sh_mobile_ceu_camera.c  |    2 +-
 11 files changed, 257 insertions(+), 134 deletions(-)

