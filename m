Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0JAL7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:59:06 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:60909 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932201Ab0JAL6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:58:33 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Shiraz Hashim <shiraz.hashim@st.com>, vipin.kumar@st.com,
        deepak.sikri@st.com, armando.visconti@st.com, vipulkumar.samar@st.com,
        rajeev-dlh.kumar@st.com, pratyush.anand@st.com, bhupesh.sharma@st.com,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2 68/69] ST SPEAr: Adding information in Documentation/ and MAINTAINERS
Date: Fri,  1 Oct 2010 17:26:28 +0530
Message-Id: <ffb4a467d09710964cb451eb1ccefc597985fbef.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shiraz Hashim <shiraz.hashim@st.com>

Signed-off-by: Shiraz Hashim <shiraz.hashim@st.com>
Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 Documentation/arm/SPEAr/overview.txt |   34 +++++++++++++++++++++++-----------
 MAINTAINERS                          |    6 ++++++
 2 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/Documentation/arm/SPEAr/overview.txt b/Documentation/arm/SPEAr/overview.txt
index 253a35c..4e510061 100644
--- a/Documentation/arm/SPEAr/overview.txt
+++ b/Documentation/arm/SPEAr/overview.txt
@@ -9,8 +9,9 @@ Introduction
 
   The ST Microelectronics SPEAr range of ARM9/CortexA9 System-on-Chip CPUs are
   supported by the 'spear' platform of ARM Linux. Currently SPEAr300,
-  SPEAr310, SPEAr320 and SPEAr600 SOCs are supported. Support for the SPEAr13XX
-  series is in progress.
+  SPEAr310, SPEAr320, SPEAr600, SPEAr1300 and SPEAr1310 SOCs are supported.
+  SPEAr3XX and SPEAr6XX are based on ARM9 whereas SPEAr13XX is based on latest
+  ARM Cortex A9 CPUs.
 
   Hierarchy in SPEAr is as follows:
 
@@ -27,16 +28,25 @@ Introduction
 			- SPEAr600_EVB (Evaluation Board)
 	- SPEAr13XX (13XX SOC series, based on ARM CORTEXA9)
 		- SPEAr1300 (SOC)
+			- SPEAr1300_EVB (Evaluation Board)
+		- SPEAr1310 (SOC)
+			- SPEAr1310_EVB (Evaluation Board)
 
   Configuration
   -------------
 
-  A generic configuration is provided for each machine, and can be used as the
+  A generic configuration is provided for each machine family, and can be used as the
   default by
-	make spear600_defconfig
-	make spear300_defconfig
-	make spear310_defconfig
-	make spear320_defconfig
+	#make ARCH=arm spear13xx_defconfig
+	#make ARCH=arm spear3xx_defconfig
+	#make ARCH=arm spear6xx_defconfig
+
+  Compilation
+  -----------
+
+  After applying default configuration, Linux kernel for SPEAr architecture
+  can be compiled as
+	#make ARCH=arm CROSS_COMPILE=arm-linux- uImage
 
   Layout
   ------
@@ -48,13 +58,15 @@ Introduction
   Each machine series have a directory with name arch/arm/mach-spear followed by
   series name. Like mach-spear3xx, mach-spear6xx and mach-spear13xx.
 
-  Common file for machines of spear3xx family is mach-spear3xx/spear3xx.c and for
-  spear6xx is mach-spear6xx/spear6xx.c. mach-spear* also contain soc/machine
+  Common file for machines of spear3xx family is mach-spear3xx/spear3xx.c, for
+  spear6xx is mach-spear6xx/spear6xx.c and similarly for spear13xx is
+  mach-spear13xx/spear13xx.c. mach-spear* also contain soc/machine
   specific files, like spear300.c, spear310.c, spear320.c and spear600.c.
-  mach-spear* also contains board specific files for each machine type.
+  Board specific files for each machine type is also contained in mach-spear*
+  folder.
 
 
   Document Author
   ---------------
 
-  Viresh Kumar, (c) 2010 ST Microelectronics
+  Viresh Kumar, Shiraz Hashim (c) 2010 ST Microelectronics
diff --git a/MAINTAINERS b/MAINTAINERS
index 668682d..97520d9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5462,6 +5462,12 @@ W:	http://www.st.com/spear
 S:	Maintained
 F:	arch/arm/plat-spear/
 
+SPEAR13XX MACHINE SUPPORT
+M:	Shiraz Hashim <shiraz.hashim@st.com>
+W:	http://www.st.com/spear
+S:	Maintained
+F:	arch/arm/mach-spear13xx/
+
 SPEAR3XX MACHINE SUPPORT
 M:	Viresh Kumar <viresh.kumar@st.com>
 W:	http://www.st.com/spear
-- 
1.7.2.2

