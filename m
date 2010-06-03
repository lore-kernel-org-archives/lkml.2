Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab0FCLVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 07:21:42 -0400
Received: from bamako.nerim.net ([62.4.17.28]:51483 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab0FCLVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 07:21:40 -0400
Date: Thu, 3 Jun 2010 13:21:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.35, round 2
Message-ID: <20100603132135.71688bb8@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull a second round of i2c subsystem updates for Linux 2.6.35
from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

I know we're past rc1, but these changes are much easier to deal with
when the other subsystems have already settled.

 Documentation/i2c/busses/i2c-ali1535          |    4 +-
 Documentation/i2c/busses/i2c-ali1563          |    2 +-
 Documentation/i2c/busses/i2c-ali15x3          |   16 +-
 Documentation/i2c/busses/i2c-pca-isa          |   14 +-
 Documentation/i2c/busses/i2c-sis5595          |   58 ++++----
 Documentation/i2c/busses/i2c-sis630           |    8 +-
 Documentation/i2c/ten-bit-addresses           |    6 +-
 drivers/hwmon/adt7411.c                       |    2 -
 drivers/hwmon/asc7621.c                       |    2 -
 drivers/hwmon/f75375s.c                       |    2 -
 drivers/hwmon/g760a.c                         |    2 -
 drivers/hwmon/lm73.c                          |    1 -
 drivers/hwmon/lm75.c                          |    2 -
 drivers/hwmon/lm95241.c                       |    1 -
 drivers/hwmon/tmp102.c                        |    2 -
 drivers/hwmon/tmp421.c                        |    2 -
 drivers/hwmon/w83781d.c                       |    2 -
 drivers/i2c/busses/Kconfig                    |   40 +++---
 drivers/i2c/busses/Makefile                   |    6 +-
 drivers/i2c/i2c-core.c                        |  179 +++++++++++++++----------
 drivers/i2c/i2c-smbus.c                       |    1 -
 drivers/input/keyboard/adp5588-keys.c         |    1 -
 drivers/input/keyboard/lm8323.c               |    2 -
 drivers/input/keyboard/max7359_keypad.c       |    1 -
 drivers/input/keyboard/qt2160.c               |    1 -
 drivers/input/keyboard/tca6416-keypad.c       |    2 -
 drivers/input/misc/ad714x-i2c.c               |    1 -
 drivers/input/misc/pcf8574_keypad.c           |    2 -
 drivers/input/mouse/synaptics_i2c.c           |    1 -
 drivers/input/touchscreen/ad7879.c            |    5 +-
 drivers/input/touchscreen/eeti_ts.c           |    2 -
 drivers/input/touchscreen/mcs5000_ts.c        |    1 -
 drivers/input/touchscreen/tsc2007.c           |    2 -
 drivers/leds/leds-bd2802.c                    |    2 -
 drivers/leds/leds-lp3944.c                    |    1 -
 drivers/leds/leds-pca9532.c                   |    5 +-
 drivers/leds/leds-pca955x.c                   |    2 -
 drivers/macintosh/therm_adt746x.c             |    2 -
 drivers/macintosh/windfarm_lm75_sensor.c      |    5 +-
 drivers/macintosh/windfarm_max6690_sensor.c   |    1 -
 drivers/macintosh/windfarm_smu_sat.c          |    1 -
 drivers/media/radio/si470x/radio-si470x-i2c.c |    1 -
 drivers/media/video/mt9m001.c                 |    2 -
 drivers/media/video/mt9m111.c                 |    2 -
 drivers/media/video/mt9t031.c                 |    2 -
 drivers/media/video/mt9t112.c                 |    2 -
 drivers/media/video/mt9v022.c                 |    2 -
 drivers/media/video/ov772x.c                  |    2 -
 drivers/media/video/ov9640.c                  |    2 -
 drivers/media/video/rj54n1cb0c.c              |    2 -
 drivers/media/video/tcm825x.c                 |    8 +-
 drivers/media/video/tw9910.c                  |    2 -
 drivers/mfd/88pm860x-i2c.c                    |    2 -
 drivers/mfd/ab3100-core.c                     |    2 -
 drivers/mfd/ab3550-core.c                     |    1 -
 drivers/mfd/adp5520.c                         |    2 -
 drivers/mfd/da903x.c                          |    2 -
 drivers/mfd/max8925-i2c.c                     |    1 -
 drivers/mfd/menelaus.c                        |    2 -
 drivers/mfd/pcf50633-core.c                   |    2 -
 drivers/mfd/tc35892.c                         |    2 -
 drivers/mfd/tps65010.c                        |    1 -
 drivers/mfd/wm8350-i2c.c                      |    2 -
 drivers/mfd/wm8400-core.c                     |    2 -
 drivers/misc/eeprom/at24.c                    |    1 -
 drivers/mtd/maps/pismo.c                      |    2 -
 drivers/power/max17040_battery.c              |    2 -
 drivers/regulator/lp3971.c                    |    2 -
 drivers/regulator/max1586.c                   |    1 -
 drivers/regulator/max8649.c                   |    2 -
 drivers/regulator/max8660.c                   |    1 -
 drivers/regulator/tps65023-regulator.c        |    3 -
 drivers/rtc/rtc-ds1374.c                      |    2 -
 drivers/rtc/rtc-rx8025.c                      |    2 -
 drivers/rtc/rtc-s35390a.c                     |    2 -
 drivers/staging/dream/synaptics_i2c_rmi.c     |    2 -
 drivers/staging/go7007/wis-saa7113.c          |    2 -
 drivers/staging/go7007/wis-saa7115.c          |    2 -
 drivers/staging/go7007/wis-sony-tuner.c       |    1 -
 drivers/staging/go7007/wis-tw2804.c           |    1 -
 drivers/staging/go7007/wis-tw9903.c           |    2 -
 drivers/staging/iio/adc/max1363_core.c        |    2 -
 drivers/staging/iio/light/tsl2563.c           |    2 -
 drivers/video/backlight/adp8860_bl.c          |    2 -
 drivers/video/backlight/tosa_bl.c             |    2 -
 85 files changed, 191 insertions(+), 287 deletions(-)

---------------

Andrea Gelmini (1):
      Documentation/i2c: Checkpatch cleanup

Jean Delvare (4):
      i2c: Share the I2C device presence detection code
      i2c: Check for address validity on client registration
      i2c: Document reserved I2C addresses
      i2c: Rename i2c_check_addr to i2c_check_addr_busy

Wolfram Sang (2):
      i2c/busses: Move two drivers to embedded section
      i2c: Remove all i2c_set_clientdata(client, NULL) in drivers

Thanks,
-- 
Jean Delvare
