Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab1ANON5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:13:57 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:40622 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757631Ab1ANONs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:13:48 -0500
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 26/27] scsi: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:49 -0800
Message-Id: <5c12c140eca84cd7c1a389cb98e185115ce3b17a.1295006565.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <cover.1295006561.git.mfm@muteddisk.com>
References: <cover.1295006561.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
---
 drivers/scsi/aacraid/Makefile |    2 +-
 drivers/scsi/aic94xx/Makefile |    4 +---
 drivers/scsi/libsas/Makefile  |    6 ++----
 drivers/scsi/lpfc/Makefile    |    6 ++----
 drivers/scsi/mvsas/Makefile   |    4 +---
 drivers/scsi/pcmcia/Makefile  |    2 +-
 6 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/aacraid/Makefile b/drivers/scsi/aacraid/Makefile
index f1cca4e..92df4d6 100644
--- a/drivers/scsi/aacraid/Makefile
+++ b/drivers/scsi/aacraid/Makefile
@@ -5,4 +5,4 @@ obj-$(CONFIG_SCSI_AACRAID) := aacraid.o
 aacraid-objs	:= linit.o aachba.o commctrl.o comminit.o commsup.o \
 		   dpcsup.o rx.o sa.o rkt.o nark.o
 
-EXTRA_CFLAGS	:= -Idrivers/scsi
+ccflags-y	:= -Idrivers/scsi
diff --git a/drivers/scsi/aic94xx/Makefile b/drivers/scsi/aic94xx/Makefile
index e78ce0f..c0a15c7 100644
--- a/drivers/scsi/aic94xx/Makefile
+++ b/drivers/scsi/aic94xx/Makefile
@@ -22,9 +22,7 @@
 # along with the aic94xx driver; if not, write to the Free Software
 # Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 
-ifeq ($(CONFIG_AIC94XX_DEBUG),y)
-	EXTRA_CFLAGS += -DASD_DEBUG -DASD_ENTER_EXIT
-endif
+ccflags-$(CONFIG_AIC94XX_DEBUG) := -DASD_DEBUG -DASD_ENTER_EXIT
 
 obj-$(CONFIG_SCSI_AIC94XX) += aic94xx.o
 aic94xx-y += aic94xx_init.o \
diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
index 1ad1323..c62aa7b 100644
--- a/drivers/scsi/libsas/Makefile
+++ b/drivers/scsi/libsas/Makefile
@@ -21,9 +21,7 @@
 # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 # USA
 
-ifeq ($(CONFIG_SCSI_SAS_LIBSAS_DEBUG),y)
-	EXTRA_CFLAGS += -DSAS_DEBUG
-endif
+ccflags-$(CONFIG_SCSI_SAS_LIBSAS_DEBUG) := -DSAS_DEBUG
 
 obj-$(CONFIG_SCSI_SAS_LIBSAS) += libsas.o
 libsas-y +=  sas_init.o     \
@@ -36,4 +34,4 @@ libsas-y +=  sas_init.o     \
 		sas_scsi_host.o \
 		sas_task.o
 libsas-$(CONFIG_SCSI_SAS_ATA) +=	sas_ata.o
-libsas-$(CONFIG_SCSI_SAS_HOST_SMP) +=	sas_host_smp.o
\ No newline at end of file
+libsas-$(CONFIG_SCSI_SAS_HOST_SMP) +=	sas_host_smp.o
diff --git a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
index ad05d6e..14de249 100644
--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -19,10 +19,8 @@
 # *******************************************************************/
 ######################################################################
 
-ifneq ($(GCOV),)
-  EXTRA_CFLAGS += -fprofile-arcs -ftest-coverage
-  EXTRA_CFLAGS += -O0
-endif
+ccflags-$(GCOV) := -fprofile-arcs -ftest-coverage
+ccflags-$(GCOV) += -O0
 
 obj-$(CONFIG_SCSI_LPFC) := lpfc.o
 
diff --git a/drivers/scsi/mvsas/Makefile b/drivers/scsi/mvsas/Makefile
index 52ac426..ffbf759 100644
--- a/drivers/scsi/mvsas/Makefile
+++ b/drivers/scsi/mvsas/Makefile
@@ -21,9 +21,7 @@
 # Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 # USA
 
-ifeq ($(CONFIG_SCSI_MVSAS_DEBUG),y)
-	EXTRA_CFLAGS += -DMV_DEBUG
-endif
+ccflags-$(CONFIG_SCSI_MVSAS_DEBUG) := -DMV_DEBUG
 
 obj-$(CONFIG_SCSI_MVSAS) += mvsas.o
 mvsas-y +=  mv_init.o  \
diff --git a/drivers/scsi/pcmcia/Makefile b/drivers/scsi/pcmcia/Makefile
index eca3790..683bf14 100644
--- a/drivers/scsi/pcmcia/Makefile
+++ b/drivers/scsi/pcmcia/Makefile
@@ -1,5 +1,5 @@
 
-EXTRA_CFLAGS		+= -Idrivers/scsi
+ccflags-y		:= -Idrivers/scsi
 
 # 16-bit client drivers
 obj-$(CONFIG_PCMCIA_QLOGIC)	+= qlogic_cs.o
-- 
1.7.3.4

