Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab1JaVlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:41:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33230 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab1JaVln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:41:43 -0400
Date: Mon, 31 Oct 2011 21:41:36 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Message-ID: <20111031214134.GA21793@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Cookie: When in doubt, follow your heart.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.41.29.181
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regulator updates for 3.2
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the tree below to get updates to the regulator API for
version 3.2.  Since Liam has been slammed with work until very recently
and is still catching up on things like restoring hosting for his git
trees after the kernel.org breakin I'm sending the request instead of
him; hopefully he'll get things sorted out soon but we weren't sure
that'd happen during the merge window.

This has been a quiet release cycle for the regulator API - nothing much
going on in the core and not many driver updates.  The biggest things
are that we've got a new gpio-regulator driver (for devices that select
voltages with GPIOs) and the tps65023 driver gained support for TPS65020
as well.  The two commits from Marcus Folkesson with the same subject
are actually separate commits with similar changelogs.

The following changes since commit 322a8b034003c0d46d39af85bf24fee27b902f48:

  Linux 3.1-rc1 (2011-08-07 18:23:30 -0700)

are available in the git repository at:
  git://opensource.wolfsonmicro.com/regulator.git for-linus

Axel Lin (4):
      regulator: tps65912: Remove unused define of TPS65912_MAX_REG_ID
      regulator: 88pm8607: Fix off-by-one value range checking in the case of no id is matched
      regulator: Ensure enough enable time for max8649
      regulator: tps6507x: Remove num_voltages array

H Hartley Sweeten (1):
      regulator: remove duplicate REG_CTRL2 defines in tps65023

Heiko Stübner (3):
      regulator: Add driver for gpio-controlled regulators
      regulator: gpio-regulator add dependency on GENERIC_GPIO
      regulator: Fix possible nullpointer dereference in regulator_enable()

Marcus Folkesson (5):
      regulator: tps65023: Fixes i2c configuration issues
      regulator: tps65023: Fixes i2c configuration issues
      regulator: tps65023: Set missing bit for update core-voltage
      regulator: tps65023: Setting correct core regulator for tps65021
      regulator: tps65023: Added support for the similiar TPS65020 chip

Mark Brown (5):
      regulator: Add debugfs file showing the supply map table
      regulator: Fix some bitrot in the machine driver documentation
      regulator: Clarify documentation for regulator-regulator supplies
      regulator: Add module.h include to gpio-regulator
      regulator: Constify constraints name

MyungJoo Ham (1):
      regulator: max8952: removed unused mutex.

Randy Dunlap (2):
      regulator: aat2870-regulator.c needs module.h
      regulator: fix regulator/consumer.h kernel-doc warning

Xin Xie (1):
      regulator: tps6586x: add SMx slew rate setting

 Documentation/power/regulator/machine.txt |   19 +-
 drivers/regulator/88pm8607.c              |    2 +-
 drivers/regulator/Kconfig                 |   10 +
 drivers/regulator/Makefile                |    1 +
 drivers/regulator/aat2870-regulator.c     |    1 +
 drivers/regulator/core.c                  |   43 ++++-
 drivers/regulator/gpio-regulator.c        |  358 +++++++++++++++++++++++++++++
 drivers/regulator/max8649.c               |    2 +-
 drivers/regulator/max8952.c               |    3 -
 drivers/regulator/tps65023-regulator.c    |  183 +++++++++++++--
 drivers/regulator/tps6507x-regulator.c    |    8 +-
 drivers/regulator/tps6586x-regulator.c    |   32 +++-
 drivers/regulator/tps65912-regulator.c    |    2 -
 include/linux/mfd/tps6586x.h              |   16 ++
 include/linux/regulator/consumer.h        |    2 +-
 include/linux/regulator/gpio-regulator.h  |   87 +++++++
 include/linux/regulator/machine.h         |    2 +-
 17 files changed, 722 insertions(+), 49 deletions(-)
 create mode 100644 drivers/regulator/gpio-regulator.c
 create mode 100644 include/linux/regulator/gpio-regulator.h

