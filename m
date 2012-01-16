Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab2APPc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:32:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40027 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2APPc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:32:28 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [RFC] Congatec CGEB base, i2c and watchdog driver support
Date: Mon, 16 Jan 2012 16:32:17 +0100
Message-Id: <1326727940-6078-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d076
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series adds support for the Congatec CGEB interface
found on some Congatec x86 boards. The CGEB interface is a BIOS
interface which provides access to onboard peripherals like I2C
busses and watchdogs. It works by mapping BIOS code and searching
for magic values which specify the entry points to the CGEB call.
The CGEB call is an API provided by the BIOS which provides access
to the functions in an ioctl like fashion.

For more information about the CGEB API have a look at:

http://www.congatec.com/single_news+M5d58c9cd155.html

This document only describes the C API, unfortunately not the
underlying BIOS interface.

Comments very appreciated.

Sascha

Sascha Hauer (3):
      mfd: Add basic support for the Congatec CGEB BIOS interface
      i2c: Add Congatec CGEB I2C driver
      watchdog: Add Congatec CGEB watchdog driver

 drivers/i2c/busses/Kconfig                |    7 +
 drivers/i2c/busses/Makefile               |    1 +
 drivers/i2c/busses/i2c-congatec-cgeb.c    |  206 ++++++++++
 drivers/mfd/Kconfig                       |   10 +
 drivers/mfd/Makefile                      |    1 +
 drivers/mfd/congatec-cgeb.c               |  590 +++++++++++++++++++++++++++++
 drivers/watchdog/Kconfig                  |    9 +
 drivers/watchdog/Makefile                 |    1 +
 drivers/watchdog/congatec_cgeb_watchdog.c |  181 +++++++++
 include/linux/mfd/congatec-cgeb.h         |  105 +++++
 10 files changed, 1111 insertions(+), 0 deletions(-)
 create mode 100644 drivers/i2c/busses/i2c-congatec-cgeb.c
 create mode 100644 drivers/mfd/congatec-cgeb.c
 create mode 100644 drivers/watchdog/congatec_cgeb_watchdog.c
 create mode 100644 include/linux/mfd/congatec-cgeb.h

