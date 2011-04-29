Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab1D2W2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:28:20 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:49371 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab1D2W2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:28:15 -0400
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "To"
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: linux-kernel@vger.kernel.org
Cc: platform-driver-x86@vger.kernel.org, linux-serial@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: [RFC 0/5] Support for Technologic Systems TS-5500 board
Date: Fri, 29 Apr 2011 18:21:47 -0400
Message-Id: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.1
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches is a request for comments. It brings the complete support
for the TS-5500 Single Board Computer from Technologic Systems.

The first patch adds detection for TS-5xxx boards (it also works for TS-3xxx
boards).

The second patch adds GPIO support.

The third patch adds support for the RS-485 feature of the ts-5500 SBC.

The fourth patch adds support for the TS-5500 LEDs.

The fifth patch adds support for the analogic to digital converter feature of
the board.

Jerome Oufella (1):
  gpio: add support for Technologic Systems TS-5500 GPIOs

Jonas Fonseca (3):
  platform-drivers-x86: add support for Technologic Systems TS-5xxx
    detection
  leds: add support for Technologic Systems TS-5500 leds
  hwmon: add support for Technologic Systems TS-5500 A-D converter

Vivien Didelot (1):
  serial: add support for Technologic Systems TS-5500 RS-485 serial
    port

 Documentation/ts5xxx-sbcinfo.txt      |   47 +++
 MAINTAINERS                           |   11 +
 drivers/gpio/Kconfig                  |   10 +
 drivers/gpio/Makefile                 |    1 +
 drivers/gpio/ts5500-gpio.c            |  528 +++++++++++++++++++++++++++++++++
 drivers/hwmon/Kconfig                 |   10 +
 drivers/hwmon/Makefile                |    1 +
 drivers/hwmon/ts5500-adc.c            |  481 ++++++++++++++++++++++++++++++
 drivers/leds/Kconfig                  |   12 +
 drivers/leds/Makefile                 |    1 +
 drivers/leds/leds-ts5500.c            |  211 +++++++++++++
 drivers/platform/x86/Kconfig          |   11 +
 drivers/platform/x86/Makefile         |    1 +
 drivers/platform/x86/ts5xxx-sbcinfo.c |  254 ++++++++++++++++
 drivers/tty/serial/8250.c             |   30 ++
 drivers/tty/serial/Kconfig            |   19 ++
 drivers/tty/serial/Makefile           |    1 +
 drivers/tty/serial/ts5500-auto485.c   |   45 +++
 include/linux/ts5500-gpio.h           |   68 +++++
 include/linux/ts5xxx-sbcinfo.h        |   42 +++
 20 files changed, 1784 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ts5xxx-sbcinfo.txt
 create mode 100644 drivers/gpio/ts5500-gpio.c
 create mode 100644 drivers/hwmon/ts5500-adc.c
 create mode 100644 drivers/leds/leds-ts5500.c
 create mode 100644 drivers/platform/x86/ts5xxx-sbcinfo.c
 create mode 100644 drivers/tty/serial/ts5500-auto485.c
 create mode 100644 include/linux/ts5500-gpio.h
 create mode 100644 include/linux/ts5xxx-sbcinfo.h

