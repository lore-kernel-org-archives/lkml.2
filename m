Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2LLN7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 08:59:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50683 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2LLN7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 08:59:45 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <cooloney@gmail.com>
CC: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/33] leds: cleanup LP5521/5523 LED driver
Thread-Topic: [PATCH 00/33] leds: cleanup LP5521/5523 LED driver
Thread-Index: Ac3YcO0CDWQUo8AuS62wk1akhW9wsQ==
Date: Wed, 12 Dec 2012 13:59:40 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E0AAA1@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LP5521, LP5523 and L55231 have common features as below.

 Register access via the I2C.
 Device initialization/de-initialization.
 Create LED class devices for multiple output channels.
 Device attributes for user-space interface.

Therefore, this patch-set removes duplicate code for LP5521/5523 driver and
makes coherent driver structure, named lp55xx.

All patches have been tested in LP5521, LP5523 and LP55231 evaluation boards.

You can also pull from the location below.
This branch is based on 'for-next' branch of linux-leds.

  https://github.com/milokim/lp55xx.git lp55xx

Cleanups before adding new driver architecture
  leds-lp55xx: cleanup init_device() in lp5521/5523
  leds-lp55xx: cleanup deinit_device() in lp5521/5523
  leds-lp55xx: cleanup init leds in lp5521/5523
  leds-lp55xx: cleanup deinit leds in lp5521/5523
  leds-lp55xx: add device reset function in lp5521/5523
  leds-lp55xx: do chip specific configuration on device init

Replace lp5521, lp5523 driver with new lp55xx driver architecture
  leds-lp55xx: add new common driver for lp5521/5523
  leds-lp55xx: replace name of data structure
  leds-lp55xx: use common lp55xx data structure in _probe()
  leds-lp55xx: use lp55xx common init function in _probe()
  leds-lp55xx: use lp55xx common deinit function
  leds-lp55xx: use lp55xx common led registration function
  leds-lp55xx: use lp55xx_init_led() common function
  leds-lp55xx: use lp55xx_set_brightness() for brightness control
  leds-lp55xx: provide common LED current setting
  leds-lp55xx: use lp55xx_unregister_leds()
  leds-lp55xx: fix error condition in lp55xx_register_leds()
  leds-lp55xx: add new lp55xx_register_sysfs() for FW interface

Adding the firmware interface
  leds-lp55xx: support firmware interface
  leds-lp55xx: use generic firmware interface

Cleanups lp5521, lp5523 device attributes
  leds-lp55xx: support device specific attibutes
  leds-lp55xx: use common driver function for adding attributes

Others
  leds-lp55xx: code refactoring on selftest function
  leds-lp55xx: add unregister dev attr function
  leds-lp55xx: clean up _remove()
  leds-lp55xx: clean up unused data and functions
  leds-lp55xx: clean up definitions
  leds-lp55xx: clean up headers
  leds-lp5521: recovers previous driver patch for return value
  leds-lp5521/5523: use new lp55xx common header
  leds-lp5521/5523: add author and copyright description
  leds-lp55xx: fix problem on removing LED attributes
  Documentation: leds: update LP55xx family devices

 Documentation/leds/00-INDEX                  |    2 +
 Documentation/leds/leds-lp5521.txt           |   63 +-
 Documentation/leds/leds-lp5523.txt           |   27 +-
 Documentation/leds/leds-lp55xx.txt           |  111 +++
 arch/arm/mach-omap2/board-rx51-peripherals.c |    8 +-
 arch/arm/mach-ux500/board-mop500.c           |   14 +-
 drivers/leds/Kconfig                         |   15 +-
 drivers/leds/Makefile                        |    1 +
 drivers/leds/leds-lp5521.c                   |  944 +++++++----------------
 drivers/leds/leds-lp5523.c                   | 1050 +++++++-------------------
 drivers/leds/leds-lp55xx-common.c            |  519 +++++++++++++
 drivers/leds/leds-lp55xx-common.h            |  133 ++++
 include/linux/leds-lp5521.h                  |   73 --
 include/linux/leds-lp5523.h                  |   49 --
 include/linux/platform_data/leds-lp55xx.h    |   87 +++
 15 files changed, 1410 insertions(+), 1686 deletions(-)
 create mode 100644 Documentation/leds/leds-lp55xx.txt
 create mode 100644 drivers/leds/leds-lp55xx-common.c
 create mode 100644 drivers/leds/leds-lp55xx-common.h
 delete mode 100644 include/linux/leds-lp5521.h
 delete mode 100644 include/linux/leds-lp5523.h
 create mode 100644 include/linux/platform_data/leds-lp55xx.h

-- 
1.7.9.5

Best Regards,
Milo

