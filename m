Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1DZLki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:40:38 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:38133 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754564Ab1DZLkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:40:37 -0400
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
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Subject: [PATCH v5] Add ST-Ericsson CG2900 driver
Date: Tue, 26 Apr 2011 13:40:10 +0200
Message-ID: <1303818010-24238-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
X-Mailer: git-send-email 1.7.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a driver for the ST-Ericsson CG2900 connectivity controller.
It has earlier been tried to add this driver to the mfd and bluetooth areas,
but due to continued discussions the driver is placed into staging for the moment.

Compared to v4 this patch has the following update:
 - Updated driver after changes to MFD and TTY interfaces in linux-next.

Par-Gunnar Hjalmdahl (1):
  staging: Add ST-Ericsson CG2900 driver

 drivers/staging/Kconfig                          |    2 +
 drivers/staging/Makefile                         |    1 +
 drivers/staging/cg2900/Kconfig                   |   70 +
 drivers/staging/cg2900/Makefile                  |   12 +
 drivers/staging/cg2900/TODO                      |   23 +
 drivers/staging/cg2900/bluetooth/Makefile        |    9 +
 drivers/staging/cg2900/bluetooth/btcg2900.c      | 1209 ++++++++
 drivers/staging/cg2900/bluetooth/cg2900_uart.c   | 2074 +++++++++++++
 drivers/staging/cg2900/bluetooth/hci_ldisc.c     |  657 ++++
 drivers/staging/cg2900/bluetooth/hci_uart.h      |  105 +
 drivers/staging/cg2900/board-mop500-cg2900.c     |  204 ++
 drivers/staging/cg2900/devices-cg2900.c          |  342 +++
 drivers/staging/cg2900/devices-cg2900.h          |   31 +
 drivers/staging/cg2900/include/cg2900.h          |  278 ++
 drivers/staging/cg2900/include/cg2900_audio.h    |  473 +++
 drivers/staging/cg2900/include/cg2900_hci.h      |   19 +
 drivers/staging/cg2900/mfd/Makefile              |   18 +
 drivers/staging/cg2900/mfd/cg2900_audio.c        | 3462 ++++++++++++++++++++++
 drivers/staging/cg2900/mfd/cg2900_char_devices.c |  707 +++++
 drivers/staging/cg2900/mfd/cg2900_chip.c         | 3393 +++++++++++++++++++++
 drivers/staging/cg2900/mfd/cg2900_chip.h         |  613 ++++
 drivers/staging/cg2900/mfd/cg2900_core.c         |  713 +++++
 drivers/staging/cg2900/mfd/cg2900_core.h         |   51 +
 drivers/staging/cg2900/mfd/cg2900_lib.c          |  281 ++
 drivers/staging/cg2900/mfd/cg2900_lib.h          |   61 +
 drivers/staging/cg2900/mfd/cg2900_test.c         |  402 +++
 drivers/staging/cg2900/mfd/stlc2690_chip.c       | 1643 ++++++++++
 drivers/staging/cg2900/mfd/stlc2690_chip.h       |   47 +
 28 files changed, 16900 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/cg2900/Kconfig
 create mode 100644 drivers/staging/cg2900/Makefile
 create mode 100644 drivers/staging/cg2900/TODO
 create mode 100644 drivers/staging/cg2900/bluetooth/Makefile
 create mode 100644 drivers/staging/cg2900/bluetooth/btcg2900.c
 create mode 100644 drivers/staging/cg2900/bluetooth/cg2900_uart.c
 create mode 100644 drivers/staging/cg2900/bluetooth/hci_ldisc.c
 create mode 100644 drivers/staging/cg2900/bluetooth/hci_uart.h
 create mode 100644 drivers/staging/cg2900/board-mop500-cg2900.c
 create mode 100644 drivers/staging/cg2900/devices-cg2900.c
 create mode 100644 drivers/staging/cg2900/devices-cg2900.h
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
1.7.4.3

