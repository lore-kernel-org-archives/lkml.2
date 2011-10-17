Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab1JQNyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 09:54:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41326 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab1JQNya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 09:54:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/3] perf top: Fix the 'E' hotkey, select among multiple events
Date: Mon, 17 Oct 2011 11:54:18 -0200
Message-Id: <1318859659-1171-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318859659-1171-1-git-send-email-acme@infradead.org>
References: <1318859659-1171-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We were not recognizing 'E' as a hotkey due to a bug introduced when
switching to the new, hist_entry based top. Fix it by returning that 'E'
is mapped if evlist->nr_entries > 1.

Reported-by: Mike Galbraith <efault@gmx.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-zcx055vnhagddvqlaqxvdhtb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index bf368f1..7a87171 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -438,6 +438,7 @@ static int key_mapped(int c)
 		case 'S':
 			return 1;
 		case 'E':
+			return top.evlist->nr_entries > 1 ? 1 : 0;
 		default:
 			break;
 	}
-- 
1.6.2.5

