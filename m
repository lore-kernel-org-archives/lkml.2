Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0JNDIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 23:08:15 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46529 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab0JNDIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 23:08:13 -0400
X-AuditID: b753bd60-a98ddba000000a18-28-4cb6741a251a
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 2/5] [RESEND][BUGFIX] kprobes: Fix selftest to clear
	flags field for reusing probes
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Date: Thu, 14 Oct 2010 12:10:24 +0900
Message-ID: <20101014031024.4100.50107.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101014031011.4100.32343.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101014031011.4100.32343.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix selftest to clear flags field for reusing probes
because the flags field can be modified by Kprobes.
This also set NULL to kprobe.addr instead of 0.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
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

