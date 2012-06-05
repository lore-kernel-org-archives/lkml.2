Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab2FEFN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 01:13:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63918 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2FEFNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 01:13:55 -0400
Message-ID: <4FCD95D3.90209@gmail.com>
Date: Tue, 05 Jun 2012 13:14:59 +0800
From: Shan Wei <shanwei88@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, namhyung.kim@lge.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
CC: Samuel Liao <samuelliao@tencent.com>
Subject: [Perf bug-fix] check null of sym pointer before using it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Liao <samuelliao@tencent.com>

Sometimes, sym will be null that causing perf crash.

Signed-off-by: Shan Wei <davidshan@tencent.com>
---
 tools/perf/ui/browsers/annotate.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 4deea6a..50873a8 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -814,7 +814,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 {
 	struct disasm_line *pos, *n;
 	struct annotation *notes;
-	const size_t size = symbol__size(sym);
+	size_t size;
 	struct map_symbol ms = {
 		.map = map,
 		.sym = sym,
@@ -834,6 +834,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 	if (sym == NULL)
 		return -1;
 
+	size = symbol__size(sym);
+
 	if (map->dso->annotate_warned)
 		return -1;
 
-- 
1.7.1

