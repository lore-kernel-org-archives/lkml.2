Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab0JDU0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:26:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:39748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005Ab0JDU0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:26:03 -0400
Date: Mon, 4 Oct 2010 20:25:48 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100930123357.GC20545@loge.amd.com>
References: <20100930123357.GC20545@loge.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/amd-nb] x86, nmi: Support NMI watchdog on newer AMD CPU families
Message-ID: <tip-420b13b60a3e5c5dcc6ec290e131cf5fbc603d94@git.kernel.org>
Git-Commit-ID: 420b13b60a3e5c5dcc6ec290e131cf5fbc603d94
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:25:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  420b13b60a3e5c5dcc6ec290e131cf5fbc603d94
Gitweb:     http://git.kernel.org/tip/420b13b60a3e5c5dcc6ec290e131cf5fbc603d94
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 30 Sep 2010 14:33:58 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 1 Oct 2010 16:18:32 -0700

x86, nmi: Support NMI watchdog on newer AMD CPU families

CPU families 0x12, 0x14 and 0x15 support this functionality.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20100930123357.GC20545@loge.amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/perfctr-watchdog.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index fb329e9..d9f4ff8 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -700,11 +700,10 @@ static void probe_nmi_watchdog(void)
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
-		if (boot_cpu_data.x86 != 6 && boot_cpu_data.x86 != 15 &&
-		    boot_cpu_data.x86 != 16 && boot_cpu_data.x86 != 17)
-			return;
-		wd_ops = &k7_wd_ops;
-		break;
+		if (boot_cpu_data.x86 == 6 ||
+		    (boot_cpu_data.x86 >= 0xf && boot_cpu_data.x86 <= 0x15))
+			wd_ops = &k7_wd_ops;
+		return;
 	case X86_VENDOR_INTEL:
 		/* Work around where perfctr1 doesn't have a working enable
 		 * bit as described in the following errata:
