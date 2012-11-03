Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab2KCHoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 03:44:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:23960 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002Ab2KCHoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 03:44:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,704,1344236400"; 
   d="scan'208";a="242101689"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: lenb@kernel.org, rafael.j.wysocki@intel.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: [PATCH 0/3] ACPI 5 support for GPIO, SPI and I2C
Date: Sat,  3 Nov 2012 09:46:30 +0200
Message-Id: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With ACPI 5 we can now describe how devices are connected to their bus
using new resources: SPISerialBus and I2CSerialBus. Also it is now possible
to add GPIO connections for the devices with the help of GpioIO and GpioInt
resources.

This series adds support for these new resources.

The series based on the ACPI 5 enumeration support patches that are available
on Rafael's linux-next branch:

	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next	

Specifically patches from this thread:

	https://lkml.org/lkml/2012/10/31/154

Since these patches depend on the above patches on Rafael's linux-next branch
I suggest that these be merged via that branch, if there are no objections.

The series follows the Device Tree way so that it would be easy to add ACPI
support for the existing SPI and I2C drivers if one is familiar how the
corresponding DT support is done.

For GPIO we introduce a function that maps between ACPI GPIO numbers and Linux
ones - acpi_get_gpio().

SPI slave devices gets enumerated automatically if the master device has
master->dev.acpi_handle set (this is analogous to master->dev.of_mode). The
platform bus code in Rafael's branch assigns the ACPI handle to the master
device.

I2C slave devices can be enumerated by calling acpi_i2c_register_devices() in
the adapter driver.

Thanks,
Mika

Mathias Nyman (1):
  gpio / ACPI: add ACPI support

Mika Westerberg (2):
  spi / ACPI: add ACPI enumeration support
  i2c / ACPI: add ACPI enumeration support

 drivers/acpi/Kconfig        |    6 ++
 drivers/acpi/Makefile       |    1 +
 drivers/acpi/acpi_i2c.c     |  234 +++++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/Kconfig        |    4 +
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/gpiolib-acpi.c |   60 +++++++++++
 drivers/i2c/i2c-core.c      |    9 ++
 drivers/spi/spi.c           |  231 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/acpi_gpio.h   |   19 ++++
 include/linux/acpi_i2c.h    |   29 ++++++
 10 files changed, 593 insertions(+), 1 deletion(-)
 create mode 100644 drivers/acpi/acpi_i2c.c
 create mode 100644 drivers/gpio/gpiolib-acpi.c
 create mode 100644 include/linux/acpi_gpio.h
 create mode 100644 include/linux/acpi_i2c.h

-- 
1.7.10.4

