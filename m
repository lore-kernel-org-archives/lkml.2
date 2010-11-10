Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab0KJAtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:49:40 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17852 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0KJAtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:49:39 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6162"; a="61364523"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH v2] msm: smd: Reduce driver log chatter
Date: Tue,  9 Nov 2010 16:49:28 -0800
Message-Id: <1289350168-20034-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1289349036-16941-1-git-send-email-davidb@codeaurora.org>
References: <1289349036-16941-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSM smd driver logs numerous messages during startup that are
useful for debug purposes.  Change these to pr_debug() to match their
purpose.

Cc: Brian Swetland <swetland@google.com>
Cc: Arve Hjønnevåg <arve@android.com>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/smd.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-msm/smd.c b/arch/arm/mach-msm/smd.c
index f07dc7c..37b35fb 100644
--- a/arch/arm/mach-msm/smd.c
+++ b/arch/arm/mach-msm/smd.c
@@ -14,6 +14,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/fs.h>
@@ -89,7 +91,7 @@ static void smd_diag(void)
 	x = smem_find(ID_DIAG_ERR_MSG, SZ_DIAG_ERR_MSG);
 	if (x != 0) {
 		x[SZ_DIAG_ERR_MSG - 1] = 0;
-		pr_info("smem: DIAG '%s'\n", x);
+		pr_debug("smem: DIAG '%s'\n", x);
 	}
 }
 
@@ -312,7 +314,7 @@ static void smd_state_change(struct smd_channel *ch,
 {
 	ch->last_state = next;
 
-	pr_info("SMD: ch %d %d -> %d\n", ch->n, last, next);
+	pr_debug("SMD: ch %d %d -> %d\n", ch->n, last, next);
 
 	switch (next) {
 	case SMD_SS_OPENING:
@@ -601,7 +603,7 @@ static int smd_alloc_channel(const char *name, uint32_t cid, uint32_t type)
 	ch->pdev.name = ch->name;
 	ch->pdev.id = -1;
 
-	pr_info("smd_alloc_channel() cid=%02d size=%05d '%s'\n",
+	pr_debug("smd_alloc_channel() cid=%02d size=%05d '%s'\n",
 		ch->n, ch->fifo_size, ch->name);
 
 	mutex_lock(&smd_creation_mutex);
@@ -725,7 +727,7 @@ int smd_close(smd_channel_t *ch)
 {
 	unsigned long flags;
 
-	pr_info("smd_close(%p)\n", ch);
+	pr_debug("smd_close(%p)\n", ch);
 
 	if (ch == 0)
 		return -1;
@@ -939,7 +941,7 @@ int smsm_set_sleep_duration(uint32_t delay)
 int smd_core_init(void)
 {
 	int r;
-	pr_info("smd_core_init()\n");
+	pr_debug("smd_core_init()\n");
 
 	/* wait for essential items to be initialized */
 	for (;;) {
@@ -992,14 +994,14 @@ int smd_core_init(void)
 	smsm_change_state(SMSM_STATE_APPS_DEM, ~0, 0);
 #endif
 
-	pr_info("smd_core_init() done\n");
+	pr_debug("smd_core_init() done\n");
 
 	return 0;
 }
 
 static int __devinit msm_smd_probe(struct platform_device *pdev)
 {
-	pr_info("smd_init()\n");
+	pr_debug("smd_init()\n");
 
 	/*
 	 * If we haven't waited for the ARM9 to boot up till now,
-- 
1.7.3.2

