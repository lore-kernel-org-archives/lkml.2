Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2KXAVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:21:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:57935 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab2KXAVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:21:24 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org,
        x86@kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 8/8] perf kvm: Fix building perf kvm on non x86 arches
Date: Fri, 23 Nov 2012 21:20:53 -0300
Message-Id: <1353716453-9693-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353716453-9693-1-git-send-email-acme@infradead.org>
References: <1353716453-9693-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>

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
 tools/perf/builtin-kvm.c |    4 ++++
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
 
-- 
1.7.9.2.358.g22243

