Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab2EFRzM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 13:55:12 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:47226 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab2EFRzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 13:55:10 -0400
Message-ID: <1336326908.2897.12.camel@lorien2>
Subject: [PATCH RESEND] x86: kernel/check.c simple_strtoul cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
Cc: shuahkhan@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 06 May 2012 11:55:08 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change set_corruption_check() and set_corruption_check_period()
in kernel/check.c to call kstrtoul() instead of calling
obsoleted simple_strtoul().


Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
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
 
-- 
1.7.5.4



