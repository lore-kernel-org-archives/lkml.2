Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab1ELHJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:09:06 -0400
Received: from nm12.access.bullet.mail.sp2.yahoo.com ([98.139.44.139]:38593
	"HELO nm12.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757131Ab1ELHI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:08:58 -0400
X-Yahoo-Newman-Id: 946099.61918.bm@omp1019.access.mail.sp2.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: nOdnFQAVM1kCov2OUFfvrECNzNHLG987KaYSQ4mLSfqW859
 OAv64QTPVbiLeHwz19nK1hneP5aCKitSyiSPXRBQlhwhvBTj4HMhPpgAi_kU
 qcgc3oCty5u5HSNNE1Cv2R7eTwjAbW4Tndu87tQjtWQ7YLnKH85OnUje71lW
 ANYiZ1t0fwg2eoe3.Ionw2ilZD1uIngeisuHmPqLefiuZbY1BdU1eqsmeDcB
 oYo0KUr5jcEd0HbU7HQ5.iwJMTydX4W5jJJrV9GgWoY2UUeBFd6m.oxkV8nw
 PyDG2ILNhjocI9bmlv7WUphEY3kOiU_.492euvOIi6gAyjovDgRHwNAKrWKp
 ya5iM_JyHlfDjIp1iqdTvAXJ_PCQdLUt1EuSZxTSNPx4WuqEb7l5xK6xz_Yw
 NHkWhU9TOiDCBG2Tp30d1_q93_YQPjljv.5uv8_4y3Lfr.TgswasLEprWDYM
 jd2hzqw6PvVhWNWdO6hS3YVGPLEJBZshIBZJiXsMYXTFJgzMLJ02DaCPlrA-
 -
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v3 14/14] iscsi-target: Add Makefile/Kconfig and update TCM top level
Date: Thu, 12 May 2011 00:07:21 -0700
Message-Id: <1305184041-32189-15-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1305184041-32189-1-git-send-email-nab@linux-iscsi.org>
References: <1305184041-32189-1-git-send-email-nab@linux-iscsi.org>
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

