Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab2AEBXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 20:23:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47360 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab2AEBXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 20:23:44 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, robherring2@gmail.com,
        broonie@opensource.wolfsonmicro.com, Jamie Iles <jamie@jamieiles.com>
Subject: [PATCHv5 0/4] Synopsys DesignWare APB GPIO
Date: Thu,  5 Jan 2012 01:23:35 +0000
Message-Id: <1325726619-31796-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No major changes since v4 apart from a bug in patch 2 that didn't handle
sparsely allocated banks very well (resulting in a potential buffer
overrun) and the higher banks are the ones that are a pig to get to.

Jamie Iles (4):
  of: document common interrupt controller details
  gpio: add a driver for the Synopsys DesignWare APB GPIO block
  gpio: dwapb: add support for GPIO interrupts
  ARM: picoxcell: use new Synopsys Designware GPIO binding

 Documentation/devicetree/bindings/arm/gic.txt      |    8 +-
 .../devicetree/bindings/gpio/snps-dwapb-gpio.txt   |   57 ++++
 Documentation/devicetree/bindings/interrupts.txt   |   17 +
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi             |   19 +-
 arch/arm/boot/dts/picoxcell-pc3x3.dtsi             |   28 +-
 drivers/gpio/Kconfig                               |    9 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-dwapb.c                          |  351 ++++++++++++++++++++
 8 files changed, 456 insertions(+), 34 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/interrupts.txt
 create mode 100644 drivers/gpio/gpio-dwapb.c

-- 
1.7.5.4

