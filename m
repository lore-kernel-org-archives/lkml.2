Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1GFQb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:31:28 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:5941 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1GFQb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:31:27 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>
Subject: [PATCH v3 0/3] Add device tree probe for imx/mxc gpio
Date: Thu, 7 Jul 2011 00:37:40 +0800
Message-ID: <1309970263-13239-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch removes the uses of cpu_is_mx(), the second one
changes mxc gpio number macro, and the third one adds actual device
tree probe support.

Changes since v2:
 * Keep platform case gpio range code path unchanged, and get range
   from gpio core only for dt case.

Changes since v1:
 * Address review comments given by Grant and Sascha
 * Add patch #1 to get gpio range/base from gpio core

Shawn Guo (3):
      gpio/mxc: get rid of the uses of cpu_is_mx()
      ARM: mxc: use ARCH_NR_GPIOS to define gpio number
      gpio/mxc: add device tree probe support

 .../devicetree/bindings/gpio/fsl-imx-gpio.txt      |   22 +++
 arch/arm/mach-imx/mm-imx1.c                        |    8 +-
 arch/arm/mach-imx/mm-imx21.c                       |   12 +-
 arch/arm/mach-imx/mm-imx25.c                       |    9 +-
 arch/arm/mach-imx/mm-imx27.c                       |   13 +-
 arch/arm/mach-imx/mm-imx31.c                       |    6 +-
 arch/arm/mach-imx/mm-imx35.c                       |    7 +-
 arch/arm/mach-mx5/mm-mx50.c                        |   13 +-
 arch/arm/mach-mx5/mm.c                             |   24 ++--
 arch/arm/plat-mxc/devices/platform-gpio-mxc.c      |    4 +-
 arch/arm/plat-mxc/include/mach/common.h            |    2 +-
 arch/arm/plat-mxc/include/mach/irqs.h              |   21 +---
 drivers/gpio/gpio-mxc.c                            |  157 +++++++++++++++++---
 13 files changed, 211 insertions(+), 87 deletions(-)

