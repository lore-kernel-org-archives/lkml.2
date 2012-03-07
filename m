Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2CGFO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:14:28 -0500
Received: from mail-yx0-f202.google.com ([209.85.213.202]:36819 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2CGFO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:14:27 -0500
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@chromium.org>
Subject: [RESEND PATCH 1/3] arm: tegra: dts: Support host/device selection and legacy mode
Date: Tue,  6 Mar 2012 21:04:32 -0800
Message-Id: <1331096674-8324-2-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331096674-8324-1-git-send-email-sjg@chromium.org>
References: <1331096674-8324-1-git-send-email-sjg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some USB ports can support host and device operation. We add the dr_mode
property (as found in Freescale) for this.

One USB port has a 'legacy mode', left over from the days of pre-Tegra
chips. I don't believe this is actually used, except that we must know
to turn this off in the driver.

Signed-off-by: Simon Glass <sjg@chromium.org>
---
 .../devicetree/bindings/usb/tegra-usb.txt          |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/tegra-usb.txt b/Documentation/devicetree/bindings/usb/tegra-usb.txt
index 035d63d..007005d 100644
--- a/Documentation/devicetree/bindings/usb/tegra-usb.txt
+++ b/Documentation/devicetree/bindings/usb/tegra-usb.txt
@@ -11,3 +11,16 @@ Required properties :
  - phy_type : Should be one of "ulpi" or "utmi".
  - nvidia,vbus-gpio : If present, specifies a gpio that needs to be
    activated for the bus to be powered.
+
+Optional properties:
+  - dr_mode : dual role mode. Indicates the working mode for
+   nvidia,tegra20-ehci compatible controllers.  Can be "host", "peripheral",
+   or "otg".  Default to "host" if not defined for backward compatibility.
+      host means this is a host controller
+      peripheral means it is device controller
+      otg means it can operate as either ("on the go")
+  - nvidia,has-legacy-mode : boolean indicates whether this controller can
+    operate in legacy mode (as APX 2500 / 2600). In legacy mode some
+    registers are accessed through the APB_MISC base address instead of
+    the USB controller. Since this is a legacy issue it probably does not
+    warrant a compatible string of its own.
-- 
1.7.7.3

