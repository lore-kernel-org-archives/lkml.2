Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab2E0BIH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:08:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762Ab2E0BH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:07:59 -0400
Message-Id: <20120527010427.577508540@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:04:50 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [ 27/94] perf/x86: Update event scheduling constraints for AMD family 15h models
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <robert.richter@amd.com>

commit 5bcdf5e4fee3c45e1281c25e4941f2163cb28c65 upstream.

This update is for newer family 15h cpu models from 0x02 to 0x1f.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1337337642-1621-1-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/perf_event_amd.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -473,6 +473,7 @@ static __initconst const struct x86_pmu
  * 0x023	DE	PERF_CTL[2:0]
  * 0x02D	LS	PERF_CTL[3]
  * 0x02E	LS	PERF_CTL[3,0]
+ * 0x031	LS	PERF_CTL[2:0] (**)
  * 0x043	CU	PERF_CTL[2:0]
  * 0x045	CU	PERF_CTL[2:0]
  * 0x046	CU	PERF_CTL[2:0]
@@ -486,10 +487,12 @@ static __initconst const struct x86_pmu
  * 0x0DD	LS	PERF_CTL[5:0]
  * 0x0DE	LS	PERF_CTL[5:0]
  * 0x0DF	LS	PERF_CTL[5:0]
+ * 0x1C0	EX	PERF_CTL[5:3]
  * 0x1D6	EX	PERF_CTL[5:0]
  * 0x1D8	EX	PERF_CTL[5:0]
  *
- * (*) depending on the umask all FPU counters may be used
+ * (*)  depending on the umask all FPU counters may be used
+ * (**) only one unitmask enabled at a time
  */
 
 static struct event_constraint amd_f15_PMC0  = EVENT_CONSTRAINT(0, 0x01, 0);
@@ -539,6 +542,12 @@ amd_get_event_constraints_f15h(struct cp
 			return &amd_f15_PMC3;
 		case 0x02E:
 			return &amd_f15_PMC30;
+		case 0x031:
+			if (hweight_long(hwc->config & ARCH_PERFMON_EVENTSEL_UMASK) <= 1)
+				return &amd_f15_PMC20;
+			return &emptyconstraint;
+		case 0x1C0:
+			return &amd_f15_PMC53;
 		default:
 			return &amd_f15_PMC50;
 		}


