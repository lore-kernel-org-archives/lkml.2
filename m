Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619Ab2IHCI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 22:08:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41335 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760337Ab2IHCH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 22:07:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/13] tools lib traceevent: replace mempcpy with memcpy
Date: Fri,  7 Sep 2012 23:07:10 -0300
Message-Id: <1347070032-4161-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347070032-4161-1-git-send-email-acme@infradead.org>
References: <1347070032-4161-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

The mempcpy function is not supported by bionic in Android and will lead
to compilation errors.

Replacing mempcpy with memcpy so it will work in Android.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347065004-15306-11-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 4595aeb..f4190b5 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4833,8 +4833,8 @@ int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
 		msg = strerror_r(errnum, buf, buflen);
 		if (msg != buf) {
 			size_t len = strlen(msg);
-			char *c = mempcpy(buf, msg, min(buflen-1, len));
-			*c = '\0';
+			memcpy(buf, msg, min(buflen - 1, len));
+			*(buf + min(buflen - 1, len)) = '\0';
 		}
 		return 0;
 	}
-- 
1.7.9.2.358.g22243

