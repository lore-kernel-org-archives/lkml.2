Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0LATR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:17:27 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22469 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab0LATRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:17:25 -0500
Date: Wed, 1 Dec 2010 11:16:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, Dowan Kim <dowan@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>
Subject: [PATCH -next] staging: brcm80211 needs lots of delay.h
Message-Id: <20101201111635.3c92ff0f.randy.dunlap@oracle.com>
In-Reply-To: <20101201133354.a7c198b1.sfr@canb.auug.org.au>
References: <20101201133354.a7c198b1.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix lots of errors like:

drivers/staging/brcm80211/phy/wlc_phy_n.c:17613: error: implicit declaration of function 'mdelay'
drivers/staging/brcm80211/util/nicpci.c:246: error: implicit declaration of function 'udelay'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Dowan Kim <dowan@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Cc: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/phy/wlc_phy_cmn.c |    1 +
 drivers/staging/brcm80211/phy/wlc_phy_lcn.c |    1 +
 drivers/staging/brcm80211/phy/wlc_phy_n.c   |    1 +
 drivers/staging/brcm80211/util/aiutils.c    |    1 +
 drivers/staging/brcm80211/util/bcmotp.c     |    1 +
 drivers/staging/brcm80211/util/hndpmu.c     |    1 +
 drivers/staging/brcm80211/util/nicpci.c     |    1 +
 drivers/staging/brcm80211/util/siutils.c    |    1 +
 8 files changed, 8 insertions(+)

--- linux-next-20101201.orig/drivers/staging/brcm80211/phy/wlc_phy_n.c
+++ linux-next-20101201/drivers/staging/brcm80211/phy/wlc_phy_n.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <bcmdefs.h>
 #include <wlc_cfg.h>
+#include <linux/delay.h>
 #include <linux/pci.h>
 #include <osl.h>
 #include <siutils.h>
--- linux-next-20101201.orig/drivers/staging/brcm80211/util/nicpci.c
+++ linux-next-20101201/drivers/staging/brcm80211/util/nicpci.c
@@ -14,6 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <bcmdefs.h>
--- linux-next-20101201.orig/drivers/staging/brcm80211/util/siutils.c
+++ linux-next-20101201/drivers/staging/brcm80211/util/siutils.c
@@ -14,6 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <bcmdefs.h>
--- linux-next-20101201.orig/drivers/staging/brcm80211/util/aiutils.c
+++ linux-next-20101201/drivers/staging/brcm80211/util/aiutils.c
@@ -14,6 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <bcmdefs.h>
--- linux-next-20101201.orig/drivers/staging/brcm80211/util/bcmotp.c
+++ linux-next-20101201/drivers/staging/brcm80211/util/bcmotp.c
@@ -14,6 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <bcmdefs.h>
--- linux-next-20101201.orig/drivers/staging/brcm80211/util/hndpmu.c
+++ linux-next-20101201/drivers/staging/brcm80211/util/hndpmu.c
@@ -13,6 +13,7 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
+#include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/module.h>
--- linux-next-20101201.orig/drivers/staging/brcm80211/phy/wlc_phy_cmn.c
+++ linux-next-20101201/drivers/staging/brcm80211/phy/wlc_phy_cmn.c
@@ -20,6 +20,7 @@
 #include <linux/string.h>
 #include <bcmdefs.h>
 #include <osl.h>
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <bcmendian.h>
--- linux-next-20101201.orig/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
+++ linux-next-20101201/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/bitops.h>
+#include <linux/delay.h>
 #include <wlc_cfg.h>
 #include <qmath.h>
 #include <osl.h>
