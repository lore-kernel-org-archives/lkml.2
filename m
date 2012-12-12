Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab2LLQb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:31:27 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:13993
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754414Ab2LLQbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:31:23 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1155h)
X-WSS-ID: 0MEXF7Z-01-ELT-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 4/5] perf tools: Add breakpoint address mask syntax to perf list and documentation
Date: Wed, 12 Dec 2012 10:30:42 -0600
Message-ID: <1355329843-25842-5-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355329843-25842-1-git-send-email-jacob.shin@amd.com>
References: <1355329843-25842-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>


Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 tools/perf/Documentation/perf-record.txt |   14 ++++++++++----
 tools/perf/util/parse-events.c           |    2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index b38a1f9..a221a25 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -33,13 +33,19 @@ OPTIONS
         - a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
 	  hexadecimal event descriptor.
 
-        - a hardware breakpoint event in the form of '\mem:addr[:access]'
-          where addr is the address in memory you want to break in.
-          Access is the memory access type (read, write, execute) it can
-          be passed as follows: '\mem:addr[:[r][w][x]]'.
+        - a hardware breakpoint event in the form of
+          '\mem:addr[:access][:addr_mask]' where addr is the address in
+          memory you want to break in. Access is the memory access type (read,
+          write, execute) it can be passed as follows: '\mem:addr[:[r][w][x]]'.
+          addr_mask is the "don't care" bit mask to further qualify the given
+          addr, to break in on accesses to an address range.
+
           If you want to profile read-write accesses in 0x1000, just set
           'mem:0x1000:rw'.
 
+          If you want to profile write accesses in [0x1000 ~ 0x1010), just set
+          'mem:0x1000:w:0xf'. (Only supported on some hardware)
+
 --filter=<filter>::
         Event filter.
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 2679e48..6443735 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1114,7 +1114,7 @@ void print_events(const char *event_glob, bool name_only)
 		printf("\n");
 
 		printf("  %-50s [%s]\n",
-		       "mem:<addr>[:access]",
+		       "mem:<addr>[:access][:addr_mask]",
 			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
 		printf("\n");
 	}
-- 
1.7.9.5


