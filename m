Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab1CTJdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 05:33:17 -0400
Received: from nm21.bullet.mail.sp2.yahoo.com ([98.139.91.91]:30007 "HELO
	nm21.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751777Ab1CTJdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 05:33:03 -0400
X-Yahoo-Newman-Id: 587805.13776.bm@omp1022.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: tSat7MAVM1mylNzXKyYhs9.5O5dhEcfGvOZcaE9cZWT75gK
 OrAXnqwQFqGKpNCqUrkKu2oFbb4v0lxTflKcljD7hgaaHVZRQfqUU_nOzaQY
 D6EaignmiGvYD3dMB9a_HNscAw1Lx7DWOZjXQzXn0UZyZJG2sX7YAbKa_nq5
 LYPz1BqGEXU_v9MgVhJr803Qdhf8exOGKqk4257FSuJkmsaQ_2Gc896vl9Pq
 eRtnhHpN63s9n.vRgr8l7gnwqHuVnXzNJPCnnItk7Qi_mIW5bfUHmMd4Wb0H
 Ovo8T1jg49wpM4EDRDagDMcDvJ6eGeEw4fDKHv3LYXljVSdsrZsq0H2evom9
 m1QLNxeBj7SCsVU5XjnzimcDF
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Jesper Juhl <jj@chaosbits.net>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC-v4 12/12] iscsi-target: Add Makefile/Kconfig and update TCM top level
Date: Sun, 20 Mar 2011 02:31:37 -0700
Message-Id: <1300613497-2091-13-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300613497-2091-1-git-send-email-nab@linux-iscsi.org>
References: <1300613497-2091-1-git-send-email-nab@linux-iscsi.org>
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
 drivers/target/iscsi/Kconfig  |   17 +++++++++++++++++
 drivers/target/iscsi/Makefile |   20 ++++++++++++++++++++
 4 files changed, 39 insertions(+), 0 deletions(-)
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
index 0000000..cc34243
--- /dev/null
+++ b/drivers/target/iscsi/Kconfig
@@ -0,0 +1,17 @@
+config ISCSI_TARGET
+	tristate "Linux-iSCSI.org iSCSI Target Mode Stack"
+	select CRYPTO
+	select CRYPTO_CRC32C
+	select CRYPTO_CRC32C_INTEL if X86
+	help
+	Say Y here to enable the ConfigFS enabled Linux-iSCSI.org iSCSI
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
1.7.4.1

