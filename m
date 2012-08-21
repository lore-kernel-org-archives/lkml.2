Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690Ab2HUP5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:57:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60462 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2HUP5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:57:36 -0400
Date: Tue, 21 Aug 2012 08:56:52 -0700
From: tip-bot for Cody P Schafer <cody@linux.vnet.ibm.com>
Message-ID: <tip-8db24c70ab43a4dd38c39b0b0cb4d4874257de55@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, matthltc@us.ibm.com,
        dave@linux.vnet.ibm.com, namhyung@kernel.org,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, dave@linux.vnet.ibm.com, matthltc@us.ibm.com,
        namhyung@kernel.org, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <1344637382-22789-4-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-4-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Only un-prelink non-zero symbols
Git-Commit-ID: 8db24c70ab43a4dd38c39b0b0cb4d4874257de55
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:56:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8db24c70ab43a4dd38c39b0b0cb4d4874257de55
Gitweb:     http://git.kernel.org/tip/8db24c70ab43a4dd38c39b0b0cb4d4874257de55
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Fri, 10 Aug 2012 15:22:49 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Aug 2012 12:54:06 -0300

perf symbols: Only un-prelink non-zero symbols

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
