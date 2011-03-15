Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1COWyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:54:16 -0400
Received: from shutemov.name ([188.40.19.243]:49814 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684Ab1COWx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:53:29 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 13/13] perf: use list_move() instead of list_del()/list_add() combination
Date: Wed, 16 Mar 2011 00:53:25 +0200
Message-Id: <1300229605-14499-13-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/util/session.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 105f00b..8b8e04e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -499,8 +499,7 @@ static void flush_sample_queue(struct perf_session *s,
 					   iter->file_offset);
 
 		os->last_flush = iter->timestamp;
-		list_del(&iter->list);
-		list_add(&iter->list, &os->sample_cache);
+		list_move(&iter->list, &os->sample_cache);
 	}
 
 	if (list_empty(head)) {
-- 
1.7.4.1

