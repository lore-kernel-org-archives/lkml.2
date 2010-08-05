Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887Ab0HEH34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:29:56 -0400
Received: from mail.perches.com ([173.55.12.10]:2267 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759736Ab0HEH3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:29:52 -0400
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] drivers/input: Use pr_<level> 
Date: Thu,  5 Aug 2010 00:29:41 -0700
Message-Id: <cover.1280992116.git.joe@perches.com>
X-Mailer: git-send-email 1.7.2.19.g9a302
In-Reply-To: <20100804043256.GB25256@core.coreip.homeip.net>
References: <20100804043256.GB25256@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove prefixes from printks and convert to pr_fmt/pr_<level>.

Always make output prefix match module name.
There are some existing uses that do not.  For instance:
spaceorb used "input: " once, probably a copy/paste error,
newtonkbd as well.  Synaptics used "serio: ", etc.

A few miscellaneous typos corrected.
Converted a few uses of usb macros err to pr_err.

Compiled x86 only, some files not compile tested

Joe Perches (9):
  drivers/input/gameport: Use pr_fmt and pr_<level>
  drivers/input/joystick: Use pr_fmt and pr_<level>
  drivers/input/keyboard: Use pr_fmt and pr_<level>
  drivers/input/misc: Use pr_fmt and pr_<level>
  drivers/input/mouse: Use pr_fmt and pr_<level>
  drivers/input/serio: Use pr_fmt and pr_<level>
  drivers/input/tablet: Use pr_fmt and pr_<level>
  drivers/input/touchscreen: Use pr_fmt and pr_<level>
  drivers/input: Use pr_fmt and pr_<level>

 drivers/input/apm-power.c                      |   14 ++---
 drivers/input/evbug.c                          |   18 ++++---
 drivers/input/evdev.c                          |   15 +++---
 drivers/input/ff-core.c                        |    6 +-
 drivers/input/ff-memless.c                     |    8 ++--
 drivers/input/gameport/emu10k1-gp.c            |    4 +-
 drivers/input/gameport/fm801-gp.c              |    8 ++-
 drivers/input/gameport/lightning.c             |    6 ++-
 drivers/input/gameport/ns558.c                 |    8 ++-
 drivers/input/input-polldev.c                  |    5 +-
 drivers/input/input.c                          |   22 ++++----
 drivers/input/joydev.c                         |    4 +-
 drivers/input/joystick/a3d.c                   |    9 ++-
 drivers/input/joystick/adi.c                   |   12 +++--
 drivers/input/joystick/amijoy.c                |    4 +-
 drivers/input/joystick/analog.c                |   15 +++--
 drivers/input/joystick/cobra.c                 |    7 ++-
 drivers/input/joystick/db9.c                   |   16 +++---
 drivers/input/joystick/gf2k.c                  |    7 ++-
 drivers/input/joystick/grip_mp.c               |   15 +++--
 drivers/input/joystick/guillemot.c             |   11 +++-
 drivers/input/joystick/iforce/iforce-packets.c |    8 ++-
 drivers/input/joystick/interact.c              |    7 ++-
 drivers/input/joystick/joydump.c               |   40 ++++++++-------
 drivers/input/joystick/sidewinder.c            |   58 ++++++++++++----------
 drivers/input/joystick/spaceball.c             |    6 ++-
 drivers/input/joystick/spaceorb.c              |   15 ++++--
 drivers/input/joystick/turbografx.c            |   16 +++---
 drivers/input/joystick/walkera0701.c           |    6 ++-
 drivers/input/joystick/xpad.c                  |    4 +-
 drivers/input/keyboard/amikbd.c                |   42 +++++++++++-----
 drivers/input/keyboard/atakbd.c                |    4 +-
 drivers/input/keyboard/hil_kbd.c               |   21 +++-----
 drivers/input/keyboard/hilkbd.c                |   26 +++++-----
 drivers/input/keyboard/jornada680_kbd.c        |    5 +-
 drivers/input/keyboard/jornada720_kbd.c        |   10 ++--
 drivers/input/keyboard/lkkbd.c                 |   54 ++++++++++----------
 drivers/input/keyboard/locomokbd.c             |    6 ++-
 drivers/input/keyboard/newtonkbd.c             |    4 +-
 drivers/input/keyboard/omap-keypad.c           |   25 +++++-----
 drivers/input/keyboard/sunkbd.c                |    9 ++--
 drivers/input/keyboard/xtkbd.c                 |    7 ++-
 drivers/input/misc/ati_remote.c                |   22 +++++----
 drivers/input/misc/ati_remote2.c               |    6 ++-
 drivers/input/misc/cm109.c                     |   23 +++-----
 drivers/input/misc/hp_sdc_rtc.c                |   10 ++--
 drivers/input/misc/m68kspkr.c                  |    4 +-
 drivers/input/misc/powermate.c                 |   19 ++++---
 drivers/input/misc/uinput.c                    |   25 +++++----
 drivers/input/misc/winbond-cir.c               |    6 ++-
 drivers/input/misc/wistron_btns.c              |   29 ++++++-----
 drivers/input/misc/yealink.c                   |    5 +-
 drivers/input/mouse/alps.c                     |   12 +++--
 drivers/input/mouse/appletouch.c               |   64 +++++++++++------------
 drivers/input/mouse/bcm5974.c                  |   48 +++++++++---------
 drivers/input/mouse/elantech.c                 |    4 +-
 drivers/input/mouse/inport.c                   |    8 ++-
 drivers/input/mouse/lifebook.c                 |    5 +-
 drivers/input/mouse/logibm.c                   |   10 ++--
 drivers/input/mouse/logips2pp.c                |   13 +++--
 drivers/input/mouse/pc110pad.c                 |   10 ++--
 drivers/input/mouse/psmouse-base.c             |   52 ++++++++++---------
 drivers/input/mouse/rpcmouse.c                 |    4 +-
 drivers/input/mouse/sentelic.c                 |   13 +++--
 drivers/input/mouse/sermouse.c                 |    6 ++-
 drivers/input/mouse/synaptics.c                |   30 ++++++-----
 drivers/input/mouse/trackpoint.c               |   10 ++--
 drivers/input/mouse/vsxxxaa.c                  |   44 ++++++++---------
 drivers/input/mousedev.c                       |   10 ++--
 drivers/input/serio/ambakmi.c                  |    5 ++-
 drivers/input/serio/ct82c710.c                 |   10 ++--
 drivers/input/serio/gscps2.c                   |   15 +++---
 drivers/input/serio/hil_mlc.c                  |   17 +++---
 drivers/input/serio/hp_sdc.c                   |   53 ++++++++++----------
 drivers/input/serio/hp_sdc_mlc.c               |   45 +++++++++--------
 drivers/input/serio/i8042-x86ia64io.h          |   43 +++++++---------
 drivers/input/serio/i8042.c                    |   62 ++++++++++-------------
 drivers/input/serio/i8042.h                    |   21 +++++---
 drivers/input/serio/maceps2.c                  |    5 ++-
 drivers/input/serio/parkbd.c                   |    8 ++-
 drivers/input/serio/q40kbd.c                   |    6 ++-
 drivers/input/serio/rpckbd.c                   |    6 ++-
 drivers/input/serio/sa1111ps2.c                |   17 ++++---
 drivers/input/serio/serio_raw.c                |   10 ++--
 drivers/input/serio/serport.c                  |    6 ++-
 drivers/input/tablet/acecad.c                  |    5 +-
 drivers/input/tablet/aiptek.c                  |    7 ++-
 drivers/input/tablet/gtco.c                    |    2 +-
 drivers/input/tablet/kbtab.c                   |    5 +-
 drivers/input/tablet/wacom_sys.c               |    7 ++-
 drivers/input/tablet/wacom_wac.c               |    8 ++-
 drivers/input/touchscreen/gunze.c              |    5 ++-
 drivers/input/touchscreen/h3600_ts_input.c     |    8 ++-
 drivers/input/touchscreen/hp680_ts_input.c     |    3 +-
 drivers/input/touchscreen/htcpen.c             |   15 +++---
 drivers/input/touchscreen/inexio.c             |    5 ++-
 drivers/input/touchscreen/jornada720_ts.c      |    4 +-
 drivers/input/touchscreen/mk712.c              |   10 ++--
 drivers/input/touchscreen/mtouch.c             |    7 ++-
 drivers/input/touchscreen/ucb1400_ts.c         |   12 +++--
 drivers/input/touchscreen/usbtouchscreen.c     |    6 ++-
 drivers/input/xen-kbdfront.c                   |   10 ++--
 102 files changed, 848 insertions(+), 679 deletions(-)

-- 
1.7.2.19.g9a302

