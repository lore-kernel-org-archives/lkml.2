Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301Ab2HJW0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:26:08 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:39304 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760238Ab2HJWXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:23:40 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 03/16] perf symbol: only un-prelink non-zero symbols
Date: Fri, 10 Aug 2012 15:22:49 -0700
Message-Id: <1344637382-22789-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081022-7408-0000-0000-000007866613
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prelink only adjusts the addresses of non-zero symbols. Do the same when
we reverse the adjustments.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/symbol-elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
1.7.11.3

