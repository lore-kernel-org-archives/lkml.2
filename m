Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab2DDKJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 06:09:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47276 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab2DDKJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 06:09:04 -0400
Date: Wed, 4 Apr 2012 03:08:36 -0700
From: tip-bot for Markus Trippelsdorf <markus@trippelsdorf.de>
Message-ID: <tip-7b78f13603c6fcb64e020a0bbe31a651ea2b657b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, markus@trippelsdorf.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        markus@trippelsdorf.de, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <20120404084527.GA294@x4>
References: <20120404084527.GA294@x4>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix getrusage()
  related build failure on glibc trunk
Git-Commit-ID: 7b78f13603c6fcb64e020a0bbe31a651ea2b657b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 04 Apr 2012 03:08:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b78f13603c6fcb64e020a0bbe31a651ea2b657b
Gitweb:     http://git.kernel.org/tip/7b78f13603c6fcb64e020a0bbe31a651ea2b657b
Author:     Markus Trippelsdorf <markus@trippelsdorf.de>
AuthorDate: Wed, 4 Apr 2012 10:45:27 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 4 Apr 2012 11:59:00 +0200

perf tools: Fix getrusage() related build failure on glibc trunk

On a system running glibc trunk perf doesn't build:

    CC builtin-sched.o
builtin-sched.c: In function ‘get_cpu_usage_nsec_parent’: builtin-sched.c:399:16: error: storage size of ‘ru’ isn’t known builtin-sched.c:403:2: error: implicit declaration of function ‘getrusage’ [-Werror=implicit-function-declaration]
    [...]

Fix it by including sys/resource.h.

Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120404084527.GA294@x4
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/builtin-sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index fb8b5f8..1cad3af 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -17,6 +17,7 @@
 #include "util/debug.h"
 
 #include <sys/prctl.h>
+#include <sys/resource.h>
 
 #include <semaphore.h>
 #include <pthread.h>
