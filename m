Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0LQQu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 11:50:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab0LQQuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 11:50:55 -0500
Date: Fri, 17 Dec 2010 14:50:03 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v2.6.37-rc6] V4L/DVB BKL fixes
Message-ID: <20101217145003.75852ba3@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git bkl_removal

For a series of BKL removal fixes that are needed in order to allow making V4L core
non-dependent of CONFIG_BKL. Several patches on this series are trivial.

There's still one bug left with bttv driver. I have a patch for it already. I'll be
adding it at -next and let it cook there for a couple days before sending you a pull
request.

Cheers,
Mauro.

---


The following changes since commit e53beacd23d9cb47590da6a7a7f6d417b941a994:

  Linux 2.6.37-rc2 (2010-11-15 18:31:02 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git bkl_removal

Hans Verkuil (15):
      [media] BKL: trivial BKL removal from V4L2 radio drivers
      [media] cadet: use unlocked_ioctl
      [media] tea5764: convert to unlocked_ioctl
      [media] si4713: convert to unlocked_ioctl
      [media] typhoon: convert to unlocked_ioctl
      [media] BKL: trivial ioctl -> unlocked_ioctl video driver conversions
      [media] sn9c102: convert to unlocked_ioctl
      [media] et61x251_core: trivial conversion to unlocked_ioctl
      [media] cafe_ccic: replace ioctl by unlocked_ioctl
      [media] sh_vou: convert to unlocked_ioctl
      [media] radio-timb: convert to unlocked_ioctl
      [media] cx18: convert to unlocked_ioctl
      [media] v4l2-dev: use mutex_lock_interruptible instead of plain mutex_lock
      [media] V4L: improve the BKL replacement heuristic
      [media] v4l2-dev: fix race condition

Laurent Pinchart (5):
      [media] uvcvideo: Lock controls mutex when querying menus
      [media] uvcvideo: Move mutex lock/unlock inside uvc_free_buffers
      [media] uvcvideo: Move mmap() handler to uvc_queue.c
      [media] uvcvideo: Lock stream mutex when accessing format-related information
      [media] uvcvideo: Convert to unlocked_ioctl

 drivers/media/radio/radio-aimslab.c          |   16 +-
 drivers/media/radio/radio-aztech.c           |    6 +-
 drivers/media/radio/radio-cadet.c            |   12 ++-
 drivers/media/radio/radio-gemtek-pci.c       |    6 +-
 drivers/media/radio/radio-gemtek.c           |   14 +-
 drivers/media/radio/radio-maestro.c          |   14 +-
 drivers/media/radio/radio-maxiradio.c        |    2 +-
 drivers/media/radio/radio-miropcm20.c        |    6 +-
 drivers/media/radio/radio-rtrack2.c          |   10 +-
 drivers/media/radio/radio-sf16fmi.c          |    7 +-
 drivers/media/radio/radio-sf16fmr2.c         |   11 +-
 drivers/media/radio/radio-si4713.c           |    3 +-
 drivers/media/radio/radio-tea5764.c          |   49 ++------
 drivers/media/radio/radio-terratec.c         |    8 +-
 drivers/media/radio/radio-timb.c             |    5 +-
 drivers/media/radio/radio-trust.c            |   18 ++--
 drivers/media/radio/radio-typhoon.c          |   16 +-
 drivers/media/radio/radio-zoltrix.c          |   30 ++--
 drivers/media/video/arv.c                    |    2 +-
 drivers/media/video/bw-qcam.c                |    2 +-
 drivers/media/video/c-qcam.c                 |    2 +-
 drivers/media/video/cafe_ccic.c              |    2 +-
 drivers/media/video/cx18/cx18-alsa-pcm.c     |    8 +-
 drivers/media/video/cx18/cx18-streams.c      |    2 +-
 drivers/media/video/et61x251/et61x251_core.c |    2 +-
 drivers/media/video/meye.c                   |   14 +-
 drivers/media/video/pms.c                    |    2 +-
 drivers/media/video/sh_vou.c                 |   13 +-
 drivers/media/video/sn9c102/sn9c102_core.c   |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c           |   48 +++++++-
 drivers/media/video/uvc/uvc_queue.c          |  133 +++++++++++++++---
 drivers/media/video/uvc/uvc_v4l2.c           |  185 ++++++++------------------
 drivers/media/video/uvc/uvc_video.c          |    3 -
 drivers/media/video/uvc/uvcvideo.h           |   10 +-
 drivers/media/video/v4l2-dev.c               |   69 +++++++---
 drivers/media/video/v4l2-device.c            |    1 +
 drivers/media/video/w9966.c                  |    2 +-
 include/media/v4l2-device.h                  |    2 +
 38 files changed, 413 insertions(+), 324 deletions(-)

