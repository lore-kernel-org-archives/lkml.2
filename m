Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271Ab0J0QFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:05:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:42724 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761195Ab0J0QFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:05:34 -0400
Date: Wed, 27 Oct 2010 16:04:17 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, brgerst@gmail.com, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, torvalds@linux-foundation.org, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1288158182-1753-1-git-send-email-brgerst@gmail.com>
References: <1288158182-1753-1-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] percpu: Remove the multi-page alignment facility
Message-ID: <tip-47f19a0814e80e1d4e5c17d61b70fca85ea09162@git.kernel.org>
Git-Commit-ID: 47f19a0814e80e1d4e5c17d61b70fca85ea09162
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Oct 2010 16:04:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47f19a0814e80e1d4e5c17d61b70fca85ea09162
Gitweb:     http://git.kernel.org/tip/47f19a0814e80e1d4e5c17d61b70fca85ea09162
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 Oct 2010 17:41:17 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 Oct 2010 17:53:25 +0200

percpu: Remove the multi-page alignment facility

[DECLARE|DEFINE]_PER_CPU_MULTIPAGE_ALIGNED never really worked because
the head percpu section was only page aligned. Now that the last user
is gone (32-bit IRQ stacks), remove the generic percpu facility.

Cc: Brian Gerst <brgerst@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1288158182-1753-1-git-send-email-brgerst@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/percpu-defs.h |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 018db9a..27ef6b1 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -148,18 +148,6 @@
 	DEFINE_PER_CPU_SECTION(type, name, "..readmostly")
 
 /*
- * Declaration/definition used for large per-CPU variables that must be
- * aligned to something larger than the pagesize.
- */
-#define DECLARE_PER_CPU_MULTIPAGE_ALIGNED(type, name, size)		\
-	DECLARE_PER_CPU_SECTION(type, name, "..page_aligned")		\
-	__aligned(size)
-
-#define DEFINE_PER_CPU_MULTIPAGE_ALIGNED(type, name, size)		\
-	DEFINE_PER_CPU_SECTION(type, name, "..page_aligned")		\
-	__aligned(size)
-
-/*
  * Intermodule exports for per-CPU variables.  sparse forgets about
  * address space across EXPORT_SYMBOL(), change EXPORT_SYMBOL() to
  * noop if __CHECKER__.
