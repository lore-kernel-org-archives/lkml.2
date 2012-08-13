Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2HMSiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:38:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:44963 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab2HMShj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:37:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/38] perf symbols: Only un-prelink non-zero symbols
Date: Mon, 13 Aug 2012 15:37:03 -0300
Message-Id: <1344883039-13495-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344883039-13495-1-git-send-email-acme@infradead.org>
References: <1344883039-13495-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

Prelink only adjusts the addresses of non-zero symbols. Do the same when we
reverse the adjustments.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Hellsley <matthltc@us.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1344637382-22789-4-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 9ca89f8..e037609 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -717,7 +717,7 @@ int dso__load_sym(struct dso *dso, struct map *map, const char *name, int fd,
 			goto new_symbol;
 		}
 
-		if (curr_dso->adjust_symbols) {
+		if (curr_dso->adjust_symbols && sym.st_value) {
 			pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
 				  "sh_addr: %#" PRIx64 " sh_offset: %#" PRIx64 "\n", __func__,
 				  (u64)sym.st_value, (u64)shdr.sh_addr,
-- 
1.7.1

