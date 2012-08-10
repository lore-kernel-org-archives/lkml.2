Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283Ab2HJW1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 18:27:10 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46369 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760185Ab2HJWXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 18:23:31 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Matt Hellsley <matthltc@us.ibm.com>,
        David Hansen <dave@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 04/16] perf utils: remove unused function map__objdump_2ip
Date: Fri, 10 Aug 2012 15:22:50 -0700
Message-Id: <1344637382-22789-5-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081022-6078-0000-0000-00000E20A669
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

map__objdump_2ip was introduced in:
ee11b90b12 perf top: Fix annotate for userspace

And it's last user removed in:
36532461a0 perf top: Ditch private annotation code, share perf annotate's

Remove it.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/map.c | 8 --------
 tools/perf/util/map.h | 1 -
 2 files changed, 9 deletions(-)

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
index 1e183d1..6c38d9e 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -104,7 +104,6 @@ static inline u64 identity__map_ip(struct map *map __used, u64 ip)
 
 /* rip/ip <-> addr suitable for passing to `objdump --start-address=` */
 u64 map__rip_2objdump(struct map *map, u64 rip);
-u64 map__objdump_2ip(struct map *map, u64 addr);
 
 struct symbol;
 
-- 
1.7.11.3

