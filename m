Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2BJOoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:44:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:55014 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab2BJOoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:44:04 -0500
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 4/5] ptrace: renumber PTRACE_EVENT_STOP so that future new options and events can match
Date: Fri, 10 Feb 2012 15:43:10 +0100
Message-Id: <1328884991-23889-5-git-send-email-vda.linux@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1328884991-23889-4-git-send-email-vda.linux@googlemail.com>
References: <1328884991-23889-1-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-2-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-3-git-send-email-vda.linux@googlemail.com>
 <1328884991-23889-4-git-send-email-vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PTRACE_EVENT_foo and PTRACE_O_TRACEfoo used to match.

New PTRACE_EVENT_STOP is the first event which has no corresponding
PTRACE_O_TRACE option. If we will ever want to add another such option,
its PTRACE_EVENT's value will collide with PTRACE_EVENT_STOP's value.

This patch changes PTRACE_EVENT_STOP value to prevent this.

While at it, added a comment - the one atop PTRACE_EVENT block,
saying "Wait extended result codes for the above trace options",
is not true for PTRACE_EVENT_STOP.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
---
 include/linux/ptrace.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 06be6a3..ec6571c 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -61,7 +61,8 @@
 #define PTRACE_EVENT_EXEC	4
 #define PTRACE_EVENT_VFORK_DONE	5
 #define PTRACE_EVENT_EXIT	6
-#define PTRACE_EVENT_STOP	7
+/* Extended result codes which enabled by means other than options.  */
+#define PTRACE_EVENT_STOP	128
 
 /* options set using PTRACE_SETOPTIONS */
 #define PTRACE_O_TRACESYSGOOD	1
-- 
1.7.7.6

