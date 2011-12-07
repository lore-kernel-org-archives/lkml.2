Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049Ab1LGQ0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:26:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934036Ab1LGQ0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:26:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:23 2011
Message-Id: <20111207161222.995253058@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:42 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Steven Rostedt <rostedt@goodmis.org>
Subject: [100/104] perf: Fix parsing of __print_flags() in TP_printk()
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit d06c27b22aa66e48e32f03f9387328a9af9b0625 upstream.

A update is made to the sched:sched_switch event that adds some
logic to the first parameter of the __print_flags() that shows the
state of tasks. This change cause perf to fail parsing the flags.

A simple fix is needed to have the parser be able to process ops
within the argument.

Reported-by: Andrew Vagin <avagin@openvz.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/util/trace-event-parse.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1537,6 +1537,8 @@ process_flags(struct event *event, struc
 	field = malloc_or_die(sizeof(*field));
 
 	type = process_arg(event, field, &token);
+	while (type == EVENT_OP)
+		type = process_op(event, field, &token);
 	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto out_free;
 


