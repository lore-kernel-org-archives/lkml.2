Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2KTK0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:26:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:45806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab2KTK0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:26:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,284,1352102400"; 
   d="scan'208";a="251786155"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: grant.likely@secretlab.ca, linus.walleij@linaro.org, w.sang@pengutronix.de,
        rafael.j.wysocki@intel.com
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org,
        broonie@opensource.wolfsonmicro.com, khali@linux-fr.org,
        ben-linux@fluff.org, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v3 0/3] ACPI 5 support for GPIO, SPI and I2C
Date: Tue, 20 Nov 2012 12:29:41 +0200
Message-Id: <1353407384-26880-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a third version of the series. I've based these on top of Rafael's
"simplify glueing ACPI handles to physical nodes" seen here:

	https://lkml.org/lkml/2012/11/19/588

There is a dependency to linux-pm tree and to the above patches so I
propose to merge these via that same tree.

Changes to v2:
	- drop the ACPI ->find_device() glue magic in preference of the new
	  simplified mechanism where we just assign the ACPI handle
	- correct the IRQ resource handling to take the first resource and
	  skip the rest
	- moved declaration of acpi_i2c_register_devices() to i2c.h instead
	  of having a separate header for a single function
	- added acpi_node to struct i2c_board_info (analoguous to of_node).

Changes to the original version:
	[gpio]
	- CONFIG_GPIO_ACPI instead of CONFIG_ACPI_GPIO
	- removed redundant test in acpi_gpiochip_find()

	[spi and i2c]
	- switched to use ACPI centralized _CRS evaluation framework
	  introduced by Rafael 
	- dropped request_module() call
	- dropped the acpi_enumerate_spi/i2c_device()
	- added required includes and dropped <linux/acpi.h> from
	  acpi_i2c.h


Mathias Nyman (1):
  gpio / ACPI: add ACPI support

Mika Westerberg (2):
  spi / ACPI: add ACPI enumeration support
  i2c / ACPI: add ACPI enumeration support

 drivers/acpi/Kconfig        |    6 +++
 drivers/acpi/Makefile       |    1 +
 drivers/acpi/acpi_i2c.c     |  112 +++++++++++++++++++++++++++++++++++++++++
 drivers/gpio/Kconfig        |    4 ++
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/gpiolib-acpi.c |   56 +++++++++++++++++++++
 drivers/i2c/i2c-core.c      |    6 +++
 drivers/spi/spi.c           |  115 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/acpi_gpio.h   |   19 +++++++
 include/linux/i2c.h         |    9 ++++
 10 files changed, 328 insertions(+), 1 deletion(-)
 create mode 100644 drivers/acpi/acpi_i2c.c
 create mode 100644 drivers/gpio/gpiolib-acpi.c
 create mode 100644 include/linux/acpi_gpio.h

-- 
1.7.10.4

