Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2HUP23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:28:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59792 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab2HUP21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:28:27 -0400
Date: Tue, 21 Aug 2012 08:28:08 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-0cf260131c52f681533d17db6fd07545a3dc184e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de
In-Reply-To: <1344361396-7237-5-git-send-email-robert.richter@amd.com>
References: <1344361396-7237-5-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Fix cast from pointer to integer for 32 bit
Git-Commit-ID: 0cf260131c52f681533d17db6fd07545a3dc184e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:28:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0cf260131c52f681533d17db6fd07545a3dc184e
Gitweb:     http://git.kernel.org/tip/0cf260131c52f681533d17db6fd07545a3dc184e
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 7 Aug 2012 19:43:14 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Aug 2012 12:40:44 -0300

tools lib traceevent: Fix cast from pointer to integer for 32 bit

Fixing the integer cast reported by the following warning:

 tools/lib/traceevent/event-parse.c:3488:14: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1344361396-7237-5-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 5f34aa3..b7c2c49 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -31,6 +31,7 @@
 #include <stdarg.h>
 #include <ctype.h>
 #include <errno.h>
+#include <stdint.h>
 
 #include "event-parse.h"
 #include "event-utils.h"
@@ -3485,7 +3486,7 @@ process_defined_func(struct trace_seq *s, void *data, int size,
 			if (!string->str)
 				die("malloc str");
 
-			args[i] = (unsigned long long)string->str;
+			args[i] = (uintptr_t)string->str;
 			strings = string;
 			trace_seq_destroy(&str);
 			break;
