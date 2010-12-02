Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab0LBE1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 23:27:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756698Ab0LBE1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 23:27:20 -0500
Message-ID: <4CF72022.8080008@redhat.com>
Date: Thu, 02 Dec 2010 02:27:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 2.6.37-rc4] V4L/DVB changes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patch series basically removes one duplicated parameter from a function inside
V4L2 core API. Before this patch, both I2C driver name and module name were needed.
A previous patch series applied during the merge window replaced the module name by
NULL. Those two patches remove the obsoleted NULL parameter, to cleanup the API
call.

While it is a patch that touches several drivers, the change is trivial, and looks like:

        mxb->saa7111a = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-                   NULL, "saa7111", I2C_SAA7111A, NULL);
+                 "saa7111", I2C_SAA7111A, NULL);


So, please pull from:
	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

---

The following changes since commit e53beacd23d9cb47590da6a7a7f6d417b941a994:

  Linux 2.6.37-rc2 (2010-11-15 18:31:02 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Laurent Pinchart (2):
      [media] v4l: Remove hardcoded module names passed to v4l2_i2c_new_subdev* (2)
      [media] v4l: Remove module_name argument to the v4l2_i2c_new_subdev* functions

 drivers/media/radio/radio-si4713.c            |    2 +-
 drivers/media/video/au0828/au0828-cards.c     |    4 ++--
 drivers/media/video/bt8xx/bttv-cards.c        |   22 +++++++++++-----------
 drivers/media/video/cafe_ccic.c               |    3 +--
 drivers/media/video/cx18/cx18-i2c.c           |    8 ++++----
 drivers/media/video/cx231xx/cx231xx-cards.c   |    4 ++--
 drivers/media/video/cx23885/cx23885-cards.c   |    2 +-
 drivers/media/video/cx23885/cx23885-video.c   |    4 ++--
 drivers/media/video/cx88/cx88-cards.c         |    9 ++++-----
 drivers/media/video/cx88/cx88-video.c         |    7 +++----
 drivers/media/video/davinci/vpfe_capture.c    |    1 -
 drivers/media/video/davinci/vpif_capture.c    |    1 -
 drivers/media/video/davinci/vpif_display.c    |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c     |   18 +++++++++---------
 drivers/media/video/fsl-viu.c                 |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.c           |   22 +++++++++-------------
 drivers/media/video/mxb.c                     |   12 ++++++------
 drivers/media/video/pvrusb2/pvrusb2-hdw.c     |    6 ++----
 drivers/media/video/s5p-fimc/fimc-capture.c   |    2 +-
 drivers/media/video/saa7134/saa7134-cards.c   |    8 ++++----
 drivers/media/video/saa7134/saa7134-core.c    |    4 ++--
 drivers/media/video/sh_vou.c                  |    2 +-
 drivers/media/video/soc_camera.c              |    2 +-
 drivers/media/video/usbvision/usbvision-i2c.c |    6 +++---
 drivers/media/video/v4l2-common.c             |   15 +++++----------
 drivers/media/video/via-camera.c              |    2 +-
 drivers/media/video/vino.c                    |    4 ++--
 drivers/media/video/zoran/zoran_card.c        |    5 ++---
 drivers/staging/go7007/go7007-driver.c        |    2 +-
 drivers/staging/tm6000/tm6000-cards.c         |    4 ++--
 include/media/v4l2-common.h                   |   16 ++++++----------
 31 files changed, 90 insertions(+), 111 deletions(-)

