Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab1EJOfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:35:51 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.181]:32062
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932653Ab1EJOfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:35:44 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKZHVB-02-2YA-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/3] perf, tools: Add support for guest/host-only profiling
Date: Tue, 10 May 2011 16:35:32 +0200
Message-ID: <1305038132-5080-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
References: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To restrict a counter to either host or guest mode this
patch introduces two new event modifiers: G and H.
With G the counter is configured in guest-only mode and with
H in host-only mode.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 tools/perf/util/parse-events.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 952b4ae..21039d2 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -723,7 +723,7 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
 	int exclude = 0;
-	int eu = 0, ek = 0, eh = 0, precise = 0;
+	int eu = 0, ek = 0, eh = 0, eg = 0, ehst = 0, precise = 0;
 
 	if (*str++ != ':')
 		return 0;
@@ -740,6 +740,12 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 			if (!exclude)
 				exclude = eu = ek = eh = 1;
 			eh = 0;
+		} else if (*str == 'G') {
+			eg   = 0;
+			ehst = 1;
+		} else if (*str == 'H') {
+			eg   = 1;
+			ehst = 0;
 		} else if (*str == 'p') {
 			precise++;
 		} else
@@ -753,6 +759,8 @@ parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 		attr->exclude_kernel = ek;
 		attr->exclude_hv     = eh;
 		attr->precise_ip     = precise;
+		attr->exclude_host   = ehst;
+		attr->exclude_guest  = eg;
 		return 1;
 	}
 	return 0;
-- 
1.7.4.1


