Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab2AHNd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 08:33:28 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40459 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643Ab2AHNd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 08:33:26 -0500
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: linux-kernel@vger.kernel.org
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [RFC PATCH v2 3/9] x86: avoid using on_each_cpu hard coded ret value
Date: Sun,  8 Jan 2012 15:32:23 +0200
Message-Id: <1326029549-2794-4-git-send-email-gilad@benyossef.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1326029549-2794-1-git-send-email-gilad@benyossef.com>
References: <1326029549-2794-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on_each_cpu always returns a hard coded return code of zero.

Removing all tests based on this return value saves run time
cycles for compares and code bloat for branches.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Michal Nazarewicz <mina86@mina86.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org
---
 arch/x86/lib/cache-smp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/cache-smp.c b/arch/x86/lib/cache-smp.c
index a3c6688..760f7e1 100644
--- a/arch/x86/lib/cache-smp.c
+++ b/arch/x86/lib/cache-smp.c
@@ -14,6 +14,7 @@ EXPORT_SYMBOL(wbinvd_on_cpu);
 
 int wbinvd_on_all_cpus(void)
 {
-	return on_each_cpu(__wbinvd, NULL, 1);
+	on_each_cpu(__wbinvd, NULL, 1);
+	return 0;
 }
 EXPORT_SYMBOL(wbinvd_on_all_cpus);
-- 
1.7.0.4

