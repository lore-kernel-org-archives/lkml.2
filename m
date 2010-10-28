Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934131Ab0J1SuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:50:05 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:30042 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934001Ab0J1St7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:49:59 -0400
Date: Thu, 28 Oct 2010 20:49:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [GIT PULL] hwmon updates for 2.6.37
Message-ID: <20101028204948.2a89ad83@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem updates for Linux 2.6.37 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

The main changes are a lot of fixes, improvements and new device
support in the lm90 driver, and the new w83795 driver for the
Winbond/Nuvoton W83795G/ADG devices (still work in progress, but
usable.)

 Documentation/hwmon/it87                     |   28 +-
 Documentation/hwmon/lm85                     |   60 +-
 Documentation/hwmon/lm90                     |   42 +-
 Documentation/hwmon/pcf8591                  |   18 +-
 Documentation/hwmon/sysfs-interface          |   15 +
 MAINTAINERS                                  |    8 +-
 drivers/hwmon/Kconfig                        |  100 +-
 drivers/hwmon/Makefile                       |    2 +-
 drivers/hwmon/adt7475.c                      |    2 +-
 drivers/hwmon/asc7621.c                      |    4 +-
 drivers/hwmon/it87.c                         |  210 ++-
 drivers/hwmon/k8temp.c                       |   51 +-
 drivers/hwmon/lm75.c                         |   51 +-
 drivers/hwmon/lm85.c                         |   36 +-
 drivers/hwmon/lm90.c                         | 1014 +++++++++----
 drivers/hwmon/pcf8591.c                      |   38 +-
 drivers/hwmon/s3c-hwmon.c                    |    8 +-
 drivers/hwmon/tmp421.c                       |    4 +-
 drivers/hwmon/w83795.c                       | 2121 ++++++++++++++++++++++++++
 drivers/macintosh/Kconfig                    |   26 +
 drivers/macintosh/Makefile                   |    2 +
 drivers/{hwmon => macintosh}/ams/Makefile    |    0
 drivers/{hwmon => macintosh}/ams/ams-core.c  |    0
 drivers/{hwmon => macintosh}/ams/ams-i2c.c   |    0
 drivers/{hwmon => macintosh}/ams/ams-input.c |    0
 drivers/{hwmon => macintosh}/ams/ams-pmu.c   |    0
 drivers/{hwmon => macintosh}/ams/ams.h       |    0
 27 files changed, 3284 insertions(+), 556 deletions(-)
 create mode 100644 drivers/hwmon/w83795.c
 rename drivers/{hwmon => macintosh}/ams/Makefile (100%)
 rename drivers/{hwmon => macintosh}/ams/ams-core.c (100%)
 rename drivers/{hwmon => macintosh}/ams/ams-i2c.c (100%)
 rename drivers/{hwmon => macintosh}/ams/ams-input.c (100%)
 rename drivers/{hwmon => macintosh}/ams/ams-pmu.c (100%)
 rename drivers/{hwmon => macintosh}/ams/ams.h (100%)

---------------

Andreas Herrmann (1):
      hwmon: (k8temp) Remove superfluous CPU family check

Guenter Roeck (12):
      hwmon: Add tempX_emergency attribute to sysfs ABI
      hwmon: (lm90) Fix checkpatch errors
      hwmon: (lm90) Introduce device feature bits
      hwmon: (lm90) Introduce function to delete sysfs files
      hwmon: (lm90) Simplify set_temp11 register calculations
      hwmon: (lm90) Add explicit support for max6659
      hwmon: (lm90) Add support for extra features of max6659
      hwmon: (lm90) Add support for max6695 and max6696
      hwmon: (lm90) Rearrange code to no longer require forward declarations
      hwmon: (lm90) Introduce chip parameter structure
      hwmon: (lm90) Introduce capability flag to indicate broken ALERT functionality
      hwmon: (lm90) Add support for update_interval sysfs attribute

Jean Delvare (50):
      hwmon: (lm90) Add support for the W83L771W/G
      hwmon: (w83795) Misc cleanups
      hwmon: (w83795) Drop duplicate enum
      hwmon: (w83795) Refactor bank selection
      hwmon: (w83795) Improve detection routine
      hwmon: (w83795) Move files removal to a separate function
      hwmon: (w83795) Move file creation to a separate function too
      hwmon: (w83795) Merge w83795_create_files and w83795_remove_files
      hwmon: (w83795) Use 2D arrays for many device attributes
      hwmon: (w83795) Move PWM attributes to a dedidated array
      hwmon: (w83795) Only create fan[1-8]_target files when needed
      hwmon: (w83795) Add const markers
      hwmon: (w83795) Only start monitoring if needed
      hwmon: (w83795) Fix in17-in20 gain factor
      hwmon: (w83795) Clean up probe function
      hwmon: (w83795) Fix LSB reading of fan speeds
      hwmon: (w83795) Add support for dynamic in0-2 limits
      hwmon: (w83795) Fix PWM duty cycle frequency attributes
      hwmon: (w83795) Rename temperature limit attributes
      hwmon: (w83795) Properly handle negative temperatures
      hwmon: (w83795) Report PECI agent Tbase values
      hwmon: (w83795) Rework beep_enable implementation
      hwmon: (w83795) Avoid reading the same register twice
      hwmon: (w83795) Get rid of VRLSB_SHIFT
      hwmon: (w83795) Fix parity checks
      hwmon: (w83795) Drop REST_VLT_BEGIN/END
      hwmon: (w83795) Drop _NUM constants
      hwmon: (w83795) Simplify temperature sensor type handling
      hwmon: (w83795) Don't pre-read values we'll update later
      hwmon: (w83795) Make W83795_REG_PWM more efficient
      hwmon: (w83795) Pack similar register reads
      hwmon: (w83795) Move register reads to dedicated functions
      hwmon: (w83795) Delay reading limit registers
      hwmon: (w83795) Delay reading pwm config registers
      hwmon: (w83795) Use dev_get_drvdata() where possible
      hwmon: (w83795) Fix LSB reading of voltage limits
      hwmon: (w83795) More style cleanups
      hwmon: (w83795) Add myself as co-author and maintainer
      hwmon: (w83795) Exclude fan control feature by default
      hwmon: (w83795) Use standard attributes for chassis intrusion
      hwmon: (pcf8591) Register as a hwmon device
      hwmon: (pcf8591) Don't attempt to detect devices
      Move ams driver to macintosh
      hwmon: I2C addresses are constant
      hwmon: (lm85) Fix ADT7468 frequency table
      hwmon: (lm85) Document the ADT7468 as supported
      hwmon: (lm85) Add support for ADT7468 high-frequency PWM mode
      hwmon: Remove many EXPERIMENTAL flags
      hwmon: (it87) Move conversion functions
      hwmon: (it87) Add support for the IT8721F/IT8758E

Maurus Cuelenaere (1):
      hwmon: (s3c-hwmon) Depend on S3C_ADC

Shubhrajyoti D (2):
      hwmon: (lm75) Make the writing to sysfs more robust
      hwmon: (lm75) Trivial changes to pacify the checkpatch

Thomas Gleixner (1):
      hwmon: (s3c-hwmon) Use a real mutex

Wei Song (1):
      hwmon: New driver for the W83795G/ADG monitoring chips

Thanks,
-- 
Jean Delvare
