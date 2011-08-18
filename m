Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1HRUML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 16:12:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:46804 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab1HRUMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 16:12:09 -0400
Date: Thu, 18 Aug 2011 20:11:48 GMT
From: tip-bot for Josh Boyer <jwboyer@redhat.com>
Message-ID: <tip-195bcbf5078d74c8e00d68f04eb8695196fb31e8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, jwboyer@redhat.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jwboyer@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110818113720.GL2227@zod.bos.redhat.com>
References: <20110818113720.GL2227@zod.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix build against newer glibc
Git-Commit-ID: 195bcbf5078d74c8e00d68f04eb8695196fb31e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Thu, 18 Aug 2011 20:11:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  195bcbf5078d74c8e00d68f04eb8695196fb31e8
Gitweb:     http://git.kernel.org/tip/195bcbf5078d74c8e00d68f04eb8695196fb31e8
Author:     Josh Boyer <jwboyer@redhat.com>
AuthorDate: Thu, 18 Aug 2011 07:37:21 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 18 Aug 2011 07:24:53 -0300

perf tools: Fix build against newer glibc

Upstream glibc commit 295e904 added a definition for __attribute_const__
to cdefs.h.  This causes the following error when building perf:

util/include/linux/compiler.h:8:0: error: "__attribute_const__"
redefined [-Werror] /usr/include/sys/cdefs.h:226:0: note: this is the
location of the previous definition

Wrap __attribute_const__ in #ifndef as we do for __always_inline.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110818113720.GL2227@zod.bos.redhat.com
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/compiler.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/include/linux/compiler.h b/tools/perf/util/include/linux/compiler.h
index 791f9dd..547628e 100644
--- a/tools/perf/util/include/linux/compiler.h
+++ b/tools/perf/util/include/linux/compiler.h
@@ -5,7 +5,9 @@
 #define __always_inline	inline
 #endif
 #define __user
+#ifndef __attribute_const__
 #define __attribute_const__
+#endif
 
 #define __used		__attribute__((__unused__))
 
