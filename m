Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab2EPVoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 17:44:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56067 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab2EPVoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 17:44:32 -0400
Date: Wed, 16 May 2012 14:44:22 -0700
From: tip-bot for Shuah Khan <shuahkhan@gmail.com>
Message-ID: <tip-363f7ce3250aafdaab43011c7dc40158ea571e6b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shuahkhan@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1336327084.2897.15.camel@lorien2>
References: <1336327084.2897.15.camel@lorien2>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: kernel/dumpstack.c simple_strtoul cleanup
Git-Commit-ID: 363f7ce3250aafdaab43011c7dc40158ea571e6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 16 May 2012 14:44:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  363f7ce3250aafdaab43011c7dc40158ea571e6b
Gitweb:     http://git.kernel.org/tip/363f7ce3250aafdaab43011c7dc40158ea571e6b
Author:     Shuah Khan <shuahkhan@gmail.com>
AuthorDate: Sun, 6 May 2012 11:58:04 -0600
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 15 May 2012 15:36:42 -0700

x86: kernel/dumpstack.c simple_strtoul cleanup

Change kstack_setup() and code_bytes_setup() in kernel/dumpstack.c
to call kstrtoul() instead of calling obsoleted simple_strtoul().

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Link: http://lkml.kernel.org/r/1336327084.2897.15.camel@lorien2
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
