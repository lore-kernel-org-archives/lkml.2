Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab1EQGlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 02:41:44 -0400
Received: from nm13-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.160]:43804
	"HELO nm13-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752687Ab1EQGlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 02:41:25 -0400
X-Yahoo-Newman-Id: 228698.8110.bm@omp1013.access.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: DnaLLL0VM1kFBldE6M_HncR4WdMnzFY7DbHd0EcF.Vn51UX
 mr28YgrEv8dLoNM3W8YexA0fTKTvXrHGpexVRfUaZomAIGXwIh8QQmCKGX1.
 H9nuXXXUc4OOuCupReWSn6eVqXUw2cUvC8tNLBNoEOTTedLhChxd7P.oAPUm
 q8dk2xz31L3GP0VtJ60PPaak.Ec6skohSIJSZ7f1Gu..A07Og7_gFzXr6ky7
 UGDSG6aAigiORFTR05k7wLO7OIz1qPUqg_P0ARpzc3XJRy_hAECrulcHzEXu
 _KkLrwaIYqoMAIoCi64eB7rw23xZh8C4bVGB79QP.7A9vK3DF8f09hNMC7Io
 wOfTm9SvzIH1a2qa3NUoMJ_AEWwUDZhKWauoLISdAgmvteusDzflRfirIsyl
 XRqrThE4tptWjN9AGUOhBIk2y
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v4 14/14] iscsi-target: Add Makefile/Kconfig and update TCM top level
Date: Mon, 16 May 2011 23:39:34 -0700
Message-Id: <1305614374-17953-15-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1305614374-17953-1-git-send-email-nab@linux-iscsi.org>
References: <1305614374-17953-1-git-send-email-nab@linux-iscsi.org>
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
index 9ef2dbb..e0619cd 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -30,5 +30,6 @@ config TCM_PSCSI
 	passthrough access to Linux/SCSI device
 
 source "drivers/target/loopback/Kconfig"
+source "drivers/target/iscsi/Kconfig"
 
 endif
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 1178bbf..2fbc20e 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -24,3 +24,4 @@ obj-$(CONFIG_TCM_PSCSI)		+= target_core_pscsi.o
 
 # Fabric modules
 obj-$(CONFIG_LOOPBACK_TARGET)	+= loopback/
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

