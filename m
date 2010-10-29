Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782Ab0J2Ts2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:48:28 -0400
Received: from kroah.org ([198.145.64.141]:34309 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761722Ab0J2Ts0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:48:26 -0400
Date: Fri, 29 Oct 2010 12:48:22 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] one more STAGING merge for .37-rc
Message-ID: <20101029194822.GA26371@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a single followup patch for the .37 tree for staging stuff.  It
removes the dream driver and arch-specific files that were in the subdir
to let the stuff build.  The code is now going through the proper merge
channels to get the arch code and driver into the tree, and this version
is no longer supported and probably doesn't even build anymore.

It's been acked by Qualcomm and the original driver submitter.

The diffstat is also quite nice:
 93 files changed, 0 insertions(+), 39835 deletions(-)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

thanks,

greg k-h

--------------

 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/dream/Kconfig                      |   13 -
 drivers/staging/dream/Makefile                     |    5 -
 drivers/staging/dream/TODO                         |   13 -
 drivers/staging/dream/camera/Kconfig               |   46 -
 drivers/staging/dream/camera/Makefile              |    8 -
 drivers/staging/dream/camera/msm_camera.c          | 2181 -----------
 drivers/staging/dream/camera/msm_io7x.c            |  291 --
 drivers/staging/dream/camera/msm_io8x.c            |  320 --
 drivers/staging/dream/camera/msm_v4l2.c            |  798 ----
 drivers/staging/dream/camera/msm_vfe7x.c           |  702 ----
 drivers/staging/dream/camera/msm_vfe7x.h           |  255 --
 drivers/staging/dream/camera/msm_vfe8x.c           |  736 ----
 drivers/staging/dream/camera/msm_vfe8x.h           |  895 -----
 drivers/staging/dream/camera/msm_vfe8x_proc.c      | 4003 --------------------
 drivers/staging/dream/camera/msm_vfe8x_proc.h      | 1549 --------
 drivers/staging/dream/camera/mt9d112.c             |  762 ----
 drivers/staging/dream/camera/mt9d112.h             |   36 -
 drivers/staging/dream/camera/mt9d112_reg.c         |  307 --
 drivers/staging/dream/camera/mt9p012.h             |   51 -
 drivers/staging/dream/camera/mt9p012_fox.c         | 1306 -------
 drivers/staging/dream/camera/mt9p012_reg.c         |  573 ---
 drivers/staging/dream/camera/mt9t013.c             | 1497 --------
 drivers/staging/dream/camera/mt9t013.h             |   48 -
 drivers/staging/dream/camera/mt9t013_reg.c         |  266 --
 drivers/staging/dream/camera/s5k3e2fx.c            | 1307 -------
 drivers/staging/dream/camera/s5k3e2fx.h            |    9 -
 drivers/staging/dream/generic_gpio.c               |  274 --
 drivers/staging/dream/gpio_axis.c                  |  181 -
 drivers/staging/dream/gpio_event.c                 |  224 --
 drivers/staging/dream/gpio_input.c                 |  337 --
 drivers/staging/dream/gpio_matrix.c                |  399 --
 drivers/staging/dream/gpio_output.c                |   84 -
 drivers/staging/dream/include/linux/android_pmem.h |   80 -
 drivers/staging/dream/include/linux/gpio_event.h   |  154 -
 drivers/staging/dream/include/linux/msm_adsp.h     |   84 -
 drivers/staging/dream/include/linux/msm_audio.h    |  115 -
 .../staging/dream/include/linux/msm_rpcrouter.h    |   47 -
 drivers/staging/dream/include/linux/wakelock.h     |   91 -
 drivers/staging/dream/include/mach/camera.h        |  279 --
 drivers/staging/dream/include/mach/msm_adsp.h      |  112 -
 drivers/staging/dream/include/mach/msm_rpcrouter.h |  179 -
 drivers/staging/dream/include/mach/msm_smd.h       |  107 -
 .../dream/include/mach/qdsp5/qdsp5audplaycmdi.h    |   94 -
 .../dream/include/mach/qdsp5/qdsp5audplaymsg.h     |   70 -
 .../dream/include/mach/qdsp5/qdsp5audppcmdi.h      |  914 -----
 .../dream/include/mach/qdsp5/qdsp5audppmsg.h       |  318 --
 .../dream/include/mach/qdsp5/qdsp5audpreproccmdi.h |  256 --
 .../dream/include/mach/qdsp5/qdsp5audpreprocmsg.h  |   85 -
 .../dream/include/mach/qdsp5/qdsp5audreccmdi.h     |  176 -
 .../dream/include/mach/qdsp5/qdsp5audrecmsg.h      |  127 -
 .../dream/include/mach/qdsp5/qdsp5jpegcmdi.h       |  376 --
 .../dream/include/mach/qdsp5/qdsp5jpegmsg.h        |  177 -
 .../dream/include/mach/qdsp5/qdsp5lpmcmdi.h        |   82 -
 .../staging/dream/include/mach/qdsp5/qdsp5lpmmsg.h |   80 -
 .../dream/include/mach/qdsp5/qdsp5vdeccmdi.h       |  235 --
 .../dream/include/mach/qdsp5/qdsp5vdecmsg.h        |  107 -
 .../dream/include/mach/qdsp5/qdsp5venccmdi.h       |  212 --
 .../dream/include/mach/qdsp5/qdsp5vfecmdi.h        |  910 -----
 .../staging/dream/include/mach/qdsp5/qdsp5vfemsg.h |  290 --
 drivers/staging/dream/include/media/msm_camera.h   |  388 --
 drivers/staging/dream/pmem.c                       | 1333 -------
 drivers/staging/dream/qdsp5/Makefile               |   18 -
 drivers/staging/dream/qdsp5/adsp.c                 | 1159 ------
 drivers/staging/dream/qdsp5/adsp.h                 |  369 --
 drivers/staging/dream/qdsp5/adsp_6210.c            |  283 --
 drivers/staging/dream/qdsp5/adsp_6220.c            |  284 --
 drivers/staging/dream/qdsp5/adsp_6225.c            |  328 --
 drivers/staging/dream/qdsp5/adsp_driver.c          |  643 ----
 drivers/staging/dream/qdsp5/adsp_info.c            |  121 -
 .../staging/dream/qdsp5/adsp_jpeg_patch_event.c    |   31 -
 drivers/staging/dream/qdsp5/adsp_jpeg_verify_cmd.c |  182 -
 drivers/staging/dream/qdsp5/adsp_lpm_verify_cmd.c  |   65 -
 drivers/staging/dream/qdsp5/adsp_vfe_patch_event.c |   54 -
 drivers/staging/dream/qdsp5/adsp_vfe_verify_cmd.c  |  239 --
 .../staging/dream/qdsp5/adsp_video_verify_cmd.c    |  163 -
 .../staging/dream/qdsp5/adsp_videoenc_verify_cmd.c |  235 --
 drivers/staging/dream/qdsp5/audio_aac.c            | 1054 -----
 drivers/staging/dream/qdsp5/audio_amrnb.c          |  875 -----
 drivers/staging/dream/qdsp5/audio_evrc.c           |  847 -----
 drivers/staging/dream/qdsp5/audio_in.c             |  970 -----
 drivers/staging/dream/qdsp5/audio_mp3.c            |  972 -----
 drivers/staging/dream/qdsp5/audio_out.c            |  841 ----
 drivers/staging/dream/qdsp5/audio_qcelp.c          |  858 -----
 drivers/staging/dream/qdsp5/audmgr.c               |  314 --
 drivers/staging/dream/qdsp5/audmgr.h               |  215 --
 drivers/staging/dream/qdsp5/audmgr_new.h           |  213 --
 drivers/staging/dream/qdsp5/audpp.c                |  429 ---
 drivers/staging/dream/qdsp5/evlog.h                |  134 -
 drivers/staging/dream/qdsp5/snd.c                  |  280 --
 drivers/staging/dream/synaptics_i2c_rmi.c          |  649 ----
 drivers/staging/dream/synaptics_i2c_rmi.h          |   53 -
 93 files changed, 0 insertions(+), 39835 deletions(-)
 delete mode 100644 drivers/staging/dream/Kconfig
 delete mode 100644 drivers/staging/dream/Makefile
 delete mode 100644 drivers/staging/dream/TODO
 delete mode 100644 drivers/staging/dream/camera/Kconfig
 delete mode 100644 drivers/staging/dream/camera/Makefile
 delete mode 100644 drivers/staging/dream/camera/msm_camera.c
 delete mode 100644 drivers/staging/dream/camera/msm_io7x.c
 delete mode 100644 drivers/staging/dream/camera/msm_io8x.c
 delete mode 100644 drivers/staging/dream/camera/msm_v4l2.c
 delete mode 100644 drivers/staging/dream/camera/msm_vfe7x.c
 delete mode 100644 drivers/staging/dream/camera/msm_vfe7x.h
 delete mode 100644 drivers/staging/dream/camera/msm_vfe8x.c
 delete mode 100644 drivers/staging/dream/camera/msm_vfe8x.h
 delete mode 100644 drivers/staging/dream/camera/msm_vfe8x_proc.c
 delete mode 100644 drivers/staging/dream/camera/msm_vfe8x_proc.h
 delete mode 100644 drivers/staging/dream/camera/mt9d112.c
 delete mode 100644 drivers/staging/dream/camera/mt9d112.h
 delete mode 100644 drivers/staging/dream/camera/mt9d112_reg.c
 delete mode 100644 drivers/staging/dream/camera/mt9p012.h
 delete mode 100644 drivers/staging/dream/camera/mt9p012_fox.c
 delete mode 100644 drivers/staging/dream/camera/mt9p012_reg.c
 delete mode 100644 drivers/staging/dream/camera/mt9t013.c
 delete mode 100644 drivers/staging/dream/camera/mt9t013.h
 delete mode 100644 drivers/staging/dream/camera/mt9t013_reg.c
 delete mode 100644 drivers/staging/dream/camera/s5k3e2fx.c
 delete mode 100644 drivers/staging/dream/camera/s5k3e2fx.h
 delete mode 100644 drivers/staging/dream/generic_gpio.c
 delete mode 100644 drivers/staging/dream/gpio_axis.c
 delete mode 100644 drivers/staging/dream/gpio_event.c
 delete mode 100644 drivers/staging/dream/gpio_input.c
 delete mode 100644 drivers/staging/dream/gpio_matrix.c
 delete mode 100644 drivers/staging/dream/gpio_output.c
 delete mode 100644 drivers/staging/dream/include/linux/android_pmem.h
 delete mode 100644 drivers/staging/dream/include/linux/gpio_event.h
 delete mode 100644 drivers/staging/dream/include/linux/msm_adsp.h
 delete mode 100644 drivers/staging/dream/include/linux/msm_audio.h
 delete mode 100644 drivers/staging/dream/include/linux/msm_rpcrouter.h
 delete mode 100644 drivers/staging/dream/include/linux/wakelock.h
 delete mode 100644 drivers/staging/dream/include/mach/camera.h
 delete mode 100644 drivers/staging/dream/include/mach/msm_adsp.h
 delete mode 100644 drivers/staging/dream/include/mach/msm_rpcrouter.h
 delete mode 100644 drivers/staging/dream/include/mach/msm_smd.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5audplaycmdi.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5audplaymsg.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5audppcmdi.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5audppmsg.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5audpreproccmdi.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5audpreprocmsg.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5audreccmdi.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5audrecmsg.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5jpegcmdi.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5jpegmsg.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5lpmcmdi.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5lpmmsg.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5vdeccmdi.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5vdecmsg.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5venccmdi.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5vfecmdi.h
 delete mode 100644 drivers/staging/dream/include/mach/qdsp5/qdsp5vfemsg.h
 delete mode 100644 drivers/staging/dream/include/media/msm_camera.h
 delete mode 100644 drivers/staging/dream/pmem.c
 delete mode 100644 drivers/staging/dream/qdsp5/Makefile
 delete mode 100644 drivers/staging/dream/qdsp5/adsp.c
 delete mode 100644 drivers/staging/dream/qdsp5/adsp.h
 delete mode 100644 drivers/staging/dream/qdsp5/adsp_6210.c
 delete mode 100644 drivers/staging/dream/qdsp5/adsp_6220.c
 delete mode 100644 drivers/staging/dream/qdsp5/adsp_6225.c
 delete mode 100644 drivers/staging/dream/qdsp5/adsp_driver.c
 delete mode 100644 drivers/staging/dream/qdsp5/adsp_info.c
 delete mode 100644 drivers/staging/dream/qdsp5/adsp_jpeg_patch_event.c
 delete mode 100644 drivers/staging/dream/qdsp5/adsp_jpeg_verify_cmd.c
 delete mode 100644 drivers/staging/dream/qdsp5/adsp_lpm_verify_cmd.c
 delete mode 100644 drivers/staging/dream/qdsp5/adsp_vfe_patch_event.c
 delete mode 100644 drivers/staging/dream/qdsp5/adsp_vfe_verify_cmd.c
 delete mode 100644 drivers/staging/dream/qdsp5/adsp_video_verify_cmd.c
 delete mode 100644 drivers/staging/dream/qdsp5/adsp_videoenc_verify_cmd.c
 delete mode 100644 drivers/staging/dream/qdsp5/audio_aac.c
 delete mode 100644 drivers/staging/dream/qdsp5/audio_amrnb.c
 delete mode 100644 drivers/staging/dream/qdsp5/audio_evrc.c
 delete mode 100644 drivers/staging/dream/qdsp5/audio_in.c
 delete mode 100644 drivers/staging/dream/qdsp5/audio_mp3.c
 delete mode 100644 drivers/staging/dream/qdsp5/audio_out.c
 delete mode 100644 drivers/staging/dream/qdsp5/audio_qcelp.c
 delete mode 100644 drivers/staging/dream/qdsp5/audmgr.c
 delete mode 100644 drivers/staging/dream/qdsp5/audmgr.h
 delete mode 100644 drivers/staging/dream/qdsp5/audmgr_new.h
 delete mode 100644 drivers/staging/dream/qdsp5/audpp.c
 delete mode 100644 drivers/staging/dream/qdsp5/evlog.h
 delete mode 100644 drivers/staging/dream/qdsp5/snd.c
 delete mode 100644 drivers/staging/dream/synaptics_i2c_rmi.c
 delete mode 100644 drivers/staging/dream/synaptics_i2c_rmi.h


Greg Kroah-Hartman (1):
      Staging: dream: remove dream driver and arch from tree

