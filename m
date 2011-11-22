Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab1KVJC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:02:56 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:44290 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1KVJCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:02:53 -0500
From: JJ Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        JJ Ding <jj_ding@emc.com.tw>
Subject: [PATCH TRIVIAL 0/5] Input: use new macro module_platform_driver to save some boilerplate code
Date: Tue, 22 Nov 2011 17:00:41 +0800
Message-Id: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.8-rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List,

With commit 940ab88962bc1aff3273a8356d64577a6e386736 Grant Likely added a new
macro module_platform_driver to save some boilerplate code for platform_driver.
This patchset converts these platform_driver's in input subsystem to use it.

I am not quite sure if it's worth it to convert all these drivers, but I did it
anyway, because:
 - by converting we encourage new code to use it.
 - as a kernel newbie I take it as exercises.

Patches are against Linus' latest tree, I split the whole converting into 5
patches for easier reviewing. Please take a look, thank you very much.

-jj

JJ Ding (5):
  Input: keyboard: use macro module_platform_driver()
  Input: misc: use macro module_platform_driver()
  Input: mouse: use macro module_platform_driver()
  Input: serio: use macro module_platform_driver()
  Input: touchscreen: use macro module_platform_driver()

 drivers/input/keyboard/adp5520-keys.c        |   13 +------------
 drivers/input/keyboard/amikbd.c              |   15 +--------------
 drivers/input/keyboard/bf54x-keys.c          |   14 +-------------
 drivers/input/keyboard/davinci_keyscan.c     |   13 +------------
 drivers/input/keyboard/ep93xx_keypad.c       |   14 +-------------
 drivers/input/keyboard/gpio_keys_polled.c    |   14 +-------------
 drivers/input/keyboard/imx_keypad.c          |   14 +-------------
 drivers/input/keyboard/jornada680_kbd.c      |   14 +-------------
 drivers/input/keyboard/jornada720_kbd.c      |   14 +-------------
 drivers/input/keyboard/matrix_keypad.c       |   14 +-------------
 drivers/input/keyboard/nomadik-ske-keypad.c  |   13 +------------
 drivers/input/keyboard/omap-keypad.c         |   15 +--------------
 drivers/input/keyboard/omap4-keypad.c        |   13 +------------
 drivers/input/keyboard/opencores-kbd.c       |   13 +------------
 drivers/input/keyboard/pmic8xxx-keypad.c     |   13 +------------
 drivers/input/keyboard/pxa27x_keypad.c       |   14 +-------------
 drivers/input/keyboard/pxa930_rotary.c       |   13 +------------
 drivers/input/keyboard/samsung-keypad.c      |   13 +------------
 drivers/input/keyboard/sh_keysc.c            |   14 +-------------
 drivers/input/keyboard/spear-keyboard.c      |   13 +------------
 drivers/input/keyboard/stmpe-keypad.c        |   13 +------------
 drivers/input/keyboard/tc3589x-keypad.c      |   13 +------------
 drivers/input/keyboard/tegra-kbc.c           |   13 +------------
 drivers/input/keyboard/tnetv107x-keypad.c    |   14 +-------------
 drivers/input/keyboard/twl4030_keypad.c      |   13 +------------
 drivers/input/keyboard/w90p910_keypad.c      |   14 +-------------
 drivers/input/misc/88pm860x_onkey.c          |   13 +------------
 drivers/input/misc/ab8500-ponkey.c           |   13 +------------
 drivers/input/misc/bfin_rotary.c             |   13 +------------
 drivers/input/misc/cobalt_btns.c             |   14 +-------------
 drivers/input/misc/dm355evm_keys.c           |   13 +------------
 drivers/input/misc/ixp4xx-beeper.c           |   13 +------------
 drivers/input/misc/max8925_onkey.c           |   13 +------------
 drivers/input/misc/pcap_keys.c               |   14 +-------------
 drivers/input/misc/pcf50633-input.c          |   13 +------------
 drivers/input/misc/pcspkr.c                  |   14 +-------------
 drivers/input/misc/pm8xxx-vibrator.c         |   13 +------------
 drivers/input/misc/pmic8xxx-pwrkey.c         |   13 +------------
 drivers/input/misc/pwm-beeper.c              |   13 +------------
 drivers/input/misc/rb532_button.c            |   14 +-------------
 drivers/input/misc/rotary_encoder.c          |   14 +-------------
 drivers/input/misc/sgi_btns.c                |   13 +------------
 drivers/input/misc/twl4030-pwrbutton.c       |   15 ++-------------
 drivers/input/misc/twl4030-vibra.c           |   14 +-------------
 drivers/input/misc/twl6040-vibra.c           |   13 +------------
 drivers/input/misc/wm831x-on.c               |   13 +------------
 drivers/input/mouse/amimouse.c               |   16 ++--------------
 drivers/input/mouse/gpio_mouse.c             |   13 +------------
 drivers/input/mouse/pxa930_trkball.c         |   14 +-------------
 drivers/input/serio/altera_ps2.c             |   13 +------------
 drivers/input/serio/at32psif.c               |   14 +-------------
 drivers/input/serio/rpckbd.c                 |   14 +-------------
 drivers/input/serio/xilinx_ps2.c             |   14 +-------------
 drivers/input/touchscreen/88pm860x-ts.c      |   13 +------------
 drivers/input/touchscreen/atmel-wm97xx.c     |   13 +------------
 drivers/input/touchscreen/atmel_tsadcc.c     |   15 +--------------
 drivers/input/touchscreen/da9034-ts.c        |   13 +------------
 drivers/input/touchscreen/intel-mid-touch.c  |   13 +------------
 drivers/input/touchscreen/jornada720_ts.c    |   14 +-------------
 drivers/input/touchscreen/lpc32xx_ts.c       |   13 +------------
 drivers/input/touchscreen/mainstone-wm97xx.c |   14 +-------------
 drivers/input/touchscreen/mc13783_ts.c       |   13 +------------
 drivers/input/touchscreen/pcap_ts.c          |   14 +-------------
 drivers/input/touchscreen/s3c2410_ts.c       |   14 +-------------
 drivers/input/touchscreen/stmpe-ts.c         |   15 +--------------
 drivers/input/touchscreen/tnetv107x-ts.c     |   14 +-------------
 drivers/input/touchscreen/tps6507x-ts.c      |   13 +------------
 drivers/input/touchscreen/ucb1400_ts.c       |   14 +-------------
 drivers/input/touchscreen/w90p910_ts.c       |   14 +-------------
 drivers/input/touchscreen/wm831x-ts.c        |   13 +------------
 drivers/input/touchscreen/zylonite-wm97xx.c  |   14 +-------------
 71 files changed, 73 insertions(+), 892 deletions(-)

-- 
1.7.8-rc2

