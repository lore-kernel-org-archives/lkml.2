Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab2KIVrj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:47:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48168 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab2KIVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 19/21] tools lib traceevent: No need to check for < 0 on an unsigned enum
Date: Fri,  9 Nov 2012 18:43:08 -0300
Message-Id: <1352497390-17716-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

gcc on f14 32-bit complains:

  tools/lib/traceevent/event-parse.c: In function ‘pevent_register_print_function’:
  tools/lib/traceevent/event-parse.c:5366:3: error: comparison of unsigned expression < 0 is always false

This is because:

          enum pevent_func_arg_type type;

this enum doesn't have any negative value, so gcc makes it an 'unsigned
int'. Fix it by removing the < 0 test.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-6vnd6ud6fbpn48zax4a5ru01@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 6b647c1..38d65958 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5363,7 +5363,7 @@ int pevent_register_print_function(struct pevent *pevent,
 		if (type == PEVENT_FUNC_ARG_VOID)
 			break;
 
-		if (type < 0 || type >= PEVENT_FUNC_ARG_MAX_TYPES) {
+		if (type >= PEVENT_FUNC_ARG_MAX_TYPES) {
 			do_warning("Invalid argument type %d", type);
 			ret = PEVENT_ERRNO__INVALID_ARG_TYPE;
 			goto out_free;
-- 
1.7.9.2.358.g22243

