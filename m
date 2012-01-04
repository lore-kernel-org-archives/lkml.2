Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab2ADPhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:37:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab2ADPhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:37:43 -0500
Message-ID: <4F047243.3010009@redhat.com>
Date: Wed, 04 Jan 2012 16:37:39 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH] renumber PTRACE_EVENT_STOP so that future PTRACE_O_TRACEfoo
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PTRACE_EVENT_foo and PTRACE_O_TRACEfoo used to match.

New PTRACE_EVENT_STOP is the first event which has no
corresponding PTRACE_O_TRACE option. If we will ever
want to add another such option, its PTRACE_EVENT's
value will collide with PTRACE_EVENT_STOP's value.

This patch changes PTRACE_EVENT_STOP value to prevent this.

While at it, added comment - the one above,
"Wait extended result codes for the above trace options",
is not true for PTRACE_EVENT_STOP.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
-- 
vda

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 800f113..1729c00 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -72,7 +72,8 @@
  #define PTRACE_EVENT_EXEC	4
  #define PTRACE_EVENT_VFORK_DONE	5
  #define PTRACE_EVENT_EXIT	6
-#define PTRACE_EVENT_STOP	7
+/* Extended result codes which aren't enabled by options.  */
+#define PTRACE_EVENT_STOP	128

  #include <asm/ptrace.h>

