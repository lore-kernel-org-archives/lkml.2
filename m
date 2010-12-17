Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0LQLWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 06:22:18 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:52660 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177Ab0LQLWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 06:22:16 -0500
From: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
To: Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Subject: [PATCH 00/11] mfd and bluetooth: Add CG2900 support
Date: Fri, 17 Dec 2010 12:20:29 +0100
Message-ID: <1292584829-28279-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the 3rd patch set for the ST-Ericsson CG2900 connectivity
controller. The CG2900 is a combo controller supporting GPS, Bluetooth,
and FM radio. It uses HCI H:4 protocol to combine different functionalities
on a common transport, where first byte in the data indicates the current
channel. Channels 1-4 are standardized in the Bluetooth Core specification
while the other channels are vendor specific.

Compared to 2nd patch set this patch set has the following changes:
 * UART handling is moved from mfd to bluetooth folder. It now reuses the
   existing N_HCI line discipline.
 * mfd creation has been moved from cg2900_core into chip specific files.
 * All information for each channel, including API functions, exist in each
   MFD devices, making them independent of each other.
 * All chip specific information has been moved from cg2900_core into the
   chip specific files. cg2900_core now only handles registration and
   connection between transport and chip driver.
 * Fixes for several review comments including use of existing debug system.

Par-Gunnar Hjalmdahl (11):
  mfd: Add support for CG2900 controller framework
  mfd: Add CG2900 character devices
  mfd: Add support for CG2900 controller
  mfd: Add support for STLC2690 controller
  mfd: Add CG2900 audio
  mfd: Add CG2900 test character device
  Bluetooth: Add UART API functions to ldisc
  Bluetooth: Add support for CG2900 UART
  Bluetooth: Add support for CG2900 controller
  arch_mach-ux500: Add U8500 board support for CG2900
  Bluetooth and mach-ux500: Fix of minor issues

 arch/arm/mach-ux500/Makefile             |    1 +
 arch/arm/mach-ux500/board-mop500.c       |  152 ++
 arch/arm/mach-ux500/devices-cg2900.c     |  315 +++
 arch/arm/mach-ux500/devices-cg2900.h     |   19 +
 drivers/bluetooth/Kconfig                |    7 +
 drivers/bluetooth/Makefile               |    2 +
 drivers/bluetooth/btcg2900.c             | 1134 ++++++++++
 drivers/bluetooth/cg2900_uart.c          | 1849 ++++++++++++++++
 drivers/bluetooth/hci_ath.c              |    1 +
 drivers/bluetooth/hci_bcsp.c             |    3 +-
 drivers/bluetooth/hci_h4.c               |    1 +
 drivers/bluetooth/hci_ldisc.c            |  101 +-
 drivers/bluetooth/hci_ll.c               |    1 +
 drivers/bluetooth/hci_uart.h             |   18 +-
 drivers/mfd/Kconfig                      |   53 +
 drivers/mfd/Makefile                     |    2 +
 drivers/mfd/cg2900/Makefile              |   16 +
 drivers/mfd/cg2900/cg2900_audio.c        | 3415 ++++++++++++++++++++++++++++++
 drivers/mfd/cg2900/cg2900_char_devices.c |  701 ++++++
 drivers/mfd/cg2900/cg2900_chip.c         | 3250 ++++++++++++++++++++++++++++
 drivers/mfd/cg2900/cg2900_chip.h         |  602 ++++++
 drivers/mfd/cg2900/cg2900_core.c         |  711 +++++++
 drivers/mfd/cg2900/cg2900_core.h         |   51 +
 drivers/mfd/cg2900/cg2900_lib.c          |  391 ++++
 drivers/mfd/cg2900/cg2900_lib.h          |   61 +
 drivers/mfd/cg2900/cg2900_test.c         |  402 ++++
 drivers/mfd/cg2900/stlc2690_chip.c       | 1673 +++++++++++++++
 drivers/mfd/cg2900/stlc2690_chip.h       |   47 +
 include/linux/mfd/cg2900.h               |  287 +++
 include/linux/mfd/cg2900_audio.h         |  473 +++++
 include/net/bluetooth/hci.h              |    5 +
 31 files changed, 15734 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm/mach-ux500/devices-cg2900.c
 create mode 100644 arch/arm/mach-ux500/devices-cg2900.h
 create mode 100644 drivers/bluetooth/btcg2900.c
 create mode 100644 drivers/bluetooth/cg2900_uart.c
 create mode 100644 drivers/mfd/cg2900/Makefile
 create mode 100644 drivers/mfd/cg2900/cg2900_audio.c
 create mode 100644 drivers/mfd/cg2900/cg2900_char_devices.c
 create mode 100644 drivers/mfd/cg2900/cg2900_chip.c
 create mode 100644 drivers/mfd/cg2900/cg2900_chip.h
 create mode 100644 drivers/mfd/cg2900/cg2900_core.c
 create mode 100644 drivers/mfd/cg2900/cg2900_core.h
 create mode 100644 drivers/mfd/cg2900/cg2900_lib.c
 create mode 100644 drivers/mfd/cg2900/cg2900_lib.h
 create mode 100644 drivers/mfd/cg2900/cg2900_test.c
 create mode 100644 drivers/mfd/cg2900/stlc2690_chip.c
 create mode 100644 drivers/mfd/cg2900/stlc2690_chip.h
 create mode 100644 include/linux/mfd/cg2900.h
 create mode 100644 include/linux/mfd/cg2900_audio.h

-- 
1.7.3.2

