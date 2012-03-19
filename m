Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032967Ab2CSUGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:06:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032761Ab2CSUGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:06:38 -0400
Date: Mon, 19 Mar 2012 13:06:20 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-f7e5410920fabadf294177f590b54ab0cadc4775@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1332125180-23041-1-git-send-email-namhyung.kim@lge.com>
References: <1332125180-23041-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browser:
  Clean lines inside of the input window
Git-Commit-ID: f7e5410920fabadf294177f590b54ab0cadc4775
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 19 Mar 2012 13:06:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7e5410920fabadf294177f590b54ab0cadc4775
Gitweb:     http://git.kernel.org/tip/f7e5410920fabadf294177f590b54ab0cadc4775
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 19 Mar 2012 11:46:20 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 19 Mar 2012 12:07:30 -0300

perf ui browser: Clean lines inside of the input window

As Arnaldo pointed out, it should be cleared to prevent the window from
displaying overlapped strings on the region.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1332125180-23041-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/util.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index 360f43f..ad4374a 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -108,9 +108,13 @@ int ui_browser__input_window(const char *title, const char *text, char *input,
 	max_len -= 2;
 	SLsmg_write_wrapped_string((unsigned char *)text, y, x,
 				   nr_lines, max_len, 1);
-	y += nr_lines + 1;
-	SLsmg_set_color(0);
-	SLsmg_draw_box(y - 1, x + 1, 3, max_len - 2);
+	y += nr_lines;
+	len = 5;
+	while (len--) {
+		SLsmg_gotorc(y + len - 1, x);
+		SLsmg_write_nstring((char *)" ", max_len);
+	}
+	SLsmg_draw_box(y++, x + 1, 3, max_len - 2);
 
 	SLsmg_gotorc(y + 3, x);
 	SLsmg_write_nstring((char *)exit_msg, max_len);
