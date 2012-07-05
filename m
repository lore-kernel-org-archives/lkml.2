Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801Ab2GEPpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:45:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:59081 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964776Ab2GEPp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 04/20] tools lib traceevent: Fix %pM print format arg handling
Date: Thu,  5 Jul 2012 12:45:02 -0300
Message-Id: <1341503118-13198-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

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
 1 file changed, 1 insertion(+)

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
 
-- 
1.7.9.2.358.g22243

