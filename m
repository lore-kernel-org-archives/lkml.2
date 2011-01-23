Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab1AWSDG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 13:03:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:56048 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab1AWSDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 13:03:03 -0500
Date: Sun, 23 Jan 2011 18:02:35 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        eric.dumazet@gmail.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, tzanussi@gmail.com, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Fix build by checking if extra warnings are supported
Message-ID: <tip-065bef5af620dcedeb6dc26fdc0b1739a3c9adef@git.kernel.org>
Git-Commit-ID: 065bef5af620dcedeb6dc26fdc0b1739a3c9adef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 23 Jan 2011 18:02:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  065bef5af620dcedeb6dc26fdc0b1739a3c9adef
Gitweb:     http://git.kernel.org/tip/065bef5af620dcedeb6dc26fdc0b1739a3c9adef
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 22 Jan 2011 19:29:53 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 22 Jan 2011 19:29:53 -0200

perf tools: Fix build by checking if extra warnings are supported

The -Wstack-protector and -Wvolatile-register-var warnings, for
instance, are not supported by gcc 3.4.6.

So fix by doing the same check we already do for -fstack-protector-all.

With this and the other patches in this series, perf builds unmodified
on, for instance, RHEL4.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2b5387d..7141c42 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -204,13 +204,11 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Winit-self
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wpacked
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wredundant-decls
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstack-protector
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-aliasing=3
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-default
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wswitch-enum
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wno-system-headers
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wundef
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wvolatile-register-var
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wwrite-strings
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wbad-function-cast
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wmissing-declarations
@@ -294,6 +292,13 @@ ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -fstack-protector-all),y)
 	CFLAGS := $(CFLAGS) -fstack-protector-all
 endif
 
+ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -Wstack-protector),y)
+       CFLAGS := $(CFLAGS) -Wstack-protector
+endif
+
+ifeq ($(call try-cc,$(SOURCE_HELLO),-Werror -Wvolatile-register-var),y)
+       CFLAGS := $(CFLAGS) -Wvolatile-register-var
+endif
 
 ### --- END CONFIGURATION SECTION ---
 
