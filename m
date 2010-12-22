Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab0LVLbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:31:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:34708 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab0LVLas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:30:48 -0500
Date: Wed, 22 Dec 2010 11:30:31 GMT
From: tip-bot for Franck Bui-Huu <fbuihuu@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, fbuihuu@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1292854685-8230-2-git-send-email-fbuihuu@gmail.com>
References: <1292854685-8230-2-git-send-email-fbuihuu@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Make -L display the absolute path of the dumped file
Message-ID: <tip-62c15fc49bd1b35d79b34ea96f132ab435e2215a@git.kernel.org>
Git-Commit-ID: 62c15fc49bd1b35d79b34ea96f132ab435e2215a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 11:30:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62c15fc49bd1b35d79b34ea96f132ab435e2215a
Gitweb:     http://git.kernel.org/tip/62c15fc49bd1b35d79b34ea96f132ab435e2215a
Author:     Franck Bui-Huu <fbuihuu@gmail.com>
AuthorDate: Mon, 20 Dec 2010 15:18:00 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 21 Dec 2010 16:20:11 -0200

perf probe: Make -L display the absolute path of the dumped file

The actual file used by 'perf probe -L sched.c' is reported in the ouput
of the command.

But it's simply displayed as it has been given to the command (simply
sched.c) which is too ambiguous to be really usefull since several
sched.c files can be found into the same project and we also don't know
which search path has been used.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <1292854685-8230-2-git-send-email-fbuihuu@gmail.com>
Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 089d78e..0163fc0 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -371,7 +371,7 @@ int show_line_range(struct line_range *lr, const char *module)
 		fprintf(stdout, "<%s:%d>\n", lr->function,
 			lr->start - lr->offset);
 	else
-		fprintf(stdout, "<%s:%d>\n", lr->file, lr->start);
+		fprintf(stdout, "<%s:%d>\n", lr->path, lr->start);
 
 	fp = fopen(lr->path, "r");
 	if (fp == NULL) {
