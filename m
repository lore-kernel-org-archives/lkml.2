Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0JVKeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 06:34:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59521 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab0JVKeU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 06:34:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:date:x-google-sender-auth:message-id
         :subject:from:to:content-type:content-transfer-encoding;
        b=fRjrRKbeDCmUIcL0NmYMSdX636OaqAJ8VsXLwZEb0sDNR3aYdwD5wtQNvld3D655R7
         l5qz776UC4DVRHlC9ey1MFIVlPTlLhEdQGgxlwRdPH8CQcHFIPwyO91IOT++WZE/VxrF
         Yj5JnkZcrE0kBaW+lWNxVjnXhmgfS5Ns6PPZU=
MIME-Version: 1.0
Reply-To: pghatwork@gmail.com
Date: Fri, 22 Oct 2010 12:34:18 +0200
X-Google-Sender-Auth: LTyA7lyZjhkfEgtsBZpWd6bGTTI
Message-ID: <AANLkTik5HRJpzQbSbbn9o7AW-atG7Rm_p9GaTZZn1oZZ@mail.gmail.com>
Subject: [PATCH 0/9] Add support for ST-Ericsson CG2900
From: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
To: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second patch set adding support to the ST-Ericsson CG2900
Connectivity Combo controller.
CG2900 is a controller supporting GPS, Bluetooth, and FM RX/TX. More info can be
found at http://www.stericsson.com/product/223489.jsp

Compared to the first patch set, this patch set includes use of MFD cells and
proper use of platform device registration. It also addresses comments received
for the first patch set.

Par-Gunnar Hjalmdahl (9):
 MFD: Add support for the ST-Ericsson CG2900.
 MFD: Add char devices for the ST-Ericsson CG2900.
 MFD: Add chip handler for the ST-Ericsson CG2900.
 MFD: Add chip handler for the ST-Ericsson STLC2690.
 MFD: Add UART support for the ST-Ericsson CG2900.
 MFD: Add support for the ST-Ericsson CG2900 Audio.
 arch/arm/mach-ux500: Add support for the ST-Ericsson CG2900.
 Bluetooth: Add support for the ST-Ericsson CG2900.
 DocBook: Add ST-Ericsson CG2900 docs

Documentation/DocBook/Makefile             |    2 +-
Documentation/DocBook/cg2900.tmpl          | 1332 ++++++++++++
arch/arm/mach-ux500/Makefile               |    1 +
arch/arm/mach-ux500/board-mop500.c         |    3 +
arch/arm/mach-ux500/devices-cg2900.c       |  261 +++
arch/arm/mach-ux500/include/mach/devices.h |    4 +
drivers/bluetooth/Kconfig                  |    7 +
drivers/bluetooth/Makefile                 |    1 +
drivers/bluetooth/btcg2900.c               |  925 +++++++++
drivers/mfd/Kconfig                        |   35 +
drivers/mfd/Makefile                       |    3 +
drivers/mfd/cg2900/Makefile                |   16 +
drivers/mfd/cg2900/cg2900_audio.c          | 3026 ++++++++++++++++++++++++++++
drivers/mfd/cg2900/cg2900_char_devices.c   |  745 +++++++
drivers/mfd/cg2900/cg2900_chip.c           | 2238 ++++++++++++++++++++
drivers/mfd/cg2900/cg2900_chip.h           |  588 ++++++
drivers/mfd/cg2900/cg2900_core.c           | 2401 ++++++++++++++++++++++
drivers/mfd/cg2900/cg2900_core.h           |  303 +++
drivers/mfd/cg2900/cg2900_debug.h          |   76 +
drivers/mfd/cg2900/cg2900_uart.c           | 1851 +++++++++++++++++
drivers/mfd/cg2900/hci_defines.h           |   81 +
drivers/mfd/cg2900/stlc2690_chip.c         | 1150 +++++++++++
drivers/mfd/cg2900/stlc2690_chip.h         |   37 +
include/linux/mfd/cg2900.h                 |  187 ++
include/linux/mfd/cg2900_audio.h           |  460 +++++
25 files changed, 15732 insertions(+), 1 deletions(-)
create mode 100644 Documentation/DocBook/cg2900.tmpl
create mode 100644 arch/arm/mach-ux500/devices-cg2900.c
create mode 100644 drivers/bluetooth/btcg2900.c
create mode 100644 drivers/mfd/cg2900/Makefile
create mode 100644 drivers/mfd/cg2900/cg2900_audio.c
create mode 100644 drivers/mfd/cg2900/cg2900_char_devices.c
create mode 100644 drivers/mfd/cg2900/cg2900_chip.c
create mode 100644 drivers/mfd/cg2900/cg2900_chip.h
create mode 100644 drivers/mfd/cg2900/cg2900_core.c
create mode 100644 drivers/mfd/cg2900/cg2900_core.h
create mode 100644 drivers/mfd/cg2900/cg2900_debug.h
create mode 100644 drivers/mfd/cg2900/cg2900_uart.c
create mode 100644 drivers/mfd/cg2900/hci_defines.h
create mode 100644 drivers/mfd/cg2900/stlc2690_chip.c
create mode 100644 drivers/mfd/cg2900/stlc2690_chip.h
create mode 100644 include/linux/mfd/cg2900.h
create mode 100644 include/linux/mfd/cg2900_audio.h
