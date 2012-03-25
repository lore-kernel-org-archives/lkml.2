Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab2CYU2d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 16:28:33 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51483 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab2CYU2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 16:28:30 -0400
Date: Sun, 25 Mar 2012 16:28:28 -0400 (EDT)
Message-Id: <20120325.162828.1850698867642275016.davem@davemloft.net>
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] perf: Fix build error with -Werror in
 print_event_desc()
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 25 Mar 2012 13:28:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'msz' should not be cast to ssize_t when comparing it to
'sz'.  'sz' is a u32 and thus unsigned, just like the type
of 'msz' which is plain size_t.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index fcd9cf3..4c7c2d7 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1177,7 +1177,7 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 		goto error;
 
 	msz = sizeof(attr);
-	if (sz < (ssize_t)msz)
+	if (sz < msz)
 		msz = sz;
 
 	for (i = 0 ; i < nre; i++) {
-- 
1.7.9.1

