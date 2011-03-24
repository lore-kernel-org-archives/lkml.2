Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1CXO7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:59:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49457 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab1CXO7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=LV0FIuZnluwBG4x9ynzqjNQqQxn9nx5yefG0i4lZkPxzmHLyE848ziG9LPHMRwzIbN
         Tal81uL8fRNdFeNUgnZGRVIy+2oWim4EFnXazq8MNXUlRHcQ6cqlPzf8gkExRHpi0W9R
         leN4cgMx+xok26xH/oiB4QoI88yHzW9HiFDRU=
Date: Thu, 24 Mar 2011 17:58:53 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.git
Message-ID: <20110324145853.GA8288@oksana.dev.rtsoft.ru>
Reply-To: cbouatmailru@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull battery-2.6.git tree to receive changes prepared for
2.6.39. In general, there are just various fixes for the drivers,
most notably bq27x00 and bq20z75.

You may notice a commit that touches drivers/leds/. As Richard
Purdie (LEDs subsystem maintainer) seems no longer actively doing
kernel work, I took the patch via my tree as it is needed for some
battery stuff (additional LEDs notifications).

Thanks!


The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  git://git.infradead.org/battery-2.6.git master

Anton Vorontsov (1):
      Merge branch 'bq27x00-for-upstream' of git://git.metafoo.de/linux-2.6

Axel Lin (3):
      bq20z75: Add MODULE_DEVICE_TABLE
      ds2782_battery: Add MODULE_DEVICE_TABLE
      z2_battery: Add MODULE_DEVICE_TABLE

Benson Leung (1):
      bq20z75: Fix time and temp units

Grazvydas Ignotas (1):
      bq27x00: Use single i2c_transfer call for property read

Heikki Krogerus (1):
      twl4030_charger: Make the driver atomic notifier safe

Heiko Stuebner (1):
      s3c_adc_battery: Fix method names when PM not set

Lars-Peter Clausen (11):
      power_supply: Ignore -ENODATA errors when generating uevents
      power_supply: Initialize changed_work before calling device_add
      bq27x00: Add type property
      bq27x00: Improve temperature property precession
      bq27x00: Return -ENODEV for properties if the battery is not present
      bq27x00: Prepare code for addition of bq27000 platform driver
      bq27x00: Add bq27000 support
      bq27x00: Cache battery registers
      bq27x00: Poll battery state
      bq27x00: Give more specific reports on battery status
      bq27x00: Cleanup bq27x00_i2c_read

Pali Rohár (4):
      bq27x00: Fix CURRENT_NOW property
      bq27x00: Add new properties
      bq27x00: Add MODULE_DEVICE_TABLE
      bq27x00: Minor cleanups

Rhyland Klein (5):
      bq20z75: Add support for charge properties
      bq20z75: Add optional battery detect gpio
      bq20z75: Add i2c retry mechanism
      power_supply: Update power_supply_is_watt_property
      bq20z75: Fix issues with present and suspend

Vasily Khoruzhick (3):
      leds: Add ability to blink via simple trigger
      power_supply: Add new LED trigger charging-blink-solid-full
      z2_battery: Fix count of properties

 drivers/leds/led-triggers.c           |   20 +
 drivers/power/Kconfig                 |   14 +
 drivers/power/bq20z75.c               |  310 ++++++++++++---
 drivers/power/bq27x00_battery.c       |  725 +++++++++++++++++++++++++--------
 drivers/power/ds2782_battery.c        |    1 +
 drivers/power/power_supply_core.c     |    4 +-
 drivers/power/power_supply_leds.c     |   19 +
 drivers/power/power_supply_sysfs.c    |    2 +-
 drivers/power/s3c_adc_battery.c       |    4 +-
 drivers/power/twl4030_charger.c       |   25 +-
 drivers/power/z2_battery.c            |    3 +
 include/linux/leds.h                  |    3 +
 include/linux/power/bq20z75.h         |   39 ++
 include/linux/power/bq27x00_battery.h |   19 +
 include/linux/power_supply.h          |   47 +++
 15 files changed, 1009 insertions(+), 226 deletions(-)
 create mode 100644 include/linux/power/bq20z75.h
 create mode 100644 include/linux/power/bq27x00_battery.h
