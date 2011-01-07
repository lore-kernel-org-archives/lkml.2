Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1AGG41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 01:56:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40264 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab1AGG4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 01:56:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Ey+4OLFGkc0/wqBTxgKOnV6ci5sVtpAwE/D9UiN2E750baK9XsPYuSBRtLXJFNnz4d
         hV5Nts66ugWa1Y4QJusNC1wv91JbtShsF8vtyji7XymRcBXZfEUzY23HT7+ppMUxrcSB
         5yGJ5TvGDHPF7YlUZQ/x6sT7BlCvX311x6lvY=
Date: Thu, 6 Jan 2011 22:56:19 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.38-rc0
Message-ID: <20110107065619.GD29038@core.coreip.homeip.net>
References: <20110107065448.GC29038@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110107065448.GC29038@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Fixed subject, should read 2.6.38-rc0. I should stop reusing old
 messages for pull requests...]

On Thu, Jan 06, 2011 at 10:54:48PM -0800, Dmitry Torokhov wrote:
> Hi Linus,
> 
> Please pull from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> or
> 	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
> 
> to receive first round of updates for the input subsystem.
> 
> As an exception, a few HID drivers are coming through my tree instead of
> Jiri's in this merge window, because they depend on MT protocol changes.
> 
> There will be a conflict in drivers/input/keyboard/Kconfig due to
> tc3589x keypad driver coming from ux500 tree and clashing with SPEAR
> keypad driver. If you could resolve by having SPEAR entry first and
> tc3589x next to it that would be great, otherwise I can pull your tree
> and resolve conflict myself.
> 
> Thanks!
> 
> Changelog:
> ---------
> 
> Ajay Ramaswamy (1):
>       Input: wacom - add support for digitizer in Lenovo W700
> 
> Andres Salomon (2):
>       Input: psmouse - fix up Synaptics comment
>       Input: psmouse - disable the synaptics extension on OLPC machines
> 
> Andy Ross (1):
>       hid: egalax: Add support for Wetab (726b)
> 
> Axel Lin (7):
>       Input: xpad - return proper error in error path
>       Input: xpad - fix a memory leak
>       Input: xpad - fix resource reclaim in xpad_probe error path
>       Input: xpad - ensure xpad->bulk_out is initialized before submitting urb
>       Input: ps2mult - fix wrong kfree in ps2mult_connect error path
>       Input: ams_delta_serio - fix wrong kfree in ams_delta_serio_exit
>       Input: ct82c710 - remove a redundant serio_register_port()
> 
> Chris Leech (1):
>       Input: qt602240_ts - fix wrong sizeof in object table allocation
> 
> Daniel Drake (5):
>       Input: hgpk - support GlideSensor and PenTablet modes
>       Input: hgpk - rework spew detection
>       Input: hgpk - extend jumpiness detection
>       Input: hgpk - detect simple mode overflows
>       Input: hgpk - recalibration tweaks
> 
> David Sterba (1):
>       Input: bu21013_ts - fix misuse of logical operation in place of bitop
> 
> Dmitry Torokhov (10):
>       Input: xpad - remove useless check in xpad_remove
>       Input: pcf_keypad - convert to dev_op_ops
>       Input: mac mouse emulation - add locking
>       Input: qt602240_ts - convert to using dev_pm_ops
>       Input: serio - convert to common workqueue instead of a thread
>       Input: gameport - convert to use common workqueue instead of a thread
>       Input: clean up Makefile (use input-core-y)
>       Input: iforce - clean up Makefile
>       Input: cma3000_d0x_i2c - add MODULE_DEVICE_TABLE
>       Input: include MT library as source for kerneldoc
> 
> Hemanth V (1):
>       Input: add CMA3000 accelerometer driver
> 
> Henrik Rydberg (18):
>       input: mt: Break out slots handling
>       input: mt: Collect slots initialization code
>       input: mt: Move tracking and pointer emulation to input-mt
>       input: mt: Add hovering distance axis
>       hid: egalax: Setup input device manually
>       hid: egalax: Correct for device resolution report error
>       hid: egalax: Report zero as minimum pressure
>       hid: egalax: Add event filtering
>       hid: egalax: Convert to MT slots
>       hid: egalax: Add support for Wetab
>       hid: egalax: Document the new devices in Kconfig
>       MAINTAINERS: Update input-mt entry
>       Input: introduce device properties
>       Input: fix double equality sign in uevent
>       input: mt: Document interface updates
>       Input: synaptics - report clickpad property
>       Input: synaptics - add multi-finger and semi-mt support
>       Input: synaptics - ignore bogus mt packet
> 
> Jesper Juhl (1):
>       Input: serio HIL MLC - don't deref null, don't leak and return proper error
> 
> Joe Perches (2):
>       Input: i8042 - use pr_<level>, pr_fmt, fix dbg and __FILE__ use
>       Input: use pr_fmt and pr_<level>
> 
> Pali Rohár (1):
>       Input: i8042 - add Acer Aspire 5100 to the Dritek list
> 
> Paul Fox (1):
>       Input: hgpk - fix powersave mode
> 
> Ping Cheng (2):
>       Input: wacom_w8001 - use __set_bit to set keybits
>       Input: wacom_w8001 - support pen or touch only devices
> 
> Rajeev Kumar (1):
>       Input: add support for keyboards on ST SPEAr platform
> 
> Richard Nauber (1):
>       hid: egalax: Add support for Samsung NB30 netbook
> 
> Tony SIM (2):
>       Input: tca6416-keypad - add support for tca6408a
>       Input: add ST1232 touchscreen controller driver
> 
> 
> Diffstat:
> --------
> 
>  Documentation/DocBook/device-drivers.tmpl    |    4 +
>  Documentation/input/cma3000_d0x.txt          |  115 +++++
>  Documentation/input/multi-touch-protocol.txt |   53 ++-
>  MAINTAINERS                                  |    2 +
>  arch/arm/plat-spear/include/plat/keyboard.h  |  141 ++++++
>  drivers/hid/Kconfig                          |    3 +-
>  drivers/hid/hid-3m-pct.c                     |   36 +--
>  drivers/hid/hid-core.c                       |    3 +
>  drivers/hid/hid-egalax.c                     |  131 +++---
>  drivers/hid/hid-ids.h                        |    3 +
>  drivers/input/Makefile                       |    2 +-
>  drivers/input/apm-power.c                    |   14 +-
>  drivers/input/evbug.c                        |   18 +-
>  drivers/input/evdev.c                        |   19 +-
>  drivers/input/ff-core.c                      |   11 +-
>  drivers/input/ff-memless.c                   |   31 +-
>  drivers/input/gameport/gameport.c            |  152 +++---
>  drivers/input/input-mt.c                     |  170 +++++++
>  drivers/input/input-polldev.c                |    5 +-
>  drivers/input/input.c                        |   91 ++---
>  drivers/input/joydev.c                       |    4 +-
>  drivers/input/joystick/iforce/Makefile       |   15 +-
>  drivers/input/joystick/xpad.c                |  123 +++--
>  drivers/input/keyboard/Kconfig               |   19 +-
>  drivers/input/keyboard/Makefile              |    1 +
>  drivers/input/keyboard/spear-keyboard.c      |  344 +++++++++++++
>  drivers/input/keyboard/tca6416-keypad.c      |   13 +-
>  drivers/input/misc/Kconfig                   |   24 +
>  drivers/input/misc/Makefile                  |    2 +
>  drivers/input/misc/cma3000_d0x.c             |  398 +++++++++++++++
>  drivers/input/misc/cma3000_d0x.h             |   42 ++
>  drivers/input/misc/cma3000_d0x_i2c.c         |  143 ++++++
>  drivers/input/misc/pcf8574_keypad.c          |   19 +-
>  drivers/input/misc/uinput.c                  |    8 +-
>  drivers/input/mouse/hgpk.c                   |  695 +++++++++++++++++++++++---
>  drivers/input/mouse/hgpk.h                   |   31 ++-
>  drivers/input/mouse/psmouse-base.c           |    1 +
>  drivers/input/mouse/synaptics.c              |  129 +++++-
>  drivers/input/mouse/synaptics.h              |    3 +
>  drivers/input/mousedev.c                     |   10 +-
>  drivers/input/serio/ams_delta_serio.c        |    1 -
>  drivers/input/serio/ct82c710.c               |    8 +-
>  drivers/input/serio/hil_mlc.c                |    5 +
>  drivers/input/serio/hp_sdc_mlc.c             |   18 +-
>  drivers/input/serio/i8042-x86ia64io.h        |   37 +-
>  drivers/input/serio/i8042.c                  |   92 ++--
>  drivers/input/serio/i8042.h                  |   14 +-
>  drivers/input/serio/ps2mult.c                |    2 +-
>  drivers/input/serio/serio.c                  |  155 +++----
>  drivers/input/tablet/wacom.h                 |    1 +
>  drivers/input/tablet/wacom_wac.c             |   33 +-
>  drivers/input/tablet/wacom_wac.h             |    4 -
>  drivers/input/touchscreen/Kconfig            |   22 +-
>  drivers/input/touchscreen/Makefile           |    1 +
>  drivers/input/touchscreen/bu21013_ts.c       |    2 +-
>  drivers/input/touchscreen/qt602240_ts.c      |   21 +-
>  drivers/input/touchscreen/st1232.c           |  274 ++++++++++
>  drivers/input/touchscreen/wacom_w8001.c      |   71 ++--
>  drivers/input/xen-kbdfront.c                 |   10 +-
>  drivers/macintosh/mac_hid.c                  |    8 +
>  include/linux/input.h                        |   38 +-
>  include/linux/input/cma3000.h                |   59 +++
>  include/linux/input/mt.h                     |   57 +++
>  include/linux/uinput.h                       |    1 +
>  64 files changed, 3209 insertions(+), 753 deletions(-)
>  create mode 100644 Documentation/input/cma3000_d0x.txt
>  create mode 100644 arch/arm/plat-spear/include/plat/keyboard.h
>  create mode 100644 drivers/input/input-mt.c
>  create mode 100644 drivers/input/keyboard/spear-keyboard.c
>  create mode 100644 drivers/input/misc/cma3000_d0x.c
>  create mode 100644 drivers/input/misc/cma3000_d0x.h
>  create mode 100644 drivers/input/misc/cma3000_d0x_i2c.c
>  create mode 100644 drivers/input/touchscreen/st1232.c
>  create mode 100644 include/linux/input/cma3000.h
>  create mode 100644 include/linux/input/mt.h
> 
> -- 
> Dmitry
> 

-- 
Dmitry
