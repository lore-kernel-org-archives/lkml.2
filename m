Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab2JSKAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:00:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37959 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab2JSKAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:00:11 -0400
From: Afzal Mohammed <afzal@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <rtc-linux@googlegroups.com>,
        Daniel Mack <zonque@gmail.com>, Afzal Mohammed <afzal@ti.com>
Subject: [PATCH v4 0/5] rtc: omap dt support (for am33xx)
Date: Fri, 19 Oct 2012 15:29:08 +0530
Message-ID: <cover.1350633036.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This series enhances rtc-omap driver so as to be usable on
am33xx SoC by adding DT support (Beagle Bone uses am33xx).
This is a revised version of series that was posted on
27th July 2012 with the subject,
"omap-am33xx rtc dt support".
It seems rtc maintainer in inactive and hence sending it you.

Please help this reach mainline.

Brief:
Enhance rtc-omap driver to make it DT capable. This is
required to support boards that boot only with DT like
Beagle Bone. rtc-omap driver is used in DaVinci platforms
and they are also now going DT way, and these changes make
their DT migration easier. rtc-omap driver is made
intelligent enough to handle kicker mechanism. This also
helps in removing kicker mechanism support done for DaVinci
at platform level.

This series has been made over 3.7-rc1

This has been tested on Beaglebone (am33xx platform) and on
DaVinci da850 evm.

Regards
Afzal

v4:
 Resolve build error during module build
 Improve DT documentation

v3:
 Remove unit address in DT node
 Use readb/writeb instead of __raw_* variants
 Remove unnecessary parens

v2:
 Use device name da830-rtc instead of am1808-rtc, similar change in
 compatible for DT
 Newly added register name made similar to that existing in the driver
 Better commit message description
 Modify Kconfig help, resolve checkpatch warning


Afzal Mohammed (4):
  rtc: omap: kicker mechanism support
  ARM: davinci: remove rtc kicker release
  rtc: omap: dt support
  rtc: omap: depend on am33xx

Vaibhav Hiremath (1):
  rtc: omap: Add runtime pm support

 Documentation/devicetree/bindings/rtc/rtc-omap.txt | 17 +++++
 arch/arm/mach-davinci/devices-da8xx.c              | 13 +---
 drivers/rtc/Kconfig                                | 10 +--
 drivers/rtc/rtc-omap.c                             | 80 +++++++++++++++++++++-
 4 files changed, 101 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rtc/rtc-omap.txt

-- 
1.7.12

