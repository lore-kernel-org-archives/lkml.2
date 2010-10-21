Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab0JUCnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:43:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57089 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757157Ab0JUCnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:43:07 -0400
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=KgIrQOE9HB0A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=eJfxgxciAAAA:8 a=meVymXHHAAAA:8 a=6-9FD0XuZcO_w3grd4YA:9 a=amcUIKvx2a4gRXyl9_gA:7 a=mm4VwRSBnjoNltpJx2L0SiO1fCgA:4 a=jEp0ucaQiEUA:10 a=W39ifWXXhksA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101021024305.083835718@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Oct 2010 22:42:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] tracing: Do not limit the size of the number of CPU buffers
References: <20101021024233.530237054@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Do-not-limit-the-size-of-the-number-of-CPU-b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The tracing per_cpu buffers were limited to 999 CPUs for a mear
savings in stack space of a char array. Up the array to 30 characters
which is more than enough to hold a 64 bit number.

Reported-by: Robin Holt <holt@sgi.com>
Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 001bcd2..82d9b81 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3996,13 +3996,9 @@ static void tracing_init_debugfs_percpu(long cpu)
 {
 	struct dentry *d_percpu = tracing_dentry_percpu();
 	struct dentry *d_cpu;
-	/* strlen(cpu) + MAX(log10(cpu)) + '\0' */
-	char cpu_dir[7];
+	char cpu_dir[30]; /* 30 characters should be more than enough */
 
-	if (cpu > 999 || cpu < 0)
-		return;
-
-	sprintf(cpu_dir, "cpu%ld", cpu);
+	snprintf(cpu_dir, 30, "cpu%ld", cpu);
 	d_cpu = debugfs_create_dir(cpu_dir, d_percpu);
 	if (!d_cpu) {
 		pr_warning("Could not create debugfs '%s' entry\n", cpu_dir);
-- 
1.7.1


