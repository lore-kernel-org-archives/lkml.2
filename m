Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1HASG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 14:06:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34819 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab1HASGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 14:06:22 -0400
Subject: [GIT PULL] Regulator updates for 3.1
From: Liam Girdwood <lrg@ti.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 1 Aug 2011 19:05:44 +0100
Message-ID: <1312221944.5170.5.camel@CNA0741383>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following regulator updates for Linus 3.1. No major
changes this time, however there are many driver improvements and fixes
with a few core improvements for debugfs and logging.

Thanks

Liam

---

The following changes since commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe:

  Linux 3.0 (2011-07-21 19:17:23 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Ambresh K (1):
      regulator: TWL: Remove entry of RES_ID for 6030 macros

Axel Lin (4):
      regulator: tps65910: Fix a memory leak in tps65910_probe error path
      regulator: tps65910: Add missing breaks in switch/case
      regulator: tps65910: Fix array access out of bounds bug
      regulator: Fix memory leak in set_machine_constraints() error paths

Colin Cross (1):
      regulator: twl-regulator: fix n_voltages for twl6030 variable LDOs

Jarkko Nikula (1):
      ASoC: tlv320aic3x: Add correct hw registers to Line1 cross connect muxes

Liam Girdwood (1):
      Merge branch 'for-next' into for-linus

Mark Brown (16):
      regulator: Do bulk enables of regulators in parallel
      regulator: Use _cansleep() for WM8994 regulator GPIOs
      regulator: Properly register dummy regulator driver
      regulator: Increase the limit on sysfs file names
      regulator: Include the device name in the microamps_requested_ file
      regulator: Refactor supply implementation to work as regular consumers
      regulator: Add rdev_crit() macro
      regulator: Add basic per consumer debugfs
      regulator: Make core more chatty about some errors
      regulator: Fix argument format type errors in error prints
      regulator: Fix WM831x regulator ID lookups for multiple WM831xs
      regulator: Fix WM831x DCDC DVS VSEL bootstrapping
      regulator: Add EPEs to the MODULE_ALIAS() for wm831x-dcdc
      regulator: Set up GPIO for WM831x VSEL before enabling VSEL mode
      regulator: Bootstrap wm831x DVS VSEL value from ON VSEL if not already set
      regulator: Improve WM831x DVS VSEL selection algorithm

 drivers/regulator/core.c               |  190 ++++++++++++++++++-------------
 drivers/regulator/dummy.c              |   32 +++++-
 drivers/regulator/tps65910-regulator.c |   63 +++++++++--
 drivers/regulator/twl-regulator.c      |   66 +++++------
 drivers/regulator/wm831x-dcdc.c        |  126 +++++++++++----------
 drivers/regulator/wm831x-ldo.c         |   25 ++++-
 drivers/regulator/wm8994-regulator.c   |    4 +-
 include/linux/regulator/consumer.h     |    3 +
 include/linux/regulator/driver.h       |    4 +-
 sound/soc/codecs/tlv320aic3x.c         |   34 ++++--
 10 files changed, 332 insertions(+), 215 deletions(-)


