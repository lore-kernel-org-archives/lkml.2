Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2H0Pql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:46:41 -0400
Received: from mail1.adetelgroup.com ([78.155.151.235]:43092 "HELO
	mail1.adetelgroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752964Ab2H0Ppr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:45:47 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Aug 2012 11:45:43 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: git-send-email 1.7.1
Content-class: urn:content-classes:message
Subject: [PATCH v2 0/2] imx6q: pwm: Activate stop_mode and configure pinmux
Date: Mon, 27 Aug 2012 17:34:30 +0200
Message-ID: <3465D313FDFB824F9A9C8CD24FA4F6BCB4ACFC@frontmail.adetel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2 0/2] imx6q: pwm: Activate stop_mode and configure pinmux
thread-index: Ac2EaZK8X+VhcnJ5QGqHD+4NKdYSJA==
From: "HACHIMI Samir" <shachimi@adeneo-embedded.com>
To: <shawn.guo@linaro.org>, <thierry.reding@avionic-design.de>
Cc: <linux-arm-kernel@lists.infradead.org>, <s.hauer@pengutronix.de>,
        <linux-kernel@vger.kernel.org>,
        "HACHIMI Samir" <shachimi@adeneo-embedded.com>
X-OriginalArrivalTime: 27 Aug 2012 15:35:28.0871 (UTC) FILETIME=[961FC770:01CD8469]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samir Hachimi <shachimi@adeneo-embedded.com>

This patch series enables support for pwm driver on imx6q SoC. The first
patch of the series configure the pinctrl for pwm in device-tree. Actually
they are several pin who can be set to pwmO for each pwm, so I assume that
all of them must be enabled when configuring pin.
The second patch activate stop_enable mode and unset the enable bit during
configuration of pwm, and set the enable bit in pwm CR register during enable.

Changes since v1:
Remove default pwm pinmux configuration in DT as Shawn and Matt suggested.
Now, pwm used pwm's clocks properties to configure pwm's clock.
Need Shawn's patch '[PATCH v2 0/4] Move imx6q/28/23 clock lookup over to device tree' to work.
Use Benoît's '[PATCH] pwm-imx: Fix config / enable / disable' (un)setting the cr enable bit to enable/disable pwm.
The second patch used driver_data instead of cpu_is_xxx macros, to check used architecture and enabled stop_enable mode.


Samir Hachimi (2):
  Add clock look-up for pwm.
  Enable Stop_enable mode during configuration of pwm.

 arch/arm/boot/dts/imx6q.dtsi |   68 ++++++++++++++++++++++++++++++++++++++++++
 drivers/pwm/pwm-imx.c        |   59 ++++++++++++++++++++++++++----------
 2 files changed, 111 insertions(+), 16 deletions(-)
