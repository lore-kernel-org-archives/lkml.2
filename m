Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab2AHShb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 13:37:31 -0500
Received: from mail.df.lth.se ([194.47.250.12]:16293 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab2AHSh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 13:37:29 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jan 2012 13:37:29 EST
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: =?UTF-8?q?=5BGIT=20PULL=5D=20pin=20control=20changes=20for=203=2E3?=
Date: Sun,  8 Jan 2012 19:30:50 +0100
Message-Id: <1326047450-6737-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.6.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

these are the pinctrl changes I've stacked up for 3.3.

The only bigger change is the addition of a pin
configuration API. This makes it possible to, well, config
stuff on pins. Usually this tends to be things like biasing
(pull-up, pull-down), drive strength, schmitt-triggering,
drive mode (open collector/open drain) etc.

We haven't yet merged any users of this interface, but these
can be expected in the next merge window.

Apart from that it is basically it's a bunch of refinements
where especially Stephen Warren deserves credit for
straightening out some design issues in the stuff merged
in 3.2.

Myself I've mostly renamed stuff, moved the COH901 driver
over from the GPIO subsystem (it's a copuled twin unit
with the U300 pin controller actually).

I was close to merging the PXA pin controller code for this
set, increasing the users from two to three platforms, but
I've decided to be conservative this time. We have a number
of potential platforms cooking so next time there may be
some serious migration to this subsystem.

Most stuff has been maturing in linux-next for a while
except the two top commits from Chanho Park which are
essentially fixes and would be -rc material anyway.

Please pull it in.

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git for-next

Barry Song (1):
      pinctrl/sirf: fix pin number typo for SPI1

Chanho Park (3):
      pinctrl: add a pin_base for sparse gpio-ranges
      pinctrl: correct a offset while enumerating pins
      pinctrl: remove unnecessary max pin number

Dong Aisheng (1):
      pinctrl: some typo fixes

Linus Walleij (14):
      pinctrl: move group lookup to core
      pinctrl: documentation update
      pinctrl: print pin range in GPIO range debugs
      pinctrl: GPIO direction support for muxing
      pinctrl: make a copy of pinmux map
      pinctrl: make it possible to add multiple maps
      ARM: u300: localize GPIO assignments
      pinctrl: move the U300 GPIO driver to pinctrl
      pinctrl: u300-pinmux: register proper GPIO ranges
      pinctrl/coh901: driver to request its pins
      pinctrl: add a pin config interface
      pinctrl: add a group-specific hog macro
      pinctrl: conjure names for unnamed pins
      pinctrl: rename U300 and SIRF pin controllers

Marek Belisko (2):
      pinctrl: remove double pin validity check.
      pinctrl: unify pin type from signed to unsigned

Rajendra Nayak (1):
      pinctrl: iterate over u300_pmx_mask's in u300_pmx_endisable

Stephen Warren (7):
      MAINTAINERS: Fix pinctrl subsystem's directory
      pinctrl: add explicit gpio_disable_free pinmux_op
      pinctrl: implement PINMUX_MAP_SYS_HOG
      arm/u300: don't use PINMUX_MAP_PRIMARY*
      pinctrl: don't create a device for each pin controller
      pinctrl: add "struct seq_file;" to pinconf.h
      pinctrl: pass name instead of device to pin_config_*

Uwe Kleine-König (2):
      pinctrl: make the "Debug PINCTRL calls" entry actually do something
      pinctrl: remove two unused global variables

 Documentation/pinctrl.txt                          |  258 +++++++++++-----
 MAINTAINERS                                        |    2 +-
 arch/arm/mach-u300/Kconfig                         |    4 +-
 arch/arm/mach-u300/core.c                          |   14 +-
 arch/arm/mach-u300/include/mach/gpio-u300.h        |  115 -------
 arch/arm/mach-u300/include/mach/irqs.h             |    2 +-
 arch/arm/mach-u300/mmc.c                           |    2 +-
 arch/arm/mach-u300/u300-gpio.h                     |  114 +++++++
 drivers/gpio/Kconfig                               |    9 -
 drivers/gpio/Makefile                              |    1 -
 drivers/pinctrl/Kconfig                            |   22 +-
 drivers/pinctrl/Makefile                           |    8 +-
 drivers/pinctrl/core.c                             |  143 +++++++---
 drivers/pinctrl/core.h                             |   13 +-
 drivers/pinctrl/pinconf.c                          |  326 ++++++++++++++++++++
 drivers/pinctrl/pinconf.h                          |   36 +++
 .../{gpio/gpio-u300.c => pinctrl/pinctrl-coh901.c} |   21 ++
 drivers/pinctrl/{pinmux-sirf.c => pinctrl-sirf.c}  |    9 +-
 drivers/pinctrl/{pinmux-u300.c => pinctrl-u300.c}  |   47 ++-
 drivers/pinctrl/pinmux.c                           |  265 ++++++++++------
 include/linux/pinctrl/machine.h                    |   30 +--
 include/linux/pinctrl/pinconf.h                    |   97 ++++++
 include/linux/pinctrl/pinctrl.h                    |   15 +-
 include/linux/pinctrl/pinmux.h                     |   29 ++-
 24 files changed, 1169 insertions(+), 413 deletions(-)
 create mode 100644 arch/arm/mach-u300/u300-gpio.h
 create mode 100644 drivers/pinctrl/pinconf.c
 create mode 100644 drivers/pinctrl/pinconf.h
 rename drivers/{gpio/gpio-u300.c => pinctrl/pinctrl-coh901.c} (98%)
 rename drivers/pinctrl/{pinmux-sirf.c => pinctrl-sirf.c} (99%)
 rename drivers/pinctrl/{pinmux-u300.c => pinctrl-u300.c} (96%)
 create mode 100644 include/linux/pinctrl/pinconf.h

Yours,
Linus Walleij
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPCd+/AAoJEEEQszewGV1zNTQP/i8tBxg9WtQWgujOxsueLioA
TmJjvr8Fr6b64zaDClzlHNoftTFsofYp97DYlkxDb9Tdg1HTENg2TegTy5OKqkfj
aOsOIDpgam6JXxf+53w7RGJ2LVnOHb91DCd4fWFv3ZaB0KVeDGf/cMKrJDh7P/p4
x7ydpPplutQdZ1EZrYkzO87njY4Ze2Zyyn+4/O7ZgA4UCuPm340Pt2AB2dnMVp+W
q7umCFQWWQtCpcHJndWHOVisxX1I0B/+MGiKyBOTMFQ5/jensXZO7/l1No9CKxEK
s5koSRjyT+tc+1opyys/B52evCfKjY6dCBChl3O1P1tCzfHYkTdXbB/OoCwFquiV
sN7to0wIvfqs2KhyMDx+gzeKtG4lokGwR9681RtL3kHtHmaGYCYSOV6nmGmTqwb0
h8jkgj36pHKu6xzZvs2NZdq/+aaaxKgeBXtyb4LaouH2jxPaDSvEoFWaPdOxkQnQ
j830SVlEebvi/IuJy1lKBcSwr9RZY5g0i7/t1gRZH5/2A27p4fLIbcf3BXJNoAF1
8+grDFHr7qGjskWLJhhln1gnwIu3zZ0jlJ+NRAAJ5XQ6iqwj0jjaOor0/3G7m+0E
3pF7oaS4NnvJZ59NkWcaymMKTBiUpVyVi5w5baP54iYFuWU84ykb7UWGc8n2Y5Jr
PjSv8EjQvLQ+hYPKT3Mf
=yQTm
-----END PGP SIGNATURE-----
