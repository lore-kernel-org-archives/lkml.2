Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3AGFJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:09:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:39070 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab3AGFJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:09:35 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sekhar Nori <nsekhar@ti.com>, Vaibhav Hiremath <hvaibhav@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCH 00/10] video: da8xx-fb: DT support
Date: Mon, 7 Jan 2013 10:40:02 +0530
Message-ID: <cover.1357304090.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds DT support to da8xx-fb driver (device found on
DaVinci and AM335x SoC's). It does certain cleanup's in the process.

This makes use of Steffen Trumtrar's v16 of display timing DT support.

Testing has been done on AM335x SoC based boards like AM335x EVM and
AM335x EVM-SK. It has also been verified that display on DA850 EVM
(non-DT boot) works as earlier.

Another series that adds DT nodes for AM335x SoC/board would follow
this.

This series is based on v3.8-rc2,
 and is dependent on,
1. Series v16 "of: add display helper" by,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
2. Patch "da8xx: Allow use by am33xx based devices" by,
	Pantelis Antoniou <panto@antoniou-consulting.com>
3. Series v2 "video: da8xx-fb: runtime timing configuration" by,
	me (Afzal Mohammed <afzal@ti.com>)

To test this series on AM335x based boards,
1. Series "ARM: dts: AM33XX: lcdc support" by,
	me (Afzal Mohammed <afzal@ti.com>),
as well as,
2. Series "HWMOD fixes for AM33xx PWM submodules and device tree nodes" by,
	Philip, Avinash <avinashphilip@ti.com>
would be needed.

A tree with all above dependencies (and below mentioned hack) is available
 @git://gitorious.org/x0148406-public/linux-kernel.git da8xx-fb-dt

In the case of AM335x, in addition to this series, display PLL has to
be locked to required frequency. Unless bootloader configures it
properly, a hack would required in the Kernel. This is also present in
the above mentioned branch of the tree. A solution in the Kernel
is being worked upon and would be posted at the earliest.


Regards
Afzal

Afzal Mohammed (9):
  video: da8xx-fb: enable sync lost intr for v2 ip
  video: da8xx-fb: use devres
  video: da8xx-fb: ensure non-null cfg in pdata
  video: da8xx-fb: reorganize panel detection
  video: da8xx-fb: minimal dt support
  video: da8xx-fb: invoke platform callback safely
  video: da8xx-fb: obtain fb_videomode info from dt
  video: da8xx-fb: ensure pdata only for non-dt
  video: da8xx-fb: setup struct lcd_ctrl_config for dt

Manjunathappa, Prakash (1):
  video: da8xx-fb: fix 24bpp raster configuration

 .../devicetree/bindings/video/fb-da8xx.txt         |   36 +++++
 drivers/video/da8xx-fb.c                           |  145 +++++++++++++-------
 2 files changed, 132 insertions(+), 49 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/fb-da8xx.txt

-- 
1.7.9.5

