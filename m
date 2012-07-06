Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624Ab2GFLVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:21:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52240 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214Ab2GFLVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:21:15 -0400
Date: Fri, 6 Jul 2012 04:20:57 -0700
From: tip-bot for Peter Huewe <peterhuewe@gmx.de>
Message-ID: <tip-3fxjy46h2tr9pl0spv7tems6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, peterhuewe@gmx.de, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, peterhuewe@gmx.de,
        namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Add missing break in make_bprint_args
Git-Commit-ID: c9bbabe32a231b5caa8c42fa6783405346983c59
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:21:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9bbabe32a231b5caa8c42fa6783405346983c59
Gitweb:     http://git.kernel.org/tip/c9bbabe32a231b5caa8c42fa6783405346983c59
Author:     Peter Huewe <peterhuewe@gmx.de>
AuthorDate: Tue, 24 Apr 2012 23:19:40 +0200
Committer:  Namhyung Kim <namhyung@kernel.org>
CommitDate: Wed, 4 Jul 2012 13:40:31 +0900

tools lib traceevent: Add missing break in make_bprint_args

In the current code we assign vsize=8 and then fall through to the
default and assign vsize=1. -> probably the break is missing here,
otherwise we can remove the case.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-3fxjy46h2tr9pl0spv7tems6@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 8630160..f880db4 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3594,6 +3594,7 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 					break;
 				case 2:
 					vsize = 8;
+					break;
 				default:
 					vsize = ls; /* ? */
 					break;
