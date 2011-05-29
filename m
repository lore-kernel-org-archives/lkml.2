Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab1E2TZv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 15:25:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:58936 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755214Ab1E2TZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 15:25:49 -0400
Date: Sun, 29 May 2011 19:25:29 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Message-ID: <tip-c4d017f21328c269deba3c7acde873204fe595b5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        trivial@kernel.org, joe@perches.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, trivial@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <10e35243fda0b8739c89ac32a7bdf348ec4752e1.1306603968.git.joe@perches.com>
References: <10e35243fda0b8739c89ac32a7bdf348ec4752e1.1306603968.git.joe@perches.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Convert vmalloc()+memset() to vzalloc()
Git-Commit-ID: c4d017f21328c269deba3c7acde873204fe595b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 29 May 2011 19:25:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4d017f21328c269deba3c7acde873204fe595b5
Gitweb:     http://git.kernel.org/tip/c4d017f21328c269deba3c7acde873204fe595b5
Author:     Joe Perches <joe@perches.com>
AuthorDate: Sat, 28 May 2011 10:36:22 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 19:53:57 +0200

x86: Convert vmalloc()+memset() to vzalloc()

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>
Link: http://lkml.kernel.org/r/10e35243fda0b8739c89ac32a7bdf348ec4752e1.1306603968.git.joe@perches.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pageattr-test.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pageattr-test.c b/arch/x86/mm/pageattr-test.c
index e1d1069..b008656 100644
--- a/arch/x86/mm/pageattr-test.c
+++ b/arch/x86/mm/pageattr-test.c
@@ -123,12 +123,11 @@ static int pageattr_test(void)
 	if (print)
 		printk(KERN_INFO "CPA self-test:\n");
 
-	bm = vmalloc((max_pfn_mapped + 7) / 8);
+	bm = vzalloc((max_pfn_mapped + 7) / 8);
 	if (!bm) {
 		printk(KERN_ERR "CPA Cannot vmalloc bitmap\n");
 		return -ENOMEM;
 	}
-	memset(bm, 0, (max_pfn_mapped + 7) / 8);
 
 	failed += print_split(&sa);
 	srandom32(100);
