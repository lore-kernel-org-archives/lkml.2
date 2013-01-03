Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3ACHaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 02:30:14 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8481 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3ACHaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 02:30:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 02 Jan 2013 23:26:09 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH RESEND 1/2] arm: tegra: Add new DT property to USB node.
Date: Thu, 3 Jan 2013 12:59:38 +0530
Message-ID: <1357198179-10031-2-git-send-email-vbyravarasu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1357198179-10031-1-git-send-email-vbyravarasu@nvidia.com>
References: <1357198179-10031-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Tegra USB host driver is using instance number for resetting
PORT0 twice, adding a new DT property for handling this.

Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
---
 .../bindings/usb/nvidia,tegra20-ehci.txt           |    2 ++
 arch/arm/boot/dts/tegra20.dtsi                     |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt
index e9b005d..6ea765a 100644
--- a/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra20-ehci.txt
@@ -27,3 +27,5 @@ Optional properties:
     registers are accessed through the APB_MISC base address instead of
     the USB controller. Since this is a legacy issue it probably does not
     warrant a compatible string of its own.
+  - nvidia,needs-double-reset : boolean is to be set for some of the Tegra2
+    USB ports, which need reset twice due to hardware issues.
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index fe35c72..7f74339 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -384,6 +384,7 @@
 		phy_type = "utmi";
 		nvidia,has-legacy-mode;
 		status = "disabled";
+		nvidia,needs-double-reset;
 	};
 
 	usb@c5004000 {
-- 
1.7.0.4

