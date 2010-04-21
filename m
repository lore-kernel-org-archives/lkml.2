Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab0DUABF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 20:01:05 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56940 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab0DUABC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 20:01:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :mime-version:content-type:content-transfer-encoding;
        b=nmz7TnRONOqZ1cKTNrtH/U4qrDNVOATP04D6Ip2wFPSDSxBsv2e4p1KOEEuK9i6F2d
         vCfHBN58yhsBH+FiS5rROyQDhC1uXspXDTtlCNSIXP4mNw/FZZNi/T5ZoF5BWSyYLBLd
         aYaw0Aq1voJuTAWj4aJixcIrYPJ6o29QXuRhU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf: Fix perf probe build error
Date: Wed, 21 Apr 2010 02:01:05 +0200
Message-Id: <1271808065-25290-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we run into dry run mode, we want to make write_kprobe_trace_event
to succeed on writing the event. Let's initialize it to 0.

Fixes the following build error:
	util/probe-event.c:1266: attention : «ret» may be used uninitialized in this function
	util/probe-event.c:1266: note: «ret» was declared here

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/util/probe-event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 3967f8f..4fb4803 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1263,7 +1263,7 @@ static struct strlist *get_kprobe_trace_event_names(int fd, bool include_group)
 
 static int write_kprobe_trace_event(int fd, struct kprobe_trace_event *tev)
 {
-	int ret;
+	int ret = 0;
 	char *buf = synthesize_kprobe_trace_command(tev);
 
 	if (!buf) {
-- 
1.6.2.3

