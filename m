Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab2IENfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:35:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54812 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756580Ab2IENfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:35:47 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: <linux-arm-kernel@lists.infradead.org>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de
Subject: [PATCH v2] pwm i.MX: add devicetree support
Date: Wed,  5 Sep 2012 15:35:19 +0200
Message-Id: <1346852127-25226-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes since v1:

- Add devicetree binding documentation
- Merge 5/9 and 9/9
- fix #pwm-cells (must be 2 instead of 3)
- fix wrong name in MODULE_DEVICE_TABLE
- drop platform based probing while introducing devicetree based probe

----------------------------------------------------------------
Philipp Zabel (2):
      pwm i.MX: add devicetree support
      pwm i.MX: fix clock lookup

Sascha Hauer (6):
      pwm i.MX: factor out SoC specific functions
      pwm i.MX: remove unnecessary if in pwm_[en|dis]able
      pwm i.MX: add functions to enable/disable pwm.
      pwm i.MX: Use module_platform_driver
      pwm i.MX: use per clock unconditionally
      ARM i.MX53: Add pwm support

 Documentation/devicetree/bindings/pwm/imx-pwm.txt |   17 ++
 arch/arm/boot/dts/imx53.dtsi                      |   14 ++
 arch/arm/mach-imx/clk-imx51-imx53.c               |    4 +
 drivers/pwm/pwm-imx.c                             |  275 ++++++++++++++-------
 4 files changed, 214 insertions(+), 96 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/imx-pwm.txt

