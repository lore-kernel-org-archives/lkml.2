Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab1FQNhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:37:19 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:33498
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755414Ab1FQNhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:37:08 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMXSHP-01-0NZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/5] perf, core: Introduce attrs to count in either host or guest mode
Date: Fri, 17 Jun 2011 15:37:30 +0200
Message-ID: <1308317854-27398-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
References: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two new attributes exclude_guest and exclude_host can
bes used by user-space to tell the kernel to setup
performance counter to either only count while the CPU is in
guest or in host mode.
An additional check is also introduced to make sure
user-space does not try to exclude guest and host mode from
counting.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/perf_event.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e0786e3..9a27b5d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -219,7 +219,10 @@ struct perf_event_attr {
 				mmap_data      :  1, /* non-exec mmap data    */
 				sample_id_all  :  1, /* sample_type all events */
 
-				__reserved_1   : 45;
+				exclude_host   :  1, /* don't count in host   */
+				exclude_guest  :  1, /* don't count in guest  */
+
+				__reserved_1   : 43;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
-- 
1.7.4.1


