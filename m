Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab0ERUIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:08:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab0ERUIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:08:04 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v2 1/5] [BUGFIX] kprobes: Fix selftest to clear flags
	field for reusing probes
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Tue, 18 May 2010 16:12:51 -0400
Message-ID: <20100518201251.6058.60749.stgit@localhost6.localdomain6>
In-Reply-To: <20100518201244.6058.73083.stgit@localhost6.localdomain6>
References: <20100518201244.6058.73083.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix selftest to clear flags field for reusing probes
because the flags field can be modified by Kprobes.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---

 kernel/test_kprobes.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/test_kprobes.c b/kernel/test_kprobes.c
index 4f10451..ede20f4 100644
--- a/kernel/test_kprobes.c
+++ b/kernel/test_kprobes.c
@@ -115,7 +115,9 @@ static int test_kprobes(void)
 	int ret;
 	struct kprobe *kps[2] = {&kp, &kp2};
 
-	kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	/* addr and flags should be cleard for reusing kprobe. */
+	kp.addr = 0;
+	kp.flags = 0;
 	ret = register_kprobes(kps, 2);
 	if (ret < 0) {
 		printk(KERN_ERR "Kprobe smoke test failed: "
@@ -210,7 +212,9 @@ static int test_jprobes(void)
 	int ret;
 	struct jprobe *jps[2] = {&jp, &jp2};
 
-	jp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	/* addr and flags should be cleard for reusing kprobe. */
+	jp.kp.addr = 0;
+	jp.kp.flags = 0;
 	ret = register_jprobes(jps, 2);
 	if (ret < 0) {
 		printk(KERN_ERR "Kprobe smoke test failed: "
@@ -323,7 +327,9 @@ static int test_kretprobes(void)
 	int ret;
 	struct kretprobe *rps[2] = {&rp, &rp2};
 
-	rp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	/* addr and flags should be cleard for reusing kprobe. */
+	rp.kp.addr = 0;
+	rp.kp.flags = 0;
 	ret = register_kretprobes(rps, 2);
 	if (ret < 0) {
 		printk(KERN_ERR "Kprobe smoke test failed: "


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
