Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab1LLTs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:48:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35854 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab1LLTsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:48:55 -0500
Message-ID: <4EE65AA3.7070609@gmail.com>
Date: Mon, 12 Dec 2011 20:48:51 +0100
From: roel <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        akpm@linux-foundation.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf tools: bad lookup in perf_evlist__equal()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix lookup in perf_evlist__equal()

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 tools/perf/builtin-record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Unless this was a feature, but then a comment might be nice
This was introduced in a91e5431d54f5

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6ab58cc..4ccb7d0 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -252,7 +252,7 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
 	pair = list_entry(other->entries.next, struct perf_evsel, node);
 
 	list_for_each_entry(pos, &evlist->entries, node) {
-		if (memcmp(&pos->attr, &pair->attr, sizeof(pos->attr) != 0))
+		if (memcmp(&pos->attr, &pair->attr, sizeof(pos->attr)) != 0)
 			return false;
 		pair = list_entry(pair->node.next, struct perf_evsel, node);
 	}
