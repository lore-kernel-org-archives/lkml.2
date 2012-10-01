Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab2JAGrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 02:47:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55096 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2JAGrl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 02:47:41 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] pwm: dt: Fix description of second PWM cell
Date: Mon,  1 Oct 2012 08:47:33 +0200
Message-Id: <1349074053-18385-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:KCB34ybI7k4ISN6uiIP/b0qJxDQIIAKTkVrimGtBtFF
 SBp0zQU5sinrDl2e9Mq4pdymQ5Dkk/o2tKuullm63Kl9Ky2+ic
 1tly6wbHz8xRa+Rxvd1pB0HZmj65K1YWWtqzRQihsEuigFM8Qd
 7QpVlsH/z4Pdcv1bdTs85G9acsFqB3nqjNGSL3Vmpo7RebrNzE
 h5UYacEfsPyYBOU7Aow7595MAyNGqcw5h32wOTnY+ZJwDo5nhR
 LYGvBhVdJ3hokH8eWgDbEj0tsVGFBqDgrudv/mE3LzLAy5vUVo
 mt+CwDdpublTTmphudiw+yCUZXvUJ0o0iM8iePdKvgHbgzTOkY
 HpYH95n2dYJSzOnp61kGYW00Rs79PZ7zcNf2GrCTbLVmHPgW+t
 kgtewBvApL+zFX+ghmVF3V7yDWSxNuvrVGWYRtcTzqY96XicZB
 rdeWf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second cell in the PWM specifier denotes the period in nanoseconds,
not the duty cycle. The latter can be freely configured at runtime and
a PWM with a fixed duty cycle would be rather pointless.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: "Benoît Thébaudeau" <benoit.thebaudeau@advansee.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
---
 Documentation/devicetree/bindings/pwm/imx-pwm.txt            | 2 +-
 Documentation/devicetree/bindings/pwm/mxs-pwm.txt            | 2 +-
 Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/imx-pwm.txt b/Documentation/devicetree/bindings/pwm/imx-pwm.txt
index 9b9b185..8522bfb 100644
--- a/Documentation/devicetree/bindings/pwm/imx-pwm.txt
+++ b/Documentation/devicetree/bindings/pwm/imx-pwm.txt
@@ -4,7 +4,7 @@ Required properties:
 - compatible: should be "fsl,<soc>-pwm"
 - reg: physical base address and length of the controller's registers
 - #pwm-cells: should be 2.  The first cell specifies the per-chip index
-  of the PWM to use and the second cell is the duty cycle in nanoseconds.
+  of the PWM to use and the second cell is the period in nanoseconds.
 - interrupts: The interrupt for the pwm controller
 
 Example:
diff --git a/Documentation/devicetree/bindings/pwm/mxs-pwm.txt b/Documentation/devicetree/bindings/pwm/mxs-pwm.txt
index b16f4a5..d7946be6 100644
--- a/Documentation/devicetree/bindings/pwm/mxs-pwm.txt
+++ b/Documentation/devicetree/bindings/pwm/mxs-pwm.txt
@@ -4,7 +4,7 @@ Required properties:
 - compatible: should be "fsl,imx23-pwm"
 - reg: physical base address and length of the controller's registers
 - #pwm-cells: should be 2.  The first cell specifies the per-chip index
-  of the PWM to use and the second cell is the duty cycle in nanoseconds.
+  of the PWM to use and the second cell is the period in nanoseconds.
 - fsl,pwm-number: the number of PWM devices
 
 Example:
diff --git a/Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt b/Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt
index bbbeedb..01438ec 100644
--- a/Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt
+++ b/Documentation/devicetree/bindings/pwm/nvidia,tegra20-pwm.txt
@@ -7,7 +7,7 @@ Required properties:
 - reg: physical base address and length of the controller's registers
 - #pwm-cells: On Tegra the number of cells used to specify a PWM is 2. The
   first cell specifies the per-chip index of the PWM to use and the second
-  cell is the duty cycle in nanoseconds.
+  cell is the period in nanoseconds.
 
 Example:
 
-- 
1.7.12.2

