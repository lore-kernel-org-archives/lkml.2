Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab2EZDmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 23:42:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46586 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2EZDmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 23:42:00 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tools libtraceevent: Silence compiler warning on 32bit build
Date: Sat, 26 May 2012 12:41:31 +0900
Message-Id: <1338003691-3141-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The gcc complains about casting a pointer to unsigned long long directly:

    SUBDIR ../lib/traceevent/
  CC FPIC            event-parse.o
  CC FPIC            trace-seq.o
  CC FPIC            parse-filter.o
/home/namhyung/project/linux/tools/lib/traceevent/parse-filter.c: In function ‘get_value’:
/home/namhyung/project/linux/tools/lib/traceevent/parse-filter.c:1588: warning: cast from pointer to integer of different size
  CC FPIC            parse-utils.o
  BUILD STATIC LIB   libtraceevent.a

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/lib/traceevent/parse-filter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 2d40c5e..aa30b43 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1585,7 +1585,7 @@ get_value(struct event_format *event,
 		const char *name;
 
 		name = get_comm(event, record);
-		return (unsigned long long)name;
+		return (unsigned long)name;
 	}
 
 	pevent_read_number_field(field, record->data, &val);
-- 
1.7.2.2

