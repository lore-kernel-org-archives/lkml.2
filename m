Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721Ab1GODlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 23:41:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab1GODlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 23:41:03 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=zDcy0JGo9fkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=cbZ2NWfkKWXa5YNs3dwA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110715034101.374392195@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 14 Jul 2011 23:38:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] ftrace: Fix warning when CONFIG_FUNCTION_TRACER is not defined
References: <20110715033855.206223173@goodmis.org>
Content-Disposition: inline; filename=0001-ftrace-Fix-warning-when-CONFIG_FUNCTION_TRACER-is-no.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The struct ftrace_hash was declared within CONFIG_FUNCTION_TRACER
but was referenced outside of it.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ed0eb52..f0c0e8a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -19,6 +19,8 @@
 
 #include <asm/ftrace.h>
 
+struct ftrace_hash;
+
 #ifdef CONFIG_FUNCTION_TRACER
 
 extern int ftrace_enabled;
@@ -29,8 +31,6 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
 
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
 
-struct ftrace_hash;
-
 enum {
 	FTRACE_OPS_FL_ENABLED		= 1 << 0,
 	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
-- 
1.7.5.4


