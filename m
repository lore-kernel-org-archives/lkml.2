Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab1EXSTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:19:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48783 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab1EXSRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:17:22 -0400
X-Authority-Analysis: v=1.1 cv=y6zMVzRGPZqd+EkIbWgKRW0ZY5+85Abqc3bXR1aXymM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=oMpU991Shx0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=meVymXHHAAAA:8 a=Cvnpr_plYiz56EIE95kA:9 a=f4aaqkA5SDfED389QQEA:7 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110524181720.136732653@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 14:10:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 04/12] scripts/tags.sh: Add magic for trace-events for etags too
References: <20110524181032.382259739@goodmis.org>
Content-Disposition: inline; filename=0004-scripts-tags.sh-Add-magic-for-trace-events-for-etags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Seems that Peter Zijlstra treats us emacs users as second class
citizens and the commit:

 commit 15664125f7cadcb6d725cb2d9b90f9715397848d
 Author: Peter Zijlstra <peterz@infradead.org>
 scripts/tags.sh: Add magic for trace-events

only updated ctags (for vim) and did not do the work to let us
lowly emacs users benefit from such a change.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/tags.sh |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 33b53ca..75c5d24 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -152,7 +152,9 @@ emacs()
 {
 	all_sources | xargs $1 -a                               \
 	--regex='/^ENTRY(\([^)]*\)).*/\1/'                      \
-	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'
+	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
+	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
+	--regex='/^DEFINE_EVENT([^,)]*, *\([^,)]*\).*/trace_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
-- 
1.7.4.4


