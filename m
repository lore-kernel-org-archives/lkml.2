Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab0CQAX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 20:23:58 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:59763 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab0CQAXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 20:23:40 -0400
Subject: [GIT PULL] backlight updates for 2.6.34-rc2
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 20:37:52 +0000
Message-ID: <1268771872.1625.204.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-backlight for-linus

for various backlight updates suitable for 2.6.34-rc2. The patches are
mostly bugfixes that have been testing in -mm/linux-next for a while but
there is one new driver included which is unlikely to be harmful to
anyone. I'd prefer to have submitted the tree earlier but there is a
function calling arguments change in the series (addressing a real world
bug) and I wanted to be sure caught all the users as there were some
backlight patches coming through the MFD tree.

Thanks, Richard

 drivers/acpi/video.c                            |    9 
 drivers/gpu/drm/nouveau/nouveau_backlight.c     |   12 -
 drivers/macintosh/via-pmu-backlight.c           |    7 
 drivers/platform/x86/acer-wmi.c                 |    7 
 drivers/platform/x86/asus-laptop.c              |    7 
 drivers/platform/x86/asus_acpi.c                |    7 
 drivers/platform/x86/classmate-laptop.c         |   12 -
 drivers/platform/x86/compal-laptop.c            |   11 -
 drivers/platform/x86/dell-laptop.c              |   13 -
 drivers/platform/x86/eeepc-laptop.c             |    8 
 drivers/platform/x86/fujitsu-laptop.c           |   14 -
 drivers/platform/x86/msi-laptop.c               |    7 
 drivers/platform/x86/msi-wmi.c                  |   15 -
 drivers/platform/x86/panasonic-laptop.c         |   28 +-
 drivers/platform/x86/sony-laptop.c              |    8 
 drivers/platform/x86/thinkpad_acpi.c            |   12 -
 drivers/platform/x86/toshiba_acpi.c             |   10 
 drivers/staging/samsung-laptop/samsung-laptop.c |    7 
 drivers/usb/misc/appledisplay.c                 |    7 
 drivers/video/atmel_lcdfb.c                     |    8 
 drivers/video/aty/aty128fb.c                    |    7 
 drivers/video/aty/atyfb_base.c                  |    7 
 drivers/video/aty/radeon_backlight.c            |    7 
 drivers/video/backlight/88pm860x_bl.c           |    6 
 drivers/video/backlight/Kconfig                 |    7 
 drivers/video/backlight/Makefile                |    1 
 drivers/video/backlight/adp5520_bl.c            |   11 -
 drivers/video/backlight/adx_bl.c                |   10 
 drivers/video/backlight/atmel-pwm-bl.c          |    8 
 drivers/video/backlight/backlight.c             |   10 
 drivers/video/backlight/corgi_lcd.c             |    8 
 drivers/video/backlight/cr_bllcd.c              |    8 
 drivers/video/backlight/da903x_bl.c             |    7 
 drivers/video/backlight/generic_bl.c            |    8 
 drivers/video/backlight/hp680_bl.c              |    8 
 drivers/video/backlight/jornada720_bl.c         |    7 
 drivers/video/backlight/kb3886_bl.c             |    8 
 drivers/video/backlight/l4f00242t03.c           |  257 ++++++++++++++++++++++++
 drivers/video/backlight/locomolcd.c             |    8 
 drivers/video/backlight/max8925_bl.c            |    6 
 drivers/video/backlight/mbp_nvidia_bl.c         |   55 ++++-
 drivers/video/backlight/omap1_bl.c              |    7 
 drivers/video/backlight/progear_bl.c            |   23 +-
 drivers/video/backlight/pwm_bl.c                |    8 
 drivers/video/backlight/tosa_bl.c               |    8 
 drivers/video/backlight/wm831x_bl.c             |    7 
 drivers/video/bf54x-lq043fb.c                   |   19 +
 drivers/video/bfin-t350mcqb-fb.c                |   19 +
 drivers/video/nvidia/nv_backlight.c             |    7 
 drivers/video/omap2/displays/panel-taal.c       |   15 -
 drivers/video/riva/fbdev.c                      |    7 
 include/linux/backlight.h                       |   11 -
 include/linux/spi/l4f00242t03.h                 |   31 ++
 53 files changed, 658 insertions(+), 167 deletions(-)

Alberto Panizzo (2):
      backlight: Add Epson L4F00242T03 LCD driver
      backlight: l4f00242t03: Fix module licence absence.

Bruno Prémont (5):
      backlight: Add backlight_device parameter to check_fb
      backlight: classmate-laptop - Fix missing registration failure handling
      backlight: blackfin - Fix missing registration failure handling
      backlight: msi-laptop, msi-wmi: fix incomplete registration failure handling
      backlight: panasonic-laptop - Fix incomplete registration failure handling

Evan McClain (1):
      backlight: mbp_nvidia_bl - add five more MacBook variants

Jiri Slaby (1):
      video: backlight/progear, fix pci device refcounting

Matthew Garrett (1):
      backlight: Allow properties to be passed at registration

Richard Purdie (1):
      backlight: Revert some const qualifiers


