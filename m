Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab1GKXPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 19:15:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758486Ab1GKXPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 19:15:21 -0400
Message-ID: <4E1B83E5.2030602@redhat.com>
Date: Mon, 11 Jul 2011 20:14:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.0] media fixes
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For some regression fixes at the analog-TV tuner code.

The following changes since commit 98c32bcded0e249fd48726930ae9f393e0e318b4:

  [media] rc: call input_sync after scancode reports (2011-07-01 16:34:45 -0300)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Hans Verkuil (14):
      [media] tuner-core: fix s_std and s_tuner
      [media] tuner-core: fix tuner_resume: use t->mode instead of t->type
      [media] v4l2-ioctl.c: prefill tuner type for g_frequency and g/s_tuner
      [media] pvrusb2: fix g/s_tuner support
      [media] bttv: fix s_tuner for radio
      [media] feature-removal-schedule: change in how radio device nodes are handled
      [media] v4l2-subdev.h: remove unused s_mode tuner op
      [media] tuner-core/v4l2-subdev: document that the type field has to be filled in
      [media] tuner-core: simplify the standard fixup
      [media] v4l2-ioctl.c: check for valid tuner type in S_HW_FREQ_SEEK
      [media] tuner-core: power up tuner when called with s_power(1)
      [media] cx18/ivtv: fix g_tuner support
      [media] tuner-core.c: don't change type field in g_tuner or g_frequency
      [media] msp3400: fill in v4l2_tuner based on vt->type field

 Documentation/feature-removal-schedule.txt |   22 +++
 drivers/media/video/bt8xx/bttv-driver.c    |    2 +-
 drivers/media/video/cx18/cx18-ioctl.c      |    8 +-
 drivers/media/video/ivtv/ivtv-ioctl.c      |    8 +-
 drivers/media/video/msp3400-driver.c       |   12 +-
 drivers/media/video/pvrusb2/pvrusb2-hdw.c  |    4 +
 drivers/media/video/tuner-core.c           |  229 ++++++++++++++--------------
 drivers/media/video/v4l2-ioctl.c           |   18 ++-
 include/media/v4l2-subdev.h                |   10 +-
 9 files changed, 174 insertions(+), 139 deletions(-)

