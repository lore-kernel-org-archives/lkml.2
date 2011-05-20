Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935141Ab1ETDkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:40:16 -0400
Received: from nm1.access.bullet.mail.mud.yahoo.com ([66.94.237.202]:44931
	"HELO nm1.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934450Ab1ETDkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:40:05 -0400
X-Yahoo-Newman-Id: 792867.93960.bm@omp1014.access.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: XGuSDIwVM1l0TIPvHsuSStIf3kBOS9u.JaLoxYTkQOGhMgH
 xO_9wRmR45tHjvr05QkZ2XNrhua2SlPca4kEv1JnkBbwAhjQVAbK9Qa9CQP6
 fGbE.OjYiJhOS_K9UTZ6Q.U_FxKoayyHQyBQCSo.LriJ8jVHUwc0LPOTl4kS
 tv7EJcZZe.3W2ObFTGCr.hiJJ_HrM_jlCeknPxzAE90DGPqTlda__g1ALtnV
 O5PjRsxixpuY1lM9mhR2GjCMFROUdMiC35Y7JfhWckIoaUE4YlH6iCn74z_1
 1emTuwEjTbh3NeTr9JA2X00wXLpKimOHqr4PlnIWr9790fd.1m3vpV_gTxe1
 cuRoihhkJQbqL.X6BhB.RNksTvWEwd2xurY5VBDehSEScmBgQfiARI2qcu9G
 vj_oVXj11rl5eT2weWf5xD60-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v5 13/13] iscsi-target: Add Makefile/Kconfig and update TCM top level
Date: Thu, 19 May 2011 20:37:58 -0700
Message-Id: <1305862678-30150-14-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1305862678-30150-1-git-send-email-nab@linux-iscsi.org>
References: <1305862678-30150-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Add Makefile/Kconfig and update drivers/target/[Makefile,Kconfig]
to include the fabric module.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Kconfig        |    1 +
 drivers/target/Makefile       |    1 +
 drivers/target/iscsi/Kconfig  |   18 ++++++++++++++++++
 drivers/target/iscsi/Makefile |   20 ++++++++++++++++++++
 4 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/iscsi/Kconfig
 create mode 100644 drivers/target/iscsi/Makefile

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 5cb0f0e..b28794b 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -31,5 +31,6 @@ config TCM_PSCSI
 
 source "drivers/target/loopback/Kconfig"
 source "drivers/target/tcm_fc/Kconfig"
+source "drivers/target/iscsi/Kconfig"
 
 endif
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 21df808..dfad4c1 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -26,3 +26,4 @@ obj-$(CONFIG_TCM_PSCSI)		+= target_core_pscsi.o
 obj-$(CONFIG_LOOPBACK_TARGET)	+= loopback/
 
 obj-$(CONFIG_TCM_FC)		+= tcm_fc/
+obj-$(CONFIG_ISCSI_TARGET)	+= iscsi/
diff --git a/drivers/target/iscsi/Kconfig b/drivers/target/iscsi/Kconfig
new file mode 100644
index 0000000..abdb8f9
--- /dev/null
+++ b/drivers/target/iscsi/Kconfig
@@ -0,0 +1,18 @@
+config ISCSI_TARGET
+	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
+	depends on m
+	select CRYPTO
+	select CRYPTO_CRC32C
+	select CRYPTO_CRC32C_INTEL if X86
+	help
+	Say M here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
+	Target Mode Stack.
+
+if ISCSI_TARGET
+
+config ISCSI_TARGET_DEBUG
+	bool "LIO-Target iscsi_debug.h ring buffer messages"
+	help
+	Say Y here to enable the legacy DEBUG_ISCSI macros in iscsi_debug.h
+
+endif
diff --git a/drivers/target/iscsi/Makefile b/drivers/target/iscsi/Makefile
new file mode 100644
index 0000000..5b9a2cf
--- /dev/null
+++ b/drivers/target/iscsi/Makefile
@@ -0,0 +1,20 @@
+iscsi_target_mod-y +=		iscsi_target_parameters.o \
+				iscsi_target_seq_pdu_list.o \
+				iscsi_target_tq.o \
+				iscsi_target_auth.o \
+				iscsi_target_datain_values.o \
+				iscsi_target_device.o \
+				iscsi_target_erl0.o \
+				iscsi_target_erl1.o \
+				iscsi_target_erl2.o \
+				iscsi_target_login.o \
+				iscsi_target_nego.o \
+				iscsi_target_nodeattrib.o \
+				iscsi_target_tmr.o \
+				iscsi_target_tpg.o \
+				iscsi_target_util.o \
+				iscsi_target.o \
+				iscsi_target_configfs.o \
+				iscsi_target_stat.o
+
+obj-$(CONFIG_ISCSI_TARGET)	+= iscsi_target_mod.o
-- 
1.7.5.1

