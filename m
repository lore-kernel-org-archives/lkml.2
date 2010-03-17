Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0CQL2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 07:28:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:36013 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab0CQL2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 07:28:38 -0400
Date: Wed, 17 Mar 2010 11:27:35 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100316220521.32050.85155.stgit@localhost6.localdomain6>
References: <20100316220521.32050.85155.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Introduce xzalloc() for detecting out of memory conditions
Message-ID: <tip-a1d37d5285bcda07f9c0b80a2634ca20ab545297@git.kernel.org>
Git-Commit-ID: a1d37d5285bcda07f9c0b80a2634ca20ab545297
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 11:27:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1d37d5285bcda07f9c0b80a2634ca20ab545297
Gitweb:     http://git.kernel.org/tip/a1d37d5285bcda07f9c0b80a2634ca20ab545297
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 16 Mar 2010 18:05:21 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 17 Mar 2010 11:32:29 +0100

perf tools: Introduce xzalloc() for detecting out of memory conditions

Introducing xzalloc() which wrapping zalloc() for detecting out
of memory conditions.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100316220521.32050.85155.stgit@localhost6.localdomain6>
[ -v2: small cleanups in surrounding code ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/util.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 0f5b2a6..5270108 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -295,6 +295,13 @@ extern void *xmemdupz(const void *data, size_t len);
 extern char *xstrndup(const char *str, size_t len);
 extern void *xrealloc(void *ptr, size_t size) __attribute__((weak));
 
+static inline void *xzalloc(size_t size)
+{
+	void *buf = xmalloc(size);
+
+	return memset(buf, 0, size);
+}
+
 static inline void *zalloc(size_t size)
 {
 	return calloc(1, size);
@@ -309,6 +316,7 @@ static inline int has_extension(const char *filename, const char *ext)
 {
 	size_t len = strlen(filename);
 	size_t extlen = strlen(ext);
+
 	return len > extlen && !memcmp(filename + len - extlen, ext, extlen);
 }
 
@@ -322,6 +330,7 @@ static inline int has_extension(const char *filename, const char *ext)
 #undef isalnum
 #undef tolower
 #undef toupper
+
 extern unsigned char sane_ctype[256];
 #define GIT_SPACE		0x01
 #define GIT_DIGIT		0x02
