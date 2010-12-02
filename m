Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab0LBSqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:46:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0LBSqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:46:46 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=WC2GRNs5JHEA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=JfrnYn6hAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=dYv6Dy9ctK7_4Af8iAoA:9 a=Bunfgf4aVy5DVuiYtVcA:7 a=x71Y4JF_ZHdXyNET9xBOH6OnSv0A:4 a=3Rfx1nUSh_UA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101202184645.297621940@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 02 Dec 2010 13:46:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] scripts/tags.sh: Add magic for trace-events
References: <20101202184612.129218522@goodmis.org>
Content-Disposition: inline; filename=0002-scripts-tags.sh-Add-magic-for-trace-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Make tags find the trace-event definitions

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290591835.2072.438.camel@laptop>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/tags.sh |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 8509bb5..bbbe584 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -125,7 +125,9 @@ exuberant()
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
 	--extra=+f --c-kinds=-px                                \
 	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
-	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'
+	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
+	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
+	--regex-c++='/^DEFINE_EVENT\(([^,)]*).*/trace_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
-- 
1.7.2.3


