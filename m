Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2CCLkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 06:40:12 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50103 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2CCLkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 06:40:11 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        Estevam Fabio-R49496 <r49496@freescale.com>
Subject: [PATCH] Add helper for registering a fixed regulator
Date: Sat,  3 Mar 2012 12:40:00 +0100
Message-Id: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The following adds a helper for registering a fixed dummy regulator
making it simple for boards which have no software controllable regulator
for certain devices to register a fixed regulator as a dummy.

The last two patches make smsc911x ethernet functional again which
broke when the smsc911x driver gained regulator support.

Sascha

----------------------------------------------------------------
Sascha Hauer (4):
      regulator fixed: Do not report enumaratable voltages if there are none
      regulator: provide a helper for registering a fixed regulator
      ARM i.MX pcm037: register a dummy regulator for the smsc911x device
      ARM i.MX 3ds debugboard: register a dummy regulator for the smsc911x device

 arch/arm/mach-imx/mach-pcm037.c    |    9 ++++++
 arch/arm/plat-mxc/3ds_debugboard.c |    9 ++++++
 drivers/regulator/Makefile         |    2 +-
 drivers/regulator/fixed-helper.c   |   53 ++++++++++++++++++++++++++++++++++++
 drivers/regulator/fixed.c          |    4 ++-
 include/linux/regulator/fixed.h    |   13 +++++++++
 6 files changed, 88 insertions(+), 2 deletions(-)
 create mode 100644 drivers/regulator/fixed-helper.c
