Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab2IUT6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:58:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50815 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab2IUT6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:58:36 -0400
Date: Fri, 21 Sep 2012 12:58:25 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-8bd753be7a96443dd5111cb07ed5907a3787c978@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1348256595-29119-3-git-send-email-hpa@linux.intel.com>
References: <1348256595-29119-3-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/smap] x86-32, mm:
  The WP test should be done on a kernel page
Git-Commit-ID: 8bd753be7a96443dd5111cb07ed5907a3787c978
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 21 Sep 2012 12:58:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bd753be7a96443dd5111cb07ed5907a3787c978
Gitweb:     http://git.kernel.org/tip/8bd753be7a96443dd5111cb07ed5907a3787c978
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 21 Sep 2012 12:43:06 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 21 Sep 2012 12:45:25 -0700

x86-32, mm: The WP test should be done on a kernel page

PAGE_READONLY includes user permission, but this is a page used
exclusively by the kernel; use PAGE_KERNEL_RO instead.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/1348256595-29119-3-git-send-email-hpa@linux.intel.com
---
 arch/x86/mm/init_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 575d86f..e537b35 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -712,7 +712,7 @@ static void __init test_wp_bit(void)
   "Checking if this processor honours the WP bit even in supervisor mode...");
 
 	/* Any page-aligned address will do, the test is non-destructive */
-	__set_fixmap(FIX_WP_TEST, __pa(&swapper_pg_dir), PAGE_READONLY);
+	__set_fixmap(FIX_WP_TEST, __pa(&swapper_pg_dir), PAGE_KERNEL_RO);
 	boot_cpu_data.wp_works_ok = do_test_wp_bit();
 	clear_fixmap(FIX_WP_TEST);
 
