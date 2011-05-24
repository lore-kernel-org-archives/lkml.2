Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1EXHQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:16:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46414 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab1EXHQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:16:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=EBYOBx4WNiRsE5EdQUHXrDgacdD5kuXtv0rF43KnJYDVxDFthyVd1tkW4HFi2gPAsK
         9mQjUDcOx/mf9mdoW8H5yTpFixzF1lfbSKFfx0CsP7thoqgc7YsBP/AbPcnorH+TdL2i
         vJaXILYQZhwnHPSKR2XkitGVx5os+4E1+NbW4=
Date: Tue, 24 May 2011 00:16:50 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.40-rc0
Message-ID: <20110524071650.GB20870@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. Drivers, drivers, drivers...
The only noteworthy change is that we won't wake up userspace evdev
readers until we accumulate full packet (i.e. get EV_SYN marker) to
limit bouncing between kernel and userspace.

Changelog:
---------

Alexander Stein (3):
      Input: gpio_keys - add support for EV_ABS
      Input: gpio-keys - add support for setting device name
      Input: ads7846 - add possibility to use external vref on ads7846

Axel Lin (4):
      Input: qt1070 - add MODULE_DEVICE_TABLE
      Input: omap-keypad - fix a wrong free_irq() parameter
      Input: twl4030-pwrbutton - fix a leak of the IRQ during init failure
      Input: h3600_ts_input - fix a leak of the IRQ during init failure

Dmitry Torokhov (3):
      Input: input-polldev - use system-wide freezable workqueue
      Input: sh_keysc - make sh_keysc_device_driver static
      Input: sh_keysc - only compile PM code if PM is enabled

Eric Dumazet (1):
      Input: remove useless synchronize_rcu() calls

Igor Grinberg (1):
      Input: ads7846 - fix gpio_pendown configuration

Iiro Valkonen (1):
      Input: atmel_mxt_ts - make CHG line high after enabling interrupts

Jeff Brown (1):
      Input: evdev - only signal polls on full packets

Johan Hovold (2):
      Input: rotary-encoder - refactor and clean up
      Input: rotary-encoder - add support for half-period encoders

Joonyoung Shim (2):
      Input: atmel_mxt_ts - support 12bit resolution
      Input: atmel_mxt_ts - convert to MT protocol B

Julia Lawall (1):
      Input: atmel_tsadcc - correct call to input_free_device

Magnus Damm (2):
      Input: sh_keysc - implement runtime PM support
      Input: sh_keysc - switch to threaded IRQ handler

Michael Hennerich (5):
      Input: ad714x - fix up input configuration
      Input: ad714x - fix threshold and completion interrupt masks
      Input: ad714x - allow platform code to specify irqflags
      Input: ad714x - fix captouch wheel option algorithm
      Input: ADP5589 - new driver for I2C Keypad Decoder and I/O Expander

Rakesh Iyer (2):
      Input: tegra-kbc - add ghost key filter
      Input: tegra-kbc - change wakeup logic to be all or nothing

Thierry Reding (5):
      Input: tsc2007 - debounce pressure measurement
      Input: tsc2007 - add max_rt parameter to platform data
      Input: tsc2007 - add poll_delay parameter to platform data
      Input: tsc2007 - add poll_period parameter to platform data
      Input: tsc2007 - add X, Y and Z fuzz factors to platform data

Ville Syrjala (1):
      Input: ati_remote2 - return the error code from sysfs channel_mask store

Zhang Jiejing (2):
      Input: add driver for Maxim max11801 touchscreen controller
      Input: add driver FSL MPR121 capacitive touch sensor

Éric Piel (4):
      Input: elantech - describe further the protocol
      Input: elantech - export pressure and width when supported
      Input: elantech - report multitouch with proper ABS_MT messages
      Input: elantech - remove support for proprietary X driver


Diffstat:
--------

 Documentation/input/elantech.txt           |  123 ++++-
 Documentation/input/rotary-encoder.txt     |   13 +
 arch/arm/mach-tegra/include/mach/kbc.h     |    4 +-
 drivers/input/evdev.c                      |   19 +-
 drivers/input/input-polldev.c              |   56 +--
 drivers/input/input.c                      |    1 -
 drivers/input/joydev.c                     |    1 -
 drivers/input/keyboard/Kconfig             |   22 +
 drivers/input/keyboard/Makefile            |    2 +
 drivers/input/keyboard/adp5589-keys.c      |  771 ++++++++++++++++++++++++++++
 drivers/input/keyboard/gpio_keys.c         |   11 +-
 drivers/input/keyboard/mpr121_touchkey.c   |  339 ++++++++++++
 drivers/input/keyboard/omap-keypad.c       |    6 +-
 drivers/input/keyboard/qt1070.c            |    1 +
 drivers/input/keyboard/sh_keysc.c          |   53 +--
 drivers/input/keyboard/tegra-kbc.c         |   60 ++-
 drivers/input/misc/ad714x.c                |  129 ++----
 drivers/input/misc/ati_remote2.c           |    9 +-
 drivers/input/misc/rotary_encoder.c        |  119 +++--
 drivers/input/misc/twl4030-pwrbutton.c     |    2 +-
 drivers/input/mouse/elantech.c             |   72 ++-
 drivers/input/mouse/elantech.h             |    6 +
 drivers/input/mousedev.c                   |    1 -
 drivers/input/touchscreen/Kconfig          |   12 +
 drivers/input/touchscreen/Makefile         |    1 +
 drivers/input/touchscreen/ads7846.c        |   26 +-
 drivers/input/touchscreen/atmel_mxt_ts.c   |   92 +++--
 drivers/input/touchscreen/atmel_tsadcc.c   |    2 +-
 drivers/input/touchscreen/h3600_ts_input.c |    8 +-
 drivers/input/touchscreen/max11801_ts.c    |  272 ++++++++++
 drivers/input/touchscreen/tsc2007.c        |   26 +-
 include/linux/gpio_keys.h                  |    8 +-
 include/linux/i2c/mpr121_touchkey.h        |   20 +
 include/linux/i2c/tsc2007.h                |    7 +
 include/linux/input/ad714x.h               |    3 +-
 include/linux/input/adp5589.h              |  213 ++++++++
 include/linux/rotary_encoder.h             |    1 +
 include/linux/spi/ads7846.h                |    3 +-
 38 files changed, 2155 insertions(+), 359 deletions(-)
 create mode 100644 drivers/input/keyboard/adp5589-keys.c
 create mode 100644 drivers/input/keyboard/mpr121_touchkey.c
 create mode 100644 drivers/input/touchscreen/max11801_ts.c
 create mode 100644 include/linux/i2c/mpr121_touchkey.h
 create mode 100644 include/linux/input/adp5589.h

-- 
Dmitry

