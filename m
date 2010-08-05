Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab0HEMfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:35:19 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40328 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933288Ab0HEMfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:35:16 -0400
X-AuditID: b753bd60-aa6d3ba000005dcc-01-4c5ab00154f8
Message-ID: <4C5AAFFF.8060002@hitachi.com>
Date: Thu, 05 Aug 2010 21:35:11 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [BUGFIX] kprobes: Fix selftest to clear flags field for
 reusing probes
References: <20100805123134.3888.4549.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20100805123134.3888.4549.stgit@ltc236.sdl.hitachi.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix selftest to clear flags field for reusing probes
because the flags field can be modified by Kprobes.
This also set NULL to kprobe.addr instead of 0.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
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


