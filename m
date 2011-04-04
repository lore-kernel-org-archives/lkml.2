Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1DDPAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:00:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:60103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab1DDPAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:00:33 -0400
Date: Mon, 4 Apr 2011 15:00:08 GMT
From: tip-bot for Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        florian@mickler.org, tj@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        florian@mickler.org, tj@kernel.org, tglx@linutronix.de
In-Reply-To: <1301843624-22364-1-git-send-email-florian@mickler.org>
References: <1301843624-22364-1-git-send-email-florian@mickler.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-64, NUMA: Remove unused variable
Message-ID: <tip-711b8c87a5fe6de78e90411cb67b506babfef74a@git.kernel.org>
Git-Commit-ID: 711b8c87a5fe6de78e90411cb67b506babfef74a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Apr 2011 15:00:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  711b8c87a5fe6de78e90411cb67b506babfef74a
Gitweb:     http://git.kernel.org/tip/711b8c87a5fe6de78e90411cb67b506babfef74a
Author:     Florian Mickler <florian@mickler.org>
AuthorDate: Mon, 4 Apr 2011 01:17:40 +0200
Committer:  Tejun Heo <tj@kernel.org>
CommitDate: Mon, 4 Apr 2011 01:21:00 +0200

x86-64, NUMA: Remove unused variable

In case !CONFIG_ACPI_NUMA and !CONFIG_AMD_NUMA gcc emits a warning
about the unused variable ret.

As that variable is in fact not needed I choose to remove it.

Signed-off-by: Florian Mickler <florian@mickler.org>
LKML-Reference: <1301843624-22364-1-git-send-email-florian@mickler.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/mm/numa_64.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 3951ee6..13f5b06 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -505,17 +505,13 @@ static int __init numa_init(int (*init_func)(void))
 
 void __init initmem_init(void)
 {
-	int ret;
-
 	if (!numa_off) {
 #ifdef CONFIG_ACPI_NUMA
-		ret = numa_init(x86_acpi_numa_init);
-		if (!ret)
+		if (!numa_init(x86_acpi_numa_init))
 			return;
 #endif
 #ifdef CONFIG_AMD_NUMA
-		ret = numa_init(amd_numa_init);
-		if (!ret)
+		if (!numa_init(amd_numa_init))
 			return;
 #endif
 	}
