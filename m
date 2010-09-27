Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab0I0KlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:41:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48212 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0I0KlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:41:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=p7tcnXG9h6p876PtEMICsnh4hiJiOUx/S3A2Z3jb9yYBODzum7DdWiy7vJMAVuBKCg
         QsLexIN3i6oHCRFgT6xG801lY7spQIa04j8kvjXkUhHis9b2uh7K1EPzdmBeMGK5bKPb
         e6+vJIHnCQzbMpInN+Y7YfB4wtbUY6HwN7InQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] perf: Make perf_event_wakeup() static
Date: Mon, 27 Sep 2010 19:39:56 +0900
Message-Id: <1285583997-1262-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
References: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make perf_event_wakeup() static since it is called only in
static functions.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index fd26451..6611349 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2845,7 +2845,7 @@ static const struct file_operations perf_fops = {
  * to user-space before waking everybody up.
  */
 
-void perf_event_wakeup(struct perf_event *event)
+static void perf_event_wakeup(struct perf_event *event)
 {
 	wake_up_all(&event->waitq);
 
-- 
1.7.2.2

