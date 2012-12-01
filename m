Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab2LALWW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 06:22:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43060 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab2LALWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 06:22:20 -0500
Date: Sat, 1 Dec 2012 03:21:46 -0800
From: tip-bot for Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Message-ID: <tip-7321090f6751c9987c26a8c81c63680d16a614d7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        namhyung@gmail.com, bp@alien8.de, runzhen@linux.vnet.ibm.com,
        dhowells@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        haodong@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de,
        jwboyer@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        torvalds@linux-foundation.org, bp@alien8.de, namhyung@gmail.com,
        runzhen@linux.vnet.ibm.com, dhowells@redhat.com,
        haodong@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de, jwboyer@gmail.com
In-Reply-To: <50A9EB89.70901@linux.vnet.ibm.com>
References: <50A9EB89.70901@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kvm:
  Fix building perf kvm on non x86 arches
Git-Commit-ID: 7321090f6751c9987c26a8c81c63680d16a614d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 01 Dec 2012 03:21:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7321090f6751c9987c26a8c81c63680d16a614d7
Gitweb:     http://git.kernel.org/tip/7321090f6751c9987c26a8c81c63680d16a614d7
Author:     Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
AuthorDate: Mon, 19 Nov 2012 16:19:21 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 23 Nov 2012 20:40:17 -0300

perf kvm: Fix building perf kvm on non x86 arches

Now, 'perf kvm stat' is only supported on x86, let its code depend on
(__x86_64__ || __i386__) to fix building it on other architectures.

Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Boyer <jwboyer@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/50A9EB89.70901@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 9fa45fa..283b439 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -22,6 +22,7 @@
 #include <pthread.h>
 #include <math.h>
 
+#if defined(__i386__) || defined(__x86_64__)
 #include <asm/svm.h>
 #include <asm/vmx.h>
 #include <asm/kvm.h>
@@ -896,6 +897,7 @@ static int kvm_cmd_stat(const char *file_name, int argc, const char **argv)
 perf_stat:
 	return cmd_stat(argc, argv, NULL);
 }
+#endif
 
 static int __cmd_record(const char *file_name, int argc, const char **argv)
 {
@@ -1018,8 +1020,10 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 		return cmd_top(argc, argv, NULL);
 	else if (!strncmp(argv[0], "buildid-list", 12))
 		return __cmd_buildid_list(file_name, argc, argv);
+#if defined(__i386__) || defined(__x86_64__)
 	else if (!strncmp(argv[0], "stat", 4))
 		return kvm_cmd_stat(file_name, argc, argv);
+#endif
 	else
 		usage_with_options(kvm_usage, kvm_options);
 
