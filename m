Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0JOAtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 20:49:05 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37199 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab0JOAtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 20:49:03 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: michael@ellerman.id.au, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        Linas Vepstas <linasvepstas@gmail.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, Frans Pop <elendil@planet.nl>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] pseries: don't override CONFIG_PPC_PSERIES_DEBUG
Date: Thu, 14 Oct 2010 17:48:52 -0700
Message-Id: <1287103733-7121-1-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eeh and pci_dlpar #undef DEBUG, but I think they were added before the
ability to control this from Kconfig. It's really annoying to only get
some of the debug messages from these files. Leave the lpar.c #undef
alone as it produces so much output as to make the kernel unusable.
Update the Kconfig text to indicate this particular quirk :)

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
 arch/powerpc/platforms/pseries/Kconfig     |    6 ++++++
 arch/powerpc/platforms/pseries/eeh.c       |    2 --
 arch/powerpc/platforms/pseries/pci_dlpar.c |    2 --
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index c667f0f..3139814 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -47,6 +47,12 @@ config LPARCFG
 config PPC_PSERIES_DEBUG
 	depends on PPC_PSERIES && PPC_EARLY_DEBUG
 	bool "Enable extra debug logging in platforms/pseries"
+        help
+	  Say Y here if you want the pseries core to produce a bunch of
+	  debug messages to the system log. Select this if you are having a
+	  problem with the pseries core and want to see more of what is
+	  going on. This does not enable debugging in lpar.c, which must
+	  be manually done due to its verbosity.
 	default y
 
 config PPC_SMLPAR
diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/pseries/eeh.c
index 34b7dc1..17a11c8 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -21,8 +21,6 @@
  * Please address comments and feedback to Linas Vepstas <linas@austin.ibm.com>
  */
 
-#undef DEBUG
-
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/list.h>
diff --git a/arch/powerpc/platforms/pseries/pci_dlpar.c b/arch/powerpc/platforms/pseries/pci_dlpar.c
index 4b7a062..5fcc92a 100644
--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -25,8 +25,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#undef DEBUG
-
 #include <linux/pci.h>
 #include <asm/pci-bridge.h>
 #include <asm/ppc-pci.h>
-- 
1.7.1

