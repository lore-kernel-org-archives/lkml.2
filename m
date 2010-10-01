Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab0JAL7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:59:12 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:37276 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932185Ab0JAL6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:58:33 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Viresh Kumar <viresh.kumar@st.com>, shiraz.hashim@st.com,
        vipin.kumar@st.com, deepak.sikri@st.com, armando.visconti@st.com,
        vipulkumar.samar@st.com, rajeev-dlh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com
Subject: [PATCH V2 64/69] SPEAr6xx: Rework Kconfig for single image solution
Date: Fri,  1 Oct 2010 17:26:24 +0530
Message-Id: <f40cb25833510d716dfbb55460654050373d2278.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
---
 arch/arm/mach-spear6xx/Kconfig    |   15 ++++++++-------
 arch/arm/mach-spear6xx/Kconfig600 |   17 -----------------
 2 files changed, 8 insertions(+), 24 deletions(-)
 delete mode 100644 arch/arm/mach-spear6xx/Kconfig600

diff --git a/arch/arm/mach-spear6xx/Kconfig b/arch/arm/mach-spear6xx/Kconfig
index bddba03..ff4ae5b 100644
--- a/arch/arm/mach-spear6xx/Kconfig
+++ b/arch/arm/mach-spear6xx/Kconfig
@@ -4,17 +4,18 @@
 
 if ARCH_SPEAR6XX
 
-choice
-	prompt "SPEAr6XX Family"
-	default MACH_SPEAR600
+menu "SPEAr6xx Implementations"
+config BOARD_SPEAR600_EVB
+	bool "SPEAr600 Evaluation Board"
+	select MACH_SPEAR600
+	help
+	  Supports ST SPEAr600 Evaluation Board
+
+endmenu
 
 config MACH_SPEAR600
 	bool "SPEAr600"
 	help
 	  Supports ST SPEAr600 Machine
-endchoice
-
-# Adding SPEAr6XX machine specific configuration files
-source "arch/arm/mach-spear6xx/Kconfig600"
 
 endif #ARCH_SPEAR6XX
diff --git a/arch/arm/mach-spear6xx/Kconfig600 b/arch/arm/mach-spear6xx/Kconfig600
deleted file mode 100644
index 9e19f65..0000000
--- a/arch/arm/mach-spear6xx/Kconfig600
+++ /dev/null
@@ -1,17 +0,0 @@
-#
-# SPEAr600 machine configuration file
-#
-
-if MACH_SPEAR600
-
-choice
-	prompt "SPEAr600 Boards"
-	default BOARD_SPEAR600_EVB
-
-config	BOARD_SPEAR600_EVB
-	bool "SPEAr600 Evaluation Board"
-	help
-	  Supports ST SPEAr600 Evaluation Board
-endchoice
-
-endif	#MACH_SPEAR600
-- 
1.7.2.2

