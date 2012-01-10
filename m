Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab2AJXYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:24:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933687Ab2AJW7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:59:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:46:19 2012
Message-Id: <20120110214619.340915471@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:45:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steven Rostedt <rostedt@goodmis.org>
Subject: [13/40] perf: Fix parsing of __print_flags() in TP_printk()
In-Reply-To: <20120110214630.GA14384@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 49908a1b25d448d68fd26faca260e1850201575f upstream.

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
@@ -1582,6 +1582,8 @@ process_symbols(struct event *event, str
 	field = malloc_or_die(sizeof(*field));
 
 	type = process_arg(event, field, &token);
+	while (type == EVENT_OP)
+		type = process_op(event, field, &token);
 	if (test_type_token(type, token, EVENT_DELIM, ","))
 		goto out_free;
 


