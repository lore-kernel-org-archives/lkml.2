Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab0HJPuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:50:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64229 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab0HJPup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=XJa3yc3prSKC9qsHTMTwvh984TGa/Xx/uaMoDlmcK2e/NEOgjIbt7QZCXnZMw6DDkV
         Qyjl7sDq9f8aKzcQbiXH+hPHudpXPokWdskuNdcomeyjzXLZQyVudbpON6WZM418dH9o
         KnBlxQSTKcsxMilHxth9JAFV97A7abKun5hGM=
Date: Tue, 10 Aug 2010 08:50:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.36-rc0
Message-ID: <20100810155037.GA17552@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive 2nd round of updates for the input subsystem. The main change
is from Daniel Mack to allocate memory to hold ABS data in input devices
only when devices actually produce ABS events as it slims down struct
input_dev significantly.

I also have a couple of patches pending that remove 'tty' argument from
handle_sysrq() and friends as noone uses it, but since the change
comflicts with kgdb a bit I want to wait till after -rc1 to merge it
properly and send it off to you.

Changelog:
---------

Christoph Fritz (1):
      Input: xpad - add USB-ID for PL-3601 Xbox 360 pad

Dan Carpenter (1):
      Input: cy8ctmg100_ts - signedness bug

Daniel Mack (3):
      Input: add static inline accessors for ABS properties
      Input: switch to input_abs_*() access functions
      Input: dynamically allocate ABS information

Dmitry Torokhov (1):
      Input: evdev - rearrange ioctl handling

Michael Hennerich (1):
      Input: adxl34x - do not mark device as disabled on startup

Shubhrajyoti D (1):
      Input: gpio_keys - add hooks to enable/disable device

Éric Piel (2):
      Input: elantech - discard the first 2 positions on some firmwares
      Input: elantech - report position also with 3 fingers


Diffstat:
--------

 drivers/hid/hid-wacom.c                   |   49 +++++-----
 drivers/input/evdev.c                     |  152 ++++++++++++++---------------
 drivers/input/input.c                     |   46 ++++++++-
 drivers/input/joydev.c                    |   31 +++---
 drivers/input/joystick/a3d.c              |    3 +-
 drivers/input/joystick/adi.c              |    2 +-
 drivers/input/joystick/amijoy.c           |    4 +-
 drivers/input/joystick/gf2k.c             |   20 ++--
 drivers/input/joystick/interact.c         |   14 +--
 drivers/input/joystick/sidewinder.c       |   18 ++--
 drivers/input/joystick/xpad.c             |    1 +
 drivers/input/keyboard/gpio_keys.c        |   22 ++++
 drivers/input/keyboard/hil_kbd.c          |   21 +++--
 drivers/input/misc/adxl34x.c              |    1 -
 drivers/input/misc/uinput.c               |   29 +++---
 drivers/input/mouse/elantech.c            |   31 ++++--
 drivers/input/mouse/elantech.h            |    7 +-
 drivers/input/mouse/pc110pad.c            |    4 +-
 drivers/input/mouse/synaptics.c           |    4 +-
 drivers/input/mousedev.c                  |   44 +++++----
 drivers/input/tablet/aiptek.c             |   15 +--
 drivers/input/tablet/wacom_wac.c          |    4 +-
 drivers/input/touchscreen/cy8ctmg110_ts.c |    6 +-
 include/linux/gpio_keys.h                 |    2 +
 include/linux/input.h                     |   53 ++++++----
 25 files changed, 336 insertions(+), 247 deletions(-)

-- 
Dmitry

