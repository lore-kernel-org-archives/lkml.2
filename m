Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab2H1Lsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:48:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38651 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab2H1Lse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:48:34 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>, shawn.guo@linaro.org,
        thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
Subject: i.MX pwm patches
Date: Tue, 28 Aug 2012 13:48:15 +0200
Message-Id: <1346154504-5623-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following patches are an overdue work on the i.MX pwm driver.

- introduce SoC specific functions to make the driver easier to maintain
- use peripheral clock for pwm output unconditionally
- separate the two clocks this module has
- enable ipg clock for register accesses, peripheral clock for enabling
  the pwm
- make the driver safe for calling pwm_config before pwm_enable
- Add devicetree support for i.MX53

The platform device support is still implemented using cpu_is_*, I think
this can be dropped completely soon as this driver has no in kernel users
currently, so there should be no need to keep compatibility for platform
based boards.

Hopefully this series fixes the issues mentioned by Benoît. It has been
tested on an i.MX53 only.

Sascha

----------------------------------------------------------------
Philipp Zabel (3):
      pwm i.MX: add devicetree support
      pwm i.MX: fix clock lookup
      pwm i.MX: add devicetree support

Sascha Hauer (6):
      pwm i.MX: factor out SoC specific functions
      pwm i.MX: remove unnecessary if in pwm_[en|dis]able
      pwm i.MX: add functions to enable/disable pwm.
      pwm i.MX: Use module_platform_driver
      pwm i.MX: use per clock unconditionally
      ARM i.MX53: Add pwms to dtsi

 arch/arm/boot/dts/imx53.dtsi        |   14 ++
 arch/arm/mach-imx/clk-imx51-imx53.c |    4 +
 drivers/pwm/pwm-imx.c               |  278 +++++++++++++++++++++++------------
 3 files changed, 202 insertions(+), 94 deletions(-)
