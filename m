Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab2HUP6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:58:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60477 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2HUP6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:58:17 -0400
Date: Tue, 21 Aug 2012 08:57:48 -0700
From: tip-bot for Cody P Schafer <cody@linux.vnet.ibm.com>
Message-ID: <tip-0f75a710dfd8fd5cd9e558e3f26c474c8fa63e3c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, matthltc@us.ibm.com,
        dave@linux.vnet.ibm.com, namhyung@kernel.org,
        sukadev@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        a.p.zijlstra@chello.nl, dave@linux.vnet.ibm.com, matthltc@us.ibm.com,
        namhyung@kernel.org, tglx@linutronix.de, sukadev@linux.vnet.ibm.com
In-Reply-To: <1344637382-22789-5-git-send-email-cody@linux.vnet.ibm.com>
References: <1344637382-22789-5-git-send-email-cody@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Remove unused function map__objdump_2ip
Git-Commit-ID: 0f75a710dfd8fd5cd9e558e3f26c474c8fa63e3c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:57:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f75a710dfd8fd5cd9e558e3f26c474c8fa63e3c
Gitweb:     http://git.kernel.org/tip/0f75a710dfd8fd5cd9e558e3f26c474c8fa63e3c
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Fri, 10 Aug 2012 15:22:50 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Aug 2012 12:55:09 -0300

perf symbols: Remove unused function map__objdump_2ip

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
 
