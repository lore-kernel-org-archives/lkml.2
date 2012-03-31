Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab2CaHno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 03:43:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54785 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2CaHnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 03:43:40 -0400
Date: Sat, 31 Mar 2012 00:43:29 -0700
From: tip-bot for David Miller <davem@davemloft.net>
Message-ID: <tip-1e2dd2f73afdc810cc7400b7036232fbdc416eeb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, davem@davemloft.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <20120325.162822.2267799792062571623.davem@davemloft.net>
References: <20120325.162822.2267799792062571623.davem@davemloft.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Handle NULL dso in dso__name_len
Git-Commit-ID: 1e2dd2f73afdc810cc7400b7036232fbdc416eeb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 31 Mar 2012 00:43:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e2dd2f73afdc810cc7400b7036232fbdc416eeb
Gitweb:     http://git.kernel.org/tip/1e2dd2f73afdc810cc7400b7036232fbdc416eeb
Author:     David Miller <davem@davemloft.net>
AuthorDate: Sun, 25 Mar 2012 16:28:22 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 27 Mar 2012 11:00:58 -0300

perf symbols: Handle NULL dso in dso__name_len

We should use "[unknown]" in this case, in concert with the code in
_hist_entry__dso_snprintf().

Otherwise we'll crash when recomputing the histogram column lengths in
hists__calc_col_len().

Signed-off-by: David S. Miller <davem@davemloft.net>
Link: http://lkml.kernel.org/r/20120325.162822.2267799792062571623.davem@davemloft.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d9e995b..c0a028c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -50,6 +50,8 @@ struct symbol_conf symbol_conf = {
 
 int dso__name_len(const struct dso *dso)
 {
+	if (!dso)
+		return strlen("[unknown]");
 	if (verbose)
 		return dso->long_name_len;
 
