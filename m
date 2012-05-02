Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2EBRSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:18:40 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:3864 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab2EBRSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:18:39 -0400
Message-ID: <1335979116.2467.9.camel@lorien2>
Subject: [PATCH] x86: kernel/check.c simple_strtoul cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
Cc: shuahkhan@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 02 May 2012 11:18:36 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change set_corruption_check() and set_corruption_check_period()
in kernel/check.c to call kstrtoul() instead of calling
obsoleted simple_strtoul().

>From f7eee40cda6c50c97e360f8e2ee075908df58a63 Mon Sep 17 00:00:00 2001
From: Shuah Khan <shuahkhan@gmail.com>
Date: Wed, 2 May 2012 11:07:16 -0600
Subject: [PATCH] x86: kernel/check.c simple_strtoul cleanup


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



