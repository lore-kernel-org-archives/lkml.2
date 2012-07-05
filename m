Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab2GEPpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:45:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60783 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933283Ab2GEPpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 11/20] tools lib traceevent: Do not call add_event() again if allocation failed
Date: Thu,  5 Jul 2012 12:45:09 -0300
Message-Id: <1341503118-13198-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When memory allocation for the field name is failed, do not goto
event_failed since we added the event already.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1335157118-14658-8-git-send-email-namhyung.kim@lge.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 337ca02..99b0cd4 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4770,7 +4770,8 @@ int pevent_parse_event(struct pevent *pevent,
 			arg->field.name = strdup(field->name);
 			if (!arg->field.name) {
 				do_warning("failed to allocate field name");
-				goto event_failed;
+				event->flags |= EVENT_FL_FAILED;
+				return -1;
 			}
 			arg->field.field = field;
 		}
-- 
1.7.9.2.358.g22243

