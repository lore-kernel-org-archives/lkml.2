Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2CaHpT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 03:45:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54822 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab2CaHpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 03:45:15 -0400
Date: Sat, 31 Mar 2012 00:45:04 -0700
From: tip-bot for David Miller <davem@davemloft.net>
Message-ID: <tip-f40a06339fe6f4809b5851a74aae2c0dc4386e1b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, davem@davemloft.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <20120325.162812.59519424882536855.davem@davemloft.net>
References: <20120325.162812.59519424882536855.davem@davemloft.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf annotate:
  addr2line wants addresses in same format as objdump
Git-Commit-ID: f40a06339fe6f4809b5851a74aae2c0dc4386e1b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 31 Mar 2012 00:45:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f40a06339fe6f4809b5851a74aae2c0dc4386e1b
Gitweb:     http://git.kernel.org/tip/f40a06339fe6f4809b5851a74aae2c0dc4386e1b
Author:     David Miller <davem@davemloft.net>
AuthorDate: Sun, 25 Mar 2012 16:28:12 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 28 Mar 2012 12:06:24 -0300

perf annotate: addr2line wants addresses in same format as objdump

Therefore, in symbol__get_source_line(), use map__rip_2objdump
instead of calling map->unmap_ip() unconditionally.

Link: http://lkml.kernel.org/r/20120325.162812.59519424882536855.davem@davemloft.net
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index e5a462f..31ba2a2 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -408,7 +408,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	if (!notes->src->lines)
 		return -1;
 
-	start = map->unmap_ip(map, sym->start);
+	start = map__rip_2objdump(map, sym->start);
 
 	for (i = 0; i < len; i++) {
 		char *path = NULL;
