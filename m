Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1G3D41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 23:56:27 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39737 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab1G3D4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 23:56:24 -0400
From: bookjovi@gmail.com
To: bookjovi@gmail.com, acme@ghostprotocols.net, mingo@elte.hu,
        a.p.zijlstra@chello.nl, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, root <root@localhost.localdomain>
Subject: [PATCH] perf: fix coredump caused by introduce of probe module option
Date: Mon, 25 Jul 2011 22:08:08 +0800
Message-Id: <1311602888-2389-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: root <root@localhost.localdomain>

perf will coredump if user don't give "-m" option in probe command,
this patch fix it.

[root@localhost perf]# ./perf probe --add='PROBE'
Segmentation fault (core dumped)

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 tools/perf/util/probe-event.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index b82d54f..1c7bfa5 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1820,11 +1820,15 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 		ret = -ENOMEM;
 		goto error;
 	}
-	tev->point.module = strdup(module);
-	if (tev->point.module == NULL) {
-		ret = -ENOMEM;
-		goto error;
+
+	if (module) {
+		tev->point.module = strdup(module);
+		if (tev->point.module == NULL) {
+			ret = -ENOMEM;
+			goto error;
+		}
 	}
+
 	tev->point.offset = pev->point.offset;
 	tev->point.retprobe = pev->point.retprobe;
 	tev->nargs = pev->nargs;
-- 
1.6.5.2

