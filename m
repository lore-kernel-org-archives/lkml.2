Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab1IMVWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 17:22:47 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10434 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801Ab1IMVWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 17:22:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 13 Sep 2011 14:22:39 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 2/2 v3] power: bq20z75: Add Device Tree Binding
Date: Tue, 13 Sep 2011 14:21:39 -0700
Message-Id: <1315948899-21536-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the binding for the TI bq20z75 fuel gadge and the
bq20z75 driver.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
	v2: Fixed typo in binding description
	v3: Changed unique properties to be use "ti,"
	    Changed to use single gpio entry for gpio info

 .../bindings/power_supply/ti_bq20z75.txt           |   23 ++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt

diff --git a/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt b/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt
new file mode 100644
index 0000000..7571294
--- /dev/null
+++ b/Documentation/devicetree/bindings/power_supply/ti_bq20z75.txt
@@ -0,0 +1,23 @@
+TI bq20z75
+~~~~~~~~~~
+
+Required properties :
+ - compatible : "ti,bq20z75"
+
+Optional properties :
+ - ti,i2c-retry-count : The number of times to retry i2c transactions on i2c
+   IO failure.
+ - ti,poll-retry-count : The number of times to try looking for new status
+   after an external change notification.
+ - ti,battery-detect-gpios : The gpio which signals battery detection and
+   a flag specifying its polarity.
+
+Example:
+
+	bq20z75@b {
+		compatible = "ti,bq20z75";
+		reg = < 0xb >;
+		ti,i2c-retry-count = <2>;
+		ti,poll-retry-count = <10>;
+		ti,battery-detect-gpios = <&gpio-controller 122 1>;
+	}
-- 
1.7.6

