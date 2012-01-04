Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2ADPW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:22:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab2ADPWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:22:23 -0500
Date: Wed, 4 Jan 2012 07:21:55 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-057a174a064f68bac042d618ce3c6ea3ccd9a8aa@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1325000151-4463-3-git-send-email-namhyung@gmail.com>
References: <1325000151-4463-3-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Fix a memory leak
Git-Commit-ID: 057a174a064f68bac042d618ce3c6ea3ccd9a8aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 04 Jan 2012 07:22:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  057a174a064f68bac042d618ce3c6ea3ccd9a8aa
Gitweb:     http://git.kernel.org/tip/057a174a064f68bac042d618ce3c6ea3ccd9a8aa
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Wed, 28 Dec 2011 00:35:50 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 3 Jan 2012 14:37:19 -0200

perf top: Fix a memory leak

The 'buf' should be freed when symbol wasn't found too.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325000151-4463-3-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c3836b9..4f81eeb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -351,7 +351,6 @@ static void perf_top__prompt_symbol(struct perf_top *top, const char *msg)
 	if (!found) {
 		fprintf(stderr, "Sorry, %s is not active.\n", buf);
 		sleep(1);
-		return;
 	} else
 		perf_top__parse_source(top, found);
 
