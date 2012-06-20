Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab2FTQup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:50:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38149 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab2FTQuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:50:44 -0400
Date: Wed, 20 Jun 2012 09:50:20 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-8bxozh5lyixgjmziqaxo9675@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lib: Introduce rtrim
Git-Commit-ID: cb1a28a0cbf9dac5a7a0ca02ebebc12db260d2f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 09:50:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb1a28a0cbf9dac5a7a0ca02ebebc12db260d2f8
Gitweb:     http://git.kernel.org/tip/cb1a28a0cbf9dac5a7a0ca02ebebc12db260d2f8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 7 Jun 2012 18:23:31 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 13:06:19 -0300

perf lib: Introduce rtrim

Remove the trailing whitespaces.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8bxozh5lyixgjmziqaxo9675@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/string.c |   22 ++++++++++++++++++++++
 tools/perf/util/util.h   |    2 ++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index d583638..199bc4d 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -313,3 +313,25 @@ int strtailcmp(const char *s1, const char *s2)
 	return 0;
 }
 
+/**
+ * rtrim - Removes trailing whitespace from @s.
+ * @s: The string to be stripped.
+ *
+ * Note that the first trailing whitespace is replaced with a %NUL-terminator
+ * in the given string @s. Returns @s.
+ */
+char *rtrim(char *s)
+{
+	size_t size = strlen(s);
+	char *end;
+
+	if (!size)
+		return s;
+
+	end = s + size - 1;
+	while (end >= s && isspace(*end))
+		end--;
+	*(end + 1) = '\0';
+
+	return s;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 2daaedb..b13c733 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -264,4 +264,6 @@ bool is_power_of_2(unsigned long n)
 
 size_t hex_width(u64 v);
 
+char *rtrim(char *s);
+
 #endif
