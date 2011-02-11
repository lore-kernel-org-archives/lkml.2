Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab1BKOhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 09:37:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62766 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab1BKOhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 09:37:50 -0500
From: Subhasish Ghosh <subhasish@mistralsolutions.com>
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Kevin Hilman <khilman@deeprootsystems.com> (supporter:TI DAVINCI
	MACHIN...),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 03/13] da850: pruss board specific additions.
Date: Fri, 11 Feb 2011 20:21:22 +0530
Message-Id: <1297435892-28278-4-git-send-email-subhasish@mistralsolutions.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds board specific initializations and setup routines.

Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
---
 arch/arm/mach-davinci/board-da850-evm.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 11f986b..242d1ed 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1053,6 +1053,26 @@ static __init int da850_evm_init_cpufreq(void)
 static __init int da850_evm_init_cpufreq(void) { return 0; }
 #endif
 
+static struct da8xx_pruss_devices pruss_devices[] = {
+	{.dev_name = NULL,},
+};
+
+static int __init da8xx_evm_setup_pruss(void)
+{
+	u32 ret = 0;
+	u32 count;
+
+	for (count = 0; count < ARRAY_SIZE(pruss_devices); count++) {
+		if (pruss_devices[count].setup != NULL) {
+			ret = pruss_devices[count].setup();
+			if (ret)
+				return ret;
+		}
+	}
+
+	return da8xx_register_pruss(pruss_devices);
+}
+
 static __init void da850_evm_init(void)
 {
 	int ret;
@@ -1127,6 +1147,11 @@ static __init void da850_evm_init(void)
 
 	da8xx_register_mcasp(0, &da850_evm_snd_data);
 
+	ret = da8xx_evm_setup_pruss();
+	if (ret)
+		pr_warning("%s: pruss initialization failed: %d\n",
+				__func__, ret);
+
 	ret = davinci_cfg_reg_list(da850_lcdcntl_pins);
 	if (ret)
 		pr_warning("da850_evm_init: lcdcntl mux setup failed: %d\n",
-- 
1.7.2.3

