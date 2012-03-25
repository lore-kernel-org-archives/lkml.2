Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2CYU20 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 16:28:26 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51480 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab2CYU2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 16:28:24 -0400
Date: Sun, 25 Mar 2012 16:28:22 -0400 (EDT)
Message-Id: <20120325.162822.2267799792062571623.davem@davemloft.net>
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] perf: Handle NULL dso in dso__name_len
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 25 Mar 2012 13:28:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We should use "[unknown]" in this case, in concert with the code in
_hist_entry__dso_snprintf().

Otherwise we'll crash when recomputing the histogram column lengths in
hists__calc_col_len().

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 tools/perf/util/symbol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 5dd83c3..472b467 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -51,6 +51,8 @@ struct symbol_conf symbol_conf = {
 
 int dso__name_len(const struct dso *dso)
 {
+	if (!dso)
+		return strlen("[unknown]");
 	if (verbose)
 		return dso->long_name_len;
 
-- 
1.7.9.1

