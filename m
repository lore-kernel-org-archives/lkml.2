Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab0ETQwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:52:50 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:65229 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab0ETQws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:52:48 -0400
X-Greylist: delayed 35028 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 May 2010 12:52:48 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=e0nW7/9lbeSD+xb1aJtuE4pnKcTMmKVsy9Ku6RclLRhR/bgo+EWyoWsj7svx0gjHEn
         LCJymJrbWNvEp3fXWIGe443YVqANjfdBgydgq8fr63vuZDTVOm7gNHsByNe5fbpRCE5Q
         SSAoHYjpknccmkYYNO5kfCjoTuuDbRGLNYBDc=
Date: Thu, 20 May 2010 09:52:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.35-rc0
Message-ID: <20100520165243.GA20861@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Adam Bennett (1):
      Input: add driver for hampshire serial touchscreens

Axel Lin (2):
      Input: acecad - fix incorrect size parameter in usb_buffer_free
      Input: kbtab - fix incorrect size parameter in usb_buffer_free

Barry Song (1):
      Input: ad714x - add support for the AD7143/8/7A parts

Bryan Wu (2):
      Input: add PCF8574 I2C keypad input device driver
      Input: add Analog Devices AD714x captouch input driver

Dmitry Torokhov (17):
      Input: wacom - do not allocate wacom_wac separately
      Input: wacom - fix some formatting issues
      Input: wacom - get rid of input event wrappers
      Input: wacom - get rid of wacom_combo structure
      Input: wacom - use get_unaligned to access unaligned data
      Input: implement SysRq as a separate input handler
      Input: keyboard - switch to using pr_err() and friends
      Input: keyboard - fix formatting issues
      Input: acecad - simplify usb_acecad_disconnect()
      Input: acecad - fix some formatting issues
      Input: acecad - don't advertise mouse events
      Input: kbtab - simplify kbtab_disconnect()
      Input: kbtab - do not advertise unsupported events
      Input: elantech - enforce common prefix on messages
      Input: elantech - relax signature checks
      Input: synaptics - set dimensions as reported by firmware
      Input: psmouse - small formatting changes to better follow coding style

Eric Miao (2):
      Input: remove now deprecated corgi_ts.c touchscreen driver
      Input: remove obsolete {corgi,spitz,tosa}kbd.c

Haojian Zhuang (1):
      Input: 88pm860x_onkey - remove invalid irq number assignment

Jacob Pan (1):
      Input: do not force selecting i8042 on Moorestown

Julia Lawall (2):
      Input: usbtouchscreen - switch to using kmemdup()
      Input: wistron_btns - switch to using kmemdup()

Manuel Lauss (1):
      Input: wm9712 - fix wm97xx_set_gpio() logic

Matthew Garrett (2):
      Input: i8042 - add some extra PNP keyboard types
      Input: i8042 - add a PNP entry to the aux device list

Paul Fox (1):
      Input: Documentation/sysrq.txt - update KEY_SYSRQ info

Ping Cheng (4):
      Input: wacom - switch mode upon system resume
      Input: wacom - merge out and in prox events
      Input: wacom - share pen info with touch of the same ID
      Input: wacom - streamline 2-finger touch support

Sriramakrishnan Govindarajan (1):
      Input: add keypad driver for keys interfaced to TCA6416

Wolfram Sang (2):
      Input: tsc2007 - do not leave dangling clientdata pointer
      Input: lm8323 - do not leave dangling client data pointer


Diffstat:
--------

 Documentation/sysrq.txt                    |   14 +-
 drivers/char/keyboard.c                    |  325 ++++----
 drivers/char/sysrq.c                       |  243 +++++-
 drivers/input/keyboard/Kconfig             |   18 +-
 drivers/input/keyboard/Makefile            |    1 +
 drivers/input/keyboard/lm8323.c            |    6 +-
 drivers/input/keyboard/tca6416-keypad.c    |  349 +++++++
 drivers/input/misc/88pm860x_onkey.c        |    1 -
 drivers/input/misc/Kconfig                 |   40 +
 drivers/input/misc/Makefile                |    4 +
 drivers/input/misc/ad714x-i2c.c            |  140 +++
 drivers/input/misc/ad714x-spi.c            |  103 +++
 drivers/input/misc/ad714x.c                | 1347 ++++++++++++++++++++++++++++
 drivers/input/misc/ad714x.h                |   26 +
 drivers/input/misc/pcf8574_keypad.c        |  227 +++++
 drivers/input/misc/wistron_btns.c          |    4 +-
 drivers/input/mouse/Kconfig                |    2 +-
 drivers/input/mouse/elantech.c             |   87 ++-
 drivers/input/mouse/hgpk.c                 |    4 +-
 drivers/input/mouse/logips2pp.c            |   98 ++-
 drivers/input/mouse/psmouse-base.c         |   72 +-
 drivers/input/mouse/synaptics.c            |   53 +-
 drivers/input/mouse/synaptics.h            |    6 +-
 drivers/input/serio/i8042-x86ia64io.h      |   14 +
 drivers/input/tablet/acecad.c              |   86 +-
 drivers/input/tablet/kbtab.c               |   53 +-
 drivers/input/tablet/wacom.h               |   36 +-
 drivers/input/tablet/wacom_sys.c           |  316 +++-----
 drivers/input/tablet/wacom_wac.c           | 1168 +++++++++++++-----------
 drivers/input/tablet/wacom_wac.h           |   13 +-
 drivers/input/touchscreen/Kconfig          |   12 +
 drivers/input/touchscreen/Makefile         |    1 +
 drivers/input/touchscreen/hampshire.c      |  205 +++++
 drivers/input/touchscreen/tsc2007.c        |    2 +
 drivers/input/touchscreen/usbtouchscreen.c |    5 +-
 drivers/input/touchscreen/wm97xx-core.c    |    2 +-
 include/linux/input.h                      |    1 +
 include/linux/input/ad714x.h               |   63 ++
 include/linux/serio.h                      |    1 +
 include/linux/sysrq.h                      |   23 +-
 include/linux/tca6416_keypad.h             |   34 +
 kernel/sysctl.c                            |   23 +-
 42 files changed, 3995 insertions(+), 1233 deletions(-)
 create mode 100644 drivers/input/keyboard/tca6416-keypad.c
 create mode 100644 drivers/input/misc/ad714x-i2c.c
 create mode 100644 drivers/input/misc/ad714x-spi.c
 create mode 100644 drivers/input/misc/ad714x.c
 create mode 100644 drivers/input/misc/ad714x.h
 create mode 100644 drivers/input/misc/pcf8574_keypad.c
 create mode 100644 drivers/input/touchscreen/hampshire.c
 create mode 100644 include/linux/input/ad714x.h
 create mode 100644 include/linux/tca6416_keypad.h

-- 
Dmitry

