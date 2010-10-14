Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0JNHk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 03:40:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:37622 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab0JNHkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 03:40:55 -0400
Date: Thu, 14 Oct 2010 07:40:22 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com,
        rusty@rustcorp.com.au, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        rusty@rustcorp.com.au, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101014031024.4100.50107.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101014031024.4100.50107.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Fix selftest to clear flags field for reusing probes
Message-ID: <tip-fd02e6f7ae085840d43d780149fcf95a614eca5e@git.kernel.org>
Git-Commit-ID: fd02e6f7ae085840d43d780149fcf95a614eca5e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Oct 2010 07:40:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd02e6f7ae085840d43d780149fcf95a614eca5e
Gitweb:     http://git.kernel.org/tip/fd02e6f7ae085840d43d780149fcf95a614eca5e
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Oct 2010 12:10:24 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Oct 2010 08:55:27 +0200

kprobes: Fix selftest to clear flags field for reusing probes

Fix selftest to clear flags field for reusing probes
because the flags field can be modified by Kprobes.
This also set NULL to kprobe.addr instead of 0.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
LKML-Reference: <20101014031024.4100.50107.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/test_kprobes.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/test_kprobes.c b/kernel/test_kprobes.c
index 4f10451..f8b11a2 100644
--- a/kernel/test_kprobes.c
+++ b/kernel/test_kprobes.c
@@ -115,7 +115,9 @@ static int test_kprobes(void)
 	int ret;
 	struct kprobe *kps[2] = {&kp, &kp2};
 
-	kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	/* addr and flags should be cleard for reusing kprobe. */
+	kp.addr = NULL;
+	kp.flags = 0;
 	ret = register_kprobes(kps, 2);
 	if (ret < 0) {
 		printk(KERN_ERR "Kprobe smoke test failed: "
@@ -210,7 +212,9 @@ static int test_jprobes(void)
 	int ret;
 	struct jprobe *jps[2] = {&jp, &jp2};
 
-	jp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	/* addr and flags should be cleard for reusing kprobe. */
+	jp.kp.addr = NULL;
+	jp.kp.flags = 0;
 	ret = register_jprobes(jps, 2);
 	if (ret < 0) {
 		printk(KERN_ERR "Kprobe smoke test failed: "
@@ -323,7 +327,9 @@ static int test_kretprobes(void)
 	int ret;
 	struct kretprobe *rps[2] = {&rp, &rp2};
 
-	rp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	/* addr and flags should be cleard for reusing kprobe. */
+	rp.kp.addr = NULL;
+	rp.kp.flags = 0;
 	ret = register_kretprobes(rps, 2);
 	if (ret < 0) {
 		printk(KERN_ERR "Kprobe smoke test failed: "
