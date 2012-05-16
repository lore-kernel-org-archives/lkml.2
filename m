Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab2EPVnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 17:43:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2EPVno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 17:43:44 -0400
Date: Wed, 16 May 2012 14:43:33 -0700
From: tip-bot for Shuah Khan <shuahkhan@gmail.com>
Message-ID: <tip-5abe68e493e5aea1ccfc384092f8e98a542b336a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shuahkhan@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1336326908.2897.12.camel@lorien2>
References: <1336326908.2897.12.camel@lorien2>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: kernel/check.c simple_strtoul cleanup
Git-Commit-ID: 5abe68e493e5aea1ccfc384092f8e98a542b336a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 16 May 2012 14:43:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5abe68e493e5aea1ccfc384092f8e98a542b336a
Gitweb:     http://git.kernel.org/tip/5abe68e493e5aea1ccfc384092f8e98a542b336a
Author:     Shuah Khan <shuahkhan@gmail.com>
AuthorDate: Sun, 6 May 2012 11:55:08 -0600
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 15 May 2012 15:36:41 -0700

x86: kernel/check.c simple_strtoul cleanup

Change set_corruption_check() and set_corruption_check_period()
in kernel/check.c to call kstrtoul() instead of calling
obsoleted simple_strtoul().

Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
Link: http://lkml.kernel.org/r/1336326908.2897.12.camel@lorien2
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/check.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 5da1269..e2dbcb7 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -27,21 +27,29 @@ static int num_scan_areas;
 
 static __init int set_corruption_check(char *arg)
 {
-	char *end;
+	ssize_t ret;
+	unsigned long val;
 
-	memory_corruption_check = simple_strtol(arg, &end, 10);
+	ret = kstrtoul(arg, 10, &val);
+	if (ret)
+		return ret;
 
-	return (*end == 0) ? 0 : -EINVAL;
+	memory_corruption_check = val;
+	return 0;
 }
 early_param("memory_corruption_check", set_corruption_check);
 
 static __init int set_corruption_check_period(char *arg)
 {
-	char *end;
+	ssize_t ret;
+	unsigned long val;
 
-	corruption_check_period = simple_strtoul(arg, &end, 10);
+	ret = kstrtoul(arg, 10, &val);
+	if (ret)
+		return ret;
 
-	return (*end == 0) ? 0 : -EINVAL;
+	corruption_check_period = val;
+	return 0;
 }
 early_param("memory_corruption_check_period", set_corruption_check_period);
 
