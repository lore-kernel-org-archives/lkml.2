Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2JEIKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:10:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57603 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab2JEIKC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:10:02 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/28] leds: add common driver for LP5521/5523/55231
Thread-Topic: [PATCH 00/28] leds: add common driver for LP5521/5523/55231
Thread-Index: Ac2i0McZRB0hB7GuTLKlYTxk6YSluQ==
Date: Fri, 5 Oct 2012 08:09:44 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F641766E4@DQHE02.ent.ti.com>
Accept-Language: en-US
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

 Therefore, this series of patch set enables removing duplicate code for
 lp5521/5523 driver and making coherent driver structure.

 All patches have been tested in LP5521, LP5523 and LP55231 boards.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Tested-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/leds/00-INDEX                  |    2 +
 Documentation/leds/leds-lp5521.txt           |   63 +-
 Documentation/leds/leds-lp5523.txt           |   27 +-
 Documentation/leds/leds-lp55xx.txt           |  104 +++
 arch/arm/mach-omap2/board-rx51-peripherals.c |    8 +-
 arch/arm/mach-ux500/board-mop500.c           |   14 +-
 drivers/leds/Kconfig                         |   15 +-
 drivers/leds/Makefile                        |    1 +
 drivers/leds/leds-lp5521.c                   |  928 +++++++---------------
 drivers/leds/leds-lp5523.c                   | 1065 +++++++-------------------
 drivers/leds/leds-lp55xx-common.c            |  516 +++++++++++++
 drivers/leds/leds-lp55xx-common.h            |  138 ++++
 include/linux/leds-lp5521.h                  |   73 --
 include/linux/leds-lp5523.h                  |   49 --
 include/linux/platform_data/leds-lp55xx.h    |   55 ++
 15 files changed, 1374 insertions(+), 1684 deletions(-)
 create mode 100644 Documentation/leds/leds-lp55xx.txt
 create mode 100644 drivers/leds/leds-lp55xx-common.c
 create mode 100644 drivers/leds/leds-lp55xx-common.h
 delete mode 100644 include/linux/leds-lp5521.h
 delete mode 100644 include/linux/leds-lp5523.h
 create mode 100644 include/linux/platform_data/leds-lp55xx.h

Best Regards,
Milo


