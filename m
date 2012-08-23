Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964838Ab2HWHny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:43:54 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45590 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2HWHnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:43:51 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-54-5035df348a6a
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] tools lib traceevent: Fix off-by-one bug in pevent_strerror()
Date: Thu, 23 Aug 2012 16:37:00 +0900
Message-Id: <1345707420-21767-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

As pevent_errno is defined using PEVENT_ERRORS which uses _PE macro
magic, the first errno is bigger than __PEVENT_ERRNO_START by 1. So we
need to subtract the 1 also when calculating the index of the error
strings.

Cc: Fredereic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f978c59f67bf..b5b4d806ffa2 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4822,7 +4822,7 @@ int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
 	    errnum >= __PEVENT_ERRNO__END)
 		return -1;
 
-	idx = errnum - __PEVENT_ERRNO__START;
+	idx = errnum - __PEVENT_ERRNO__START - 1;
 	msg = pevent_error_str[idx];
 
 	switch (errnum) {
-- 
1.7.11.4

