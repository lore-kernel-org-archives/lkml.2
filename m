Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2L1T6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:58:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54881 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754213Ab2L1TQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:53 -0500
Message-Id: <20121228190332.753245391@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:03:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <linux@roeck-us.net>, Fenghua Yu <fenghua.yu@intel.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 013/173] hwmon: (coretemp) Add support for Atom D2000 and N2000 series CPU
 models
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 5592906f8b01282ea3c2acaf641fd067ad4bb3dc upstream.

Document the Atom series D2000 and N2000 (Cedar Trail) as being supported.
List and set TjMax for those series.

Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "R, Durgadoss" <durgadoss.r@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/hwmon/coretemp |    5 ++++-
 drivers/hwmon/coretemp.c     |    3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/hwmon/coretemp b/Documentation/hwmon/coretemp
index f6aed440..71d83d2 100644
--- a/Documentation/hwmon/coretemp
+++ b/Documentation/hwmon/coretemp
@@ -7,7 +7,8 @@ Supported chips:
     CPUID: family 0x6, models 0xe (Pentium M DC), 0xf (Core 2 DC 65nm),
                               0x16 (Core 2 SC 65nm), 0x17 (Penryn 45nm),
                               0x1a (Nehalem), 0x1c (Atom), 0x1e (Lynnfield),
-                              0x26 (Tunnel Creek Atom), 0x27 (Medfield Atom)
+                              0x26 (Tunnel Creek Atom), 0x27 (Medfield Atom),
+                              0x36 (Cedar Trail Atom)
     Datasheet: Intel 64 and IA-32 Architectures Software Developer's Manual
                Volume 3A: System Programming Guide
                http://softwarecommunity.intel.com/Wiki/Mobility/720.htm
@@ -68,6 +69,8 @@ Process		Processor					TjMax(C)
 
 32nm		Atom Processors
 		Z2460						90
+		D2700/2550/2500					100
+		N2850/2800/2650/2600				100
 
 45nm		Xeon Processors 5400 Quad-Core
 		X5492, X5482, X5472, X5470, X5460, X5450	85
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 495add5..42c2f43 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -224,6 +224,9 @@ static int __cpuinit adjust_tjmax(struct cpuinfo_x86 *c, u32 id,
 			tjmax = 90000;
 
 		pci_dev_put(host_bridge);
+	} else if (c->x86_model == 0x36) {
+		usemsr_ee = 0;
+		tjmax = 100000;
 	}
 
 	if (c->x86_model > 0xe && usemsr_ee) {


