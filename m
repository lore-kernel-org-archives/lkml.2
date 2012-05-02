Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2EBWui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:50:38 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:10910 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2EBWuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:50:37 -0400
Message-ID: <1335999034.2810.4.camel@lorien2>
Subject: [PATCH] x86: kernel/dumpstack.c simple_strtoul cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
Cc: shuahkhan@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 02 May 2012 16:50:34 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change kstack_setup() and code_bytes_setup() in kernel/dumpstack.c
to call kstrtoul() instead of calling obsoleted simple_strtoul().

>From 2988db2b5cef39ee908a0165732a42c12897ccef Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Wed, 2 May 2012 12:59:17 -0600
Subject: [PATCH] x86: kernel/dumpstack.c simple_strtoul cleanup


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
---
 arch/x86/kernel/dumpstack.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 1b81839..b154f6d 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -311,16 +311,33 @@ void die(const char *str, struct pt_regs *regs, long err)
 
 static int __init kstack_setup(char *s)
 {
+	ssize_t ret;
+	unsigned long val;
+
 	if (!s)
 		return -EINVAL;
-	kstack_depth_to_print = simple_strtoul(s, NULL, 0);
+
+	ret = kstrtoul(s, 0, &val);
+	if (ret)
+		return ret;
+	kstack_depth_to_print = val;
 	return 0;
 }
 early_param("kstack", kstack_setup);
 
 static int __init code_bytes_setup(char *s)
 {
-	code_bytes = simple_strtoul(s, NULL, 0);
+	ssize_t ret;
+	unsigned long val;
+
+	if (!s)
+		return -EINVAL;
+
+	ret = kstrtoul(s, 0, &val);
+	if (ret)
+		return ret;
+
+	code_bytes = val;
 	if (code_bytes > 8192)
 		code_bytes = 8192;
 
-- 
1.7.5.4



