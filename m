Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab2GFLLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:11:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51908 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2GFLLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:11:07 -0400
Date: Fri, 6 Jul 2012 04:10:54 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-q3g0n1espikynsdkpbi6ue6t@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, johannes.berg@intel.com,
        tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, johannes.berg@intel.com,
        tglx@linutronix.de, namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Fix %pM print format arg handling
Git-Commit-ID: aaf05c725bed1c7a8c940d9215662c78bea05dfd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:11:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aaf05c725bed1c7a8c940d9215662c78bea05dfd
Gitweb:     http://git.kernel.org/tip/aaf05c725bed1c7a8c940d9215662c78bea05dfd
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Mon, 9 Jan 2012 15:58:09 -0500
Committer:  Namhyung Kim <namhyung@kernel.org>
CommitDate: Wed, 4 Jul 2012 13:40:30 +0900

tools lib traceevent: Fix %pM print format arg handling

When %pM is used, the arg value must be a 6 byte character that will
be printed as a 6 byte MAC address. But the code does a break over the
main code which updates the current processing arg to point to the
next arg. If there are other print arguments after a %pM, they will be
off by one. The next arg will still be processing the %pM arg.

Reported-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-q3g0n1espikynsdkpbi6ue6t@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 872dd35..da06c33 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3858,6 +3858,7 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 				} else if (*(ptr+1) == 'M' || *(ptr+1) == 'm') {
 					print_mac_arg(s, *(ptr+1), data, size, event, arg);
 					ptr++;
+					arg = arg->next;
 					break;
 				}
 
