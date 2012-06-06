Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab2FFHJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:09:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35977 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2FFHJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:09:58 -0400
Date: Wed, 6 Jun 2012 00:09:36 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-cb7225feec627e91d598198996429e9ee6804f8d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1338443506-25009-1-git-send-email-namhyung.kim@lge.com>
References: <1338443506-25009-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf:
  Remove duplicate invocation on perf_event_for_each
Git-Commit-ID: cb7225feec627e91d598198996429e9ee6804f8d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 00:09:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb7225feec627e91d598198996429e9ee6804f8d
Gitweb:     http://git.kernel.org/tip/cb7225feec627e91d598198996429e9ee6804f8d
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 31 May 2012 14:51:44 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 May 2012 14:01:00 -0300

perf: Remove duplicate invocation on perf_event_for_each

The @func callback was invoked twice for group leader when
perf_event_for_each() called. It seems the commit 75f937f24bd9
("perf_counter: Fix ctx->mutex vs counter ->mutex inversion") made the
mistake during the change.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338443506-25009-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5b06cbb..f85c015 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3181,7 +3181,6 @@ static void perf_event_for_each(struct perf_event *event,
 	event = event->group_leader;
 
 	perf_event_for_each_child(event, func);
-	func(event);
 	list_for_each_entry(sibling, &event->sibling_list, group_entry)
 		perf_event_for_each_child(sibling, func);
 	mutex_unlock(&ctx->mutex);
