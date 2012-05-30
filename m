Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2E3AMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 20:12:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:36112 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab2E3ALl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 20:11:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] tools lib traceevent: Silence compiler warning on 32bit build
Date: Tue, 29 May 2012 21:11:25 -0300
Message-Id: <1338336688-25616-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338336688-25616-1-git-send-email-acme@infradead.org>
References: <1338336688-25616-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

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
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1338003691-3141-1-git-send-email-namhyung@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/parse-filter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index e08d21f..dfcfe2c 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -1584,7 +1584,7 @@ get_value(struct event_format *event,
 		const char *name;
 
 		name = get_comm(event, record);
-		return (unsigned long long)name;
+		return (unsigned long)name;
 	}
 
 	pevent_read_number_field(field, record->data, &val);
-- 
1.7.9.2.358.g22243

