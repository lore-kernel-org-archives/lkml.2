Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab0I0Kkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:40:47 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56607 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab0I0Kkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:40:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=id/W0di5P3/+BzEkFt6u+F3mibwfaCFIon28tCkOzpkniJYDfg8VJn5k+yEQbiRN+m
         P3glOI/S8Yr34kownZy8kpTKVbg5cFdgHpOJlLn7zZiJX2u7DSptLvFXWrCKvVFxb0B5
         A5kwD2pF84GadpyE+YUaFvj4dDrG/PLXxLPEQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] perf: Remove 'extern' on hw_perf_event_init() definition
Date: Mon, 27 Sep 2010 19:39:55 +0900
Message-Id: <1285583997-1262-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
References: <1285583997-1262-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using 'extern' keyword on function definition has no meaning and
sparse complains about it:

 kernel/perf_event.c:78:32: warning: function 'hw_perf_event_init' with external linkage has definition

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 kernel/perf_event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index bd5d750..fd26451 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -75,7 +75,7 @@ static DEFINE_SPINLOCK(perf_resource_lock);
 /*
  * Architecture provided APIs - weak aliases:
  */
-extern __weak const struct pmu *hw_perf_event_init(struct perf_event *event)
+__weak const struct pmu *hw_perf_event_init(struct perf_event *event)
 {
 	return NULL;
 }
-- 
1.7.2.2

