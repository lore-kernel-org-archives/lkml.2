Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454Ab1GKW6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 18:58:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51530 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab1GKW6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 18:58:09 -0400
From: Sonny Rao <sonnyrao@chromium.org>
To: acme@redhat.com
Cc: rostedt@goodmis.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Sonny Rao <sonnyrao@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC][PATCH] Remove /proc/kallsyms size verification check in perf
Date: Mon, 11 Jul 2011 15:57:49 -0700
Message-Id: <1310425070-10389-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check was failing when I was trying to profile system startup
because the modules were being loaded and causing the size of
kallsyms to change.  At first I changed the check to simply make
sure the size of kallsyms increased, but that wouldn't cover the
case of a module getting removed (or some removed and larger ones
loaded).  I can't see any purpose to checking the size
right after reading it either, so remove the check altogether.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
---
 tools/perf/util/trace-event-info.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 35729f4..3f1af9f 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -440,9 +440,6 @@ static void read_proc_kallsyms(void)
 	}
 	size = get_size(path);
 	write_or_die(&size, 4);
-	check_size = copy_file(path);
-	if (size != check_size)
-		die("error in size of file '%s'", path);
 
 }
 
-- 
1.7.3.1

