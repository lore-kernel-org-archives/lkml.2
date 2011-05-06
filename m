Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab1EFWAV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 18:00:21 -0400
Received: from mail.atheros.com ([12.19.149.2]:13962 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab1EFWAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 18:00:19 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <akpm@linux-foundation.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
        <hpa@zytor.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <allen.kao@atheros.com>,
        <roman.gezikov@atheros.com>, <joonas.viskari@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] x86: fix mrst sparse complaints
Date: Fri, 6 May 2011 15:00:09 -0700
Message-ID: <1304719209-26913-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.7.4.15.g7811d
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes these few sparse complaints:

  CHECK   arch/x86/platform/mrst/mrst.c
arch/x86/platform/mrst/mrst.c:197:13: warning: symbol 'mrst_time_init' was not declared. Should it be static?
arch/x86/platform/mrst/mrst.c:219:16: warning: symbol 'mrst_arch_setup' was not declared. Should it be static?
  CC      arch/x86/platform/mrst/mrst.o

Cc: Roman Gezikov <roman.gezikov@atheros.com>
Cc: Joonas Viskari <joonas.viskari@atheros.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Allen Kao <allen.kao@atheros.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 arch/x86/platform/mrst/mrst.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index 275dbc1..7000e74 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -194,7 +194,7 @@ static unsigned long __init mrst_calibrate_tsc(void)
 	return 0;
 }
 
-void __init mrst_time_init(void)
+static void __init mrst_time_init(void)
 {
 	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
 	switch (mrst_timer_options) {
@@ -216,7 +216,7 @@ void __init mrst_time_init(void)
 	apbt_time_init();
 }
 
-void __cpuinit mrst_arch_setup(void)
+static void __cpuinit mrst_arch_setup(void)
 {
 	if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x27)
 		__mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
-- 
1.7.4.15.g7811d

