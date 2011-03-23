Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671Ab1CWOA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:00:26 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:37600 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755827Ab1CWOAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:00:24 -0400
From: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, <devel@driverdev.osuosl.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Subject: [PATCH 0/2] Add ST-Ericsson CG2900 driver
Date: Wed, 23 Mar 2011 14:58:23 +0100
Message-ID: <1300888703-26400-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds a driver for the ST-Ericsson CG2900 connectivity
controller.
It has earlier been tried to add this driver to the mfd and bluetooth
areas, but due to continued discussions the driver is placed into
staging for the moment.

The patch set contains 2 patches:
 - The first patch adds the driver to the staging directory. It also
   includes modified versions of some files from the Bluetooth UART
   drivers.
 - The second patch contains the device setup for the mach-ux500
   boards such as U8500.

Par-Gunnar Hjalmdahl (2):
  staging: Add ST-Ericsson CG2900 driver
  mach-ux500: Add CG2900 devices

 arch/arm/mach-ux500/Makefile                     |    4 +
 arch/arm/mach-ux500/board-mop500.c               |  160 +
 arch/arm/mach-ux500/devices-cg2900.c             |  349 +++
 arch/arm/mach-ux500/devices-cg2900.h             |   19 +
 drivers/staging/Kconfig                          |    2 +
 drivers/staging/Makefile                         |    1 +
 drivers/staging/cg2900/Kconfig                   |   52 +
 drivers/staging/cg2900/Makefile                  |    6 +
 drivers/staging/cg2900/TODO                      |   21 +
 drivers/staging/cg2900/bluetooth/Makefile        |    9 +
 drivers/staging/cg2900/bluetooth/btcg2900.c      | 1203 ++++++++
 drivers/staging/cg2900/bluetooth/cg2900_uart.c   | 2074 +++++++++++++
 drivers/staging/cg2900/bluetooth/hci_ldisc.c     |  652 ++++
 drivers/staging/cg2900/bluetooth/hci_uart.h      |  105 +
 drivers/staging/cg2900/include/cg2900.h          |  290 ++
 drivers/staging/cg2900/include/cg2900_audio.h    |  473 +++
 drivers/staging/cg2900/include/cg2900_hci.h      |   19 +
 drivers/staging/cg2900/mfd/Makefile              |   18 +
 drivers/staging/cg2900/mfd/cg2900_audio.c        | 3462 ++++++++++++++++++++++
 drivers/staging/cg2900/mfd/cg2900_char_devices.c |  701 +++++
 drivers/staging/cg2900/mfd/cg2900_chip.c         | 3415 +++++++++++++++++++++
 drivers/staging/cg2900/mfd/cg2900_chip.h         |  613 ++++
 drivers/staging/cg2900/mfd/cg2900_core.c         |  713 +++++
 drivers/staging/cg2900/mfd/cg2900_core.h         |   51 +
 drivers/staging/cg2900/mfd/cg2900_lib.c          |  281 ++
 drivers/staging/cg2900/mfd/cg2900_lib.h          |   61 +
 drivers/staging/cg2900/mfd/cg2900_test.c         |  402 +++
 drivers/staging/cg2900/mfd/stlc2690_chip.c       | 1653 +++++++++++
 drivers/staging/cg2900/mfd/stlc2690_chip.h       |   47 +
 29 files changed, 16856 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-ux500/devices-cg2900.c
 create mode 100644 arch/arm/mach-ux500/devices-cg2900.h
 create mode 100644 drivers/staging/cg2900/Kconfig
 create mode 100644 drivers/staging/cg2900/Makefile
 create mode 100644 drivers/staging/cg2900/TODO
 create mode 100644 drivers/staging/cg2900/bluetooth/Makefile
 create mode 100644 drivers/staging/cg2900/bluetooth/btcg2900.c
 create mode 100644 drivers/staging/cg2900/bluetooth/cg2900_uart.c
 create mode 100644 drivers/staging/cg2900/bluetooth/hci_ldisc.c
 create mode 100644 drivers/staging/cg2900/bluetooth/hci_uart.h
 create mode 100644 drivers/staging/cg2900/include/cg2900.h
 create mode 100644 drivers/staging/cg2900/include/cg2900_audio.h
 create mode 100644 drivers/staging/cg2900/include/cg2900_hci.h
 create mode 100644 drivers/staging/cg2900/mfd/Makefile
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_audio.c
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_char_devices.c
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_chip.c
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_chip.h
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_core.c
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_core.h
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_lib.c
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_lib.h
 create mode 100644 drivers/staging/cg2900/mfd/cg2900_test.c
 create mode 100644 drivers/staging/cg2900/mfd/stlc2690_chip.c
 create mode 100644 drivers/staging/cg2900/mfd/stlc2690_chip.h

-- 
1.7.4.1

