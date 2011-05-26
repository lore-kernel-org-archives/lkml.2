Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab1EZPcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:32:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37581 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab1EZP36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:29:58 -0400
X-Authority-Analysis: v=1.1 cv=u/eXSd3k4P+OuNmbl5aZU3ellt6eTxbOnGssQLT4hSY= c=1 sm=0 a=vhdKIqpQuCYA:10 a=XhTRlI7qtM4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=R4OIfPOWf54sI-kwbrAA:9 a=rs5XN9IBFMkls9kJKfIA:7 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110526152955.948347501@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 11:25:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/12] scripts/tags.sh: Fix ctags for DEFINE_EVENT()
References: <20110526152541.995963172@goodmis.org>
Content-Disposition: inline; filename=0003-scripts-tags.sh-Fix-ctags-for-DEFINE_EVENT.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The regex to handle DEFINE_EVENT() should not be the same as
the TRACE_EVENT() as the first parameter in DEFINE_EVENT is the
template name, not the event name. We need the second parameter
as that is what the trace_... will use.

Tested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/tags.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index bd6185d..33b53ca 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -132,7 +132,7 @@ exuberant()
 	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
 	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
 	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
-	--regex-c++='/^DEFINE_EVENT\(([^,)]*).*/trace_\1/'
+	--regex-c++='/^DEFINE_EVENT\([^,)]*, *([^,)]*).*/trace_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
-- 
1.7.4.4


