Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab1EGJqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 05:46:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:40190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab1EGJqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 05:46:37 -0400
Date: Sat, 7 May 2011 09:46:05 GMT
From: "tip-bot for Luis R. Rodriguez" <lrodriguez@atheros.com>
Message-ID: <tip-8fab6af2156c0100f953fd61f4e0b2f82c9776dc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joonas.viskari@atheros.com, lrodriguez@atheros.com,
        allen.kao@atheros.com, alan@lxorguk.ukuu.org.uk,
        roman.gezikov@atheros.com, akpm@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joonas.viskari@atheros.com, lrodriguez@atheros.com,
        alan@lxorguk.ukuu.org.uk, allen.kao@atheros.com,
        akpm@linux-foundation.org, roman.gezikov@atheros.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1304719209-26913-1-git-send-email-lrodriguez@atheros.com>
References: <1304719209-26913-1-git-send-email-lrodriguez@atheros.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Fix mrst sparse complaints
Git-Commit-ID: 8fab6af2156c0100f953fd61f4e0b2f82c9776dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 07 May 2011 09:46:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8fab6af2156c0100f953fd61f4e0b2f82c9776dc
Gitweb:     http://git.kernel.org/tip/8fab6af2156c0100f953fd61f4e0b2f82c9776dc
Author:     Luis R. Rodriguez <lrodriguez@atheros.com>
AuthorDate: Fri, 6 May 2011 15:00:09 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 7 May 2011 10:52:30 +0200

x86: Fix mrst sparse complaints

Fix these Sparse complaints:

  CHECK   arch/x86/platform/mrst/mrst.c
  arch/x86/platform/mrst/mrst.c:197:13: warning: symbol 'mrst_time_init' was not declared. Should it be static?
  arch/x86/platform/mrst/mrst.c:219:16: warning: symbol 'mrst_arch_setup' was not declared. Should it be static?

Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Roman Gezikov <roman.gezikov@atheros.com>
Cc: Joonas Viskari <joonas.viskari@atheros.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Allen Kao <allen.kao@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Link: http://lkml.kernel.org/r/1304719209-26913-1-git-send-email-lrodriguez@atheros.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
