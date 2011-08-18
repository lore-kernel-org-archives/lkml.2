Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1HRVvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:51:05 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:53424 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351Ab1HRVu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:50:59 -0400
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com
Cc: James Nuss <jamesnuss@nanometrics.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] ARM: davinci: da850, omapl138: share the preferred console registration
Date: Thu, 18 Aug 2011 17:50:49 -0400
Message-Id: <3e3d2dfabd7a2cbf9650986a83bd238ec927d1ad.1313702401.git.bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1313702401.git.bengardiner@nanometrics.ca>
References: <cover.1313702401.git.bengardiner@nanometrics.ca>
In-Reply-To: <cover.1313702401.git.bengardiner@nanometrics.ca>
References: <cover.1313702401.git.bengardiner@nanometrics.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the common add_preferred_console("ttyS", 2, "115200") found both of
the da850evm and hawk boards into a shared function in the da850-reference
object introduced in a previous commit.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
Reviewed-by: James Nuss <jamesnuss@nanometrics.ca>
---
 arch/arm/mach-davinci/board-da850-evm.c            |    2 +-
 arch/arm/mach-davinci/board-omapl138-hawk.c        |    2 +-
 arch/arm/mach-davinci/da850-reference.c            |    7 +++++++
 .../mach-davinci/include/mach/da850-reference.h    |    1 +
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index f707bb2..109b016 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1253,7 +1253,7 @@ static int __init da850_evm_console_init(void)
 	if (!machine_is_davinci_da850_evm())
 		return 0;
 
-	return add_preferred_console("ttyS", 2, "115200");
+	return da850_reference_add_preferred_console();
 }
 console_initcall(da850_evm_console_init);
 #endif
diff --git a/arch/arm/mach-davinci/board-omapl138-hawk.c b/arch/arm/mach-davinci/board-omapl138-hawk.c
index cfad483..73d826d 100644
--- a/arch/arm/mach-davinci/board-omapl138-hawk.c
+++ b/arch/arm/mach-davinci/board-omapl138-hawk.c
@@ -328,7 +328,7 @@ static int __init omapl138_hawk_console_init(void)
 	if (!machine_is_omapl138_hawkboard())
 		return 0;
 
-	return add_preferred_console("ttyS", 2, "115200");
+	return da850_reference_add_preferred_console();
 }
 console_initcall(omapl138_hawk_console_init);
 #endif
diff --git a/arch/arm/mach-davinci/da850-reference.c b/arch/arm/mach-davinci/da850-reference.c
index 67b327b..25df6476 100644
--- a/arch/arm/mach-davinci/da850-reference.c
+++ b/arch/arm/mach-davinci/da850-reference.c
@@ -7,9 +7,16 @@
  * or implied.
  */
 
+#include <linux/console.h>
+
 #include <mach/da8xx.h>
 
 void __init da850_reference_map_io(void)
 {
 	da850_init();
 }
+
+int da850_reference_add_preferred_console(void)
+{
+	return add_preferred_console("ttyS", 2, "115200");
+}
diff --git a/arch/arm/mach-davinci/include/mach/da850-reference.h b/arch/arm/mach-davinci/include/mach/da850-reference.h
index 6837a98..ed72c53 100644
--- a/arch/arm/mach-davinci/include/mach/da850-reference.h
+++ b/arch/arm/mach-davinci/include/mach/da850-reference.h
@@ -14,5 +14,6 @@
 #define DA850_REFERENCE_BOOT_PARAMS (DA8XX_DDR_BASE + 0x100)
 
 void __init da850_reference_map_io(void);
+int da850_reference_add_preferred_console(void);
 
 #endif /* __ASM_ARCH_DAVINCI_DA850_REFERENCE_H */
-- 
1.7.4.1

