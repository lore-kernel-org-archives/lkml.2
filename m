Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab0KXJnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 04:43:41 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39700 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab0KXJnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 04:43:40 -0500
Subject: [PATCH] scripts/tags.sh: Add magic for trace-events
From: Peter Zijlstra <peterz@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 10:43:55 +0100
Message-ID: <1290591835.2072.438.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make tags find the trace-event definitions

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
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

