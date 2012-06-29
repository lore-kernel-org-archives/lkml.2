Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab2F2QVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:21:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44571 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277Ab2F2QVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:21:20 -0400
Date: Fri, 29 Jun 2012 09:21:04 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-d9873ab79376d5c0112ed09e14783067dc65e808@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        tim.c.chen@linux.intel.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1339463612-30937-1-git-send-email-dsahern@gmail.com>
References: <1339463612-30937-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Trivial build fix
Git-Commit-ID: d9873ab79376d5c0112ed09e14783067dc65e808
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 29 Jun 2012 09:21:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9873ab79376d5c0112ed09e14783067dc65e808
Gitweb:     http://git.kernel.org/tip/d9873ab79376d5c0112ed09e14783067dc65e808
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 11 Jun 2012 19:13:32 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Jun 2012 13:32:06 -0300

perf tools: Trivial build fix

References to OUTPUT should not be followed by a '/'. When a build
output directory is not specified for this case you get:

gcc -o builtin-annotate.o -c ... -I/util ...

which is wrong.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Link: http://lkml.kernel.org/r/1339463612-30937-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d698c11..75d74e5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -155,7 +155,7 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)/util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -I$(OUTPUT)util -I$(TRACE_EVENT_DIR) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 # Guard against environment variables
