Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab1C0UrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 16:47:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47815 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1C0UqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 16:46:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=EpfmErqCAOvPrywMyMzSTLkYvsXL0sTL4ZFMYJxB2T1k1RJkqz82HRf0893qXPTUXl
         x0JOLSDWjtwnFTYQ7rsI8HIo0V3GEvl2EumMubMTRRTOKvvBUSUOJlcqsib0wtTuBF1A
         /Pk2xKB7dSAt9gLlPyyIeat/o4OsQfuHn4ahQ=
Message-ID: <4D8FA213.5050108@openvz.org>
Date: Mon, 28 Mar 2011 00:46:11 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH -tip] perf, x86: P4 PMU - Restore code alignment
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No change on functional level. This code style nit escaped
me somewhere at very first commits.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Found it while were at perf-p4 code for nmi-watchdog reason
so decided to fix it just to not forget after. Note the other code
already aligned this way so this snippet stabs my eyes.

 arch/x86/kernel/cpu/perf_event_p4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index c2520e1..8ff882f 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -468,7 +468,7 @@ static struct p4_event_bind p4_event_bind_map[] = {
 		.opcode		= P4_OPCODE(P4_EVENT_MISPRED_BRANCH_RETIRED),
 		.escr_msr	= { MSR_P4_CRU_ESCR0, MSR_P4_CRU_ESCR1 },
 		.escr_emask	=
-		P4_ESCR_EMASK_BIT(P4_EVENT_MISPRED_BRANCH_RETIRED, NBOGUS),
+			P4_ESCR_EMASK_BIT(P4_EVENT_MISPRED_BRANCH_RETIRED, NBOGUS),
 		.cntr		= { {12, 13, 16}, {14, 15, 17} },
 	},
 	[P4_EVENT_X87_ASSIST] = {
-- 
    Cyrill
