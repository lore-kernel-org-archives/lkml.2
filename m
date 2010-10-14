Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab0JNRsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 13:48:42 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33390 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab0JNRsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 13:48:41 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linas Vepstas <linasvepstas@gmail.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Neuling <mikey@neuling.org>, Frans Pop <elendil@planet.nl>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] ppc: don't override CONFIG_PPC_PSERIES_DEBUG
Date: Thu, 14 Oct 2010 10:48:14 -0700
Message-Id: <1287078495-11722-1-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These files undef DEBUG, but I think they were added before the ability
to control this from Kconfig. It's really annoying to only get some of
the debug messages!

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

---
Because the lpar and pci_dlpar code is pretty low-level & verbose,
perhaps it makes sense to add another Kconfig variable for really
low-level stuff? But it's annoying to have DEBUG *somewhat* effective,
especially in the EEH area when doing PCI stuff.
---
 arch/powerpc/platforms/pseries/eeh.c       |    2 --
 arch/powerpc/platforms/pseries/lpar.c      |    3 ---
 arch/powerpc/platforms/pseries/pci_dlpar.c |    2 --
 3 files changed, 0 insertions(+), 7 deletions(-)

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
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index cf79b46..4b31a66 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -19,9 +19,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
-/* Enables debugging of low-level hash table routines - careful! */
-#undef DEBUG
-
 #include <linux/kernel.h>
 #include <linux/dma-mapping.h>
 #include <linux/console.h>
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

