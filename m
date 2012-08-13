Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab2HMSpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:45:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:45048 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab2HMShq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:37:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 23/38] perf symbols: Remove unused function map__objdump_2ip
Date: Mon, 13 Aug 2012 15:37:04 -0300
Message-Id: <1344883039-13495-24-git-send-email-acme@infradead.org>
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

map__objdump_2ip was introduced in:

ee11b90b12 perf top: Fix annotate for userspace

And it's last user removed in:

36532461a0 perf top: Ditch private annotation code, share perf annotate's

Remove it.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: David Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Hellsley <matthltc@us.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1344637382-22789-5-git-send-email-cody@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c |    8 --------
 tools/perf/util/map.h |    1 -
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 287cb34..7d37159 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -262,14 +262,6 @@ u64 map__rip_2objdump(struct map *map, u64 rip)
 	return addr;
 }
 
-u64 map__objdump_2ip(struct map *map, u64 addr)
-{
-	u64 ip = map->dso->adjust_symbols ?
-			addr :
-			map->unmap_ip(map, addr);	/* RIP -> IP */
-	return ip;
-}
-
 void map_groups__init(struct map_groups *mg)
 {
 	int i;
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index c98ab19..25ab4cd 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -104,7 +104,6 @@ static inline u64 identity__map_ip(struct map *map __used, u64 ip)
 
 /* rip/ip <-> addr suitable for passing to `objdump --start-address=` */
 u64 map__rip_2objdump(struct map *map, u64 rip);
-u64 map__objdump_2ip(struct map *map, u64 addr);
 
 struct symbol;
 
-- 
1.7.1

