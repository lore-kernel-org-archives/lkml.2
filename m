Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab2IJI76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:59:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53805 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab2IJI7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:59:55 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: <linux-arm-kernel@lists.infradead.org>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        kernel@pengutronix.de
Subject: [PATCH v4] pwm: i.MX: add devicetree support
Date: Mon, 10 Sep 2012 10:59:30 +0200
Message-Id: <1347267577-3296-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes since v3:

- Change patches to subject 'pwm:'
- Use uppercase PWM when referring to PWMs
- Change commit message for "factor out SoC specific functions" patch

Changes since v2:

- check return value of clk_prepare_enable
- remove platform based probing

Changes since v1:

- Add devicetree binding documentation
- Merge 5/9 and 9/9
- fix #pwm-cells (must be 2 instead of 3)
- fix wrong name in MODULE_DEVICE_TABLE
- drop platform based probing while introducing devicetree based probe


The following changes since commit fea7a08acb13524b47711625eebea40a0ede69a0:

  Linux 3.6-rc3 (2012-08-22 13:29:06 -0700)

are available in the git repository at:

  git://git.pengutronix.de/git/imx/linux-2.6.git tags/imx-pwm-oftree

for you to fetch changes up to 5e39af20dedff5dca77c36209ddb09729cfe090e:

  pwm: i.MX: fix clock lookup (2012-09-10 10:40:27 +0200)

----------------------------------------------------------------
Cleanup i.MX PWM driver and add devicetree support

----------------------------------------------------------------
Philipp Zabel (2):
      pwm: i.MX: add devicetree support
      pwm: i.MX: fix clock lookup

Sascha Hauer (5):
      pwm: i.MX: factor out SoC specific functions
      pwm: i.MX: remove unnecessary if in pwm_[en|dis]able
      pwm: i.MX: add functions to enable/disable pwm.
      pwm: i.MX: Use module_platform_driver
      pwm: i.MX: use per clock unconditionally

 Documentation/devicetree/bindings/pwm/imx-pwm.txt |   17 ++
 drivers/pwm/pwm-imx.c                             |  278 ++++++++++++++-------
 2 files changed, 199 insertions(+), 96 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pwm/imx-pwm.txt
