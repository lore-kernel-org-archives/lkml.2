Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab2LQNhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:37:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2LQNha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:37:30 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC 0/3] perf tool: Add non-architectural event aliases
Date: Mon, 17 Dec 2012 14:37:02 +0100
Message-Id: <1355751425-7993-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support to use non-architectural events in perf via name.

Attached patches:
  1/3 perf tool: Add '.' as part of the event 'name' token
  2/3 perf tool: Add support to include non architectural event aliases
  3/3 perf tool: Add non arch events for SandyBridge microarchitecture

Basically, the pmu alias code detects the architecture and tries
to find 'events' directory with non-architectural aliases.

For each non-architectural event there needs to be special file
containig the event definition using pmu 'format' style, like:

  $ cat arch/x86/events/intel/SandyBridge/DTLB_LOAD_MISSES.MISS_CAUSES_A_WALK 
  event=0x8,umask=0x1

Patch 3 contains part (not whole!) of aliases for SandyBridge microarch
(Intel naming style is used) and can be used like:

  $ perf record -e 'cpu/DTLB_LOAD_MISSES.MISS_CAUSES_A_WALK/' ls

The non-architectural event aliases could be part of the kernel
as well as architectural events, under some other 'events' sysfs
attribute.. I wasn't sure though.. looks like lot of perf data ;-)

any comments are welcome,
jirka

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/arch/x86/Makefile                       | 11 +++
 .../x86/events/intel/SandyBridge/ARITH.FPU_DIV_ACT |  1 +
 .../intel/SandyBridge/BR_INST_EXEC.ALL_BRANCHES    |  1 +
 .../x86/events/intel/SandyBridge/BR_INST_EXEC.COND |  1 +
 .../intel/SandyBridge/BR_INST_EXEC.DIRECT_JMP      |  1 +
 .../SandyBridge/BR_INST_EXEC.DIRECT_NEAR_CALL      |  1 +
 .../BR_INST_EXEC.INDIRECT_JMP_NON_CALL_RET         |  1 +
 .../SandyBridge/BR_INST_EXEC.INDIRECT_NEAR_CALL    |  1 +
 .../events/intel/SandyBridge/BR_INST_EXEC.NONTAKEN |  1 +
 .../intel/SandyBridge/BR_INST_EXEC.RETURN_NEAR     |  1 +
 .../events/intel/SandyBridge/BR_INST_EXEC.TAKEN    |  1 +
 .../intel/SandyBridge/BR_MISP_EXEC.ALL_BRANCHES    |  1 +
 .../x86/events/intel/SandyBridge/BR_MISP_EXEC.COND |  1 +
 .../SandyBridge/BR_MISP_EXEC.DIRECT_NEAR_CALL      |  1 +
 .../BR_MISP_EXEC.INDIRECT_JMP_NON_CALL_RET         |  1 +
 .../SandyBridge/BR_MISP_EXEC.INDIRECT_NEAR_CALL    |  1 +
 .../events/intel/SandyBridge/BR_MISP_EXEC.NONTAKEN |  1 +
 .../intel/SandyBridge/BR_MISP_EXEC.RETURN_NEAR     |  1 +
 .../events/intel/SandyBridge/BR_MISP_EXEC.TAKEN    |  1 +
 .../x86/events/intel/SandyBridge/CPL_CYCLES.RING0  |  1 +
 .../events/intel/SandyBridge/CPL_CYCLES.RING123    |  1 +
 .../SandyBridge/CPU_CLK_THREAD_UNHALTED.REF_XCLK   |  1 +
 .../intel/SandyBridge/CPU_CLK_UNHALTED.THREAD_P    |  1 +
 .../DTLB_LOAD_MISSES.MISS_CAUSES_A_WALK            |  1 +
 .../intel/SandyBridge/DTLB_LOAD_MISSES.STLB_HIT    |  1 +
 .../SandyBridge/DTLB_LOAD_MISSES.WALK_COMPLETED    |  1 +
 .../SandyBridge/DTLB_LOAD_MISSES.WALK_DURATION     |  1 +
 .../DTLB_STORE_MISSES.MISS_CAUSES_A_WALK           |  1 +
 .../intel/SandyBridge/DTLB_STORE_MISSES.STLB_HIT   |  1 +
 .../SandyBridge/DTLB_STORE_MISSES.WALK_COMPLETED   |  1 +
 .../SandyBridge/DTLB_STORE_MISSES.WALK_DURATION    |  1 +
 .../FP_COMP_OPS_EXE.SSE_FP_PACKED_DOUBLE           |  1 +
 .../FP_COMP_OPS_EXE.SSE_FP_SCALAR_SINGLE           |  1 +
 .../SandyBridge/FP_COMP_OPS_EXE.SSE_PACKED_SINGLE  |  1 +
 .../SandyBridge/FP_COMP_OPS_EXE.SSE_SCALAR_DOUBLE  |  1 +
 .../events/intel/SandyBridge/FP_COMP_OPS_EXE.X87   |  1 +
 .../events/intel/SandyBridge/HW_PRE_REQ.DL1_MISS   |  1 +
 .../x86/events/intel/SandyBridge/ICACHE.MISSES     |  1 +
 .../arch/x86/events/intel/SandyBridge/IDQ.DSB_UOPS |  1 +
 .../arch/x86/events/intel/SandyBridge/IDQ.EMPTY    |  1 +
 .../x86/events/intel/SandyBridge/IDQ.MITE_UOPS     |  1 +
 .../x86/events/intel/SandyBridge/IDQ.MS_DSB_UOPS   |  1 +
 .../x86/events/intel/SandyBridge/IDQ.MS_MITE_UOPS  |  1 +
 .../arch/x86/events/intel/SandyBridge/IDQ.MS_UOPS  |  1 +
 .../intel/SandyBridge/IDQ_UOPS_NOT_DELIVERED.CORE  |  1 +
 .../x86/events/intel/SandyBridge/ILD_STALL.IQ_FULL |  1 +
 .../x86/events/intel/SandyBridge/ILD_STALL.LCP     |  1 +
 .../intel/SandyBridge/INSTS_WRITTEN_TO_IQ.INSTS    |  1 +
 .../intel/SandyBridge/INT_MISC.RAT_STALL_CYCLES    |  1 +
 .../intel/SandyBridge/INT_MISC.RECOVERY_CYCLES     |  1 +
 .../SandyBridge/ITLB_MISSES.MISS_CAUSES_A_WALK     |  1 +
 .../events/intel/SandyBridge/ITLB_MISSES.STLB_HIT  |  1 +
 .../intel/SandyBridge/ITLB_MISSES.WALK_COMPLETED   |  1 +
 .../intel/SandyBridge/ITLB_MISSES.WALK_DURATION    |  1 +
 .../events/intel/SandyBridge/L1D.ALLOCATED_IN_M    |  1 +
 .../events/intel/SandyBridge/L1D.ALL_M_REPLACEMENT |  1 +
 .../arch/x86/events/intel/SandyBridge/L1D.EVICTION |  1 +
 .../x86/events/intel/SandyBridge/L1D.REPLACEMENT   |  1 +
 .../events/intel/SandyBridge/L1D_PEND_MISS.PENDING |  1 +
 .../events/intel/SandyBridge/L2_L1D_WB_RQSTS.ALL   |  1 +
 .../events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_E |  1 +
 .../events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_M |  1 +
 .../events/intel/SandyBridge/L2_L1D_WB_RQSTS.HIT_S |  1 +
 .../events/intel/SandyBridge/L2_L1D_WB_RQSTS.MISS  |  1 +
 .../events/intel/SandyBridge/L2_RQSTS.ALL_CODE_RD  |  1 +
 .../intel/SandyBridge/L2_RQSTS.ALL_DEMAND_DATA_RD  |  1 +
 .../x86/events/intel/SandyBridge/L2_RQSTS.ALL_PF   |  1 +
 .../x86/events/intel/SandyBridge/L2_RQSTS.ALL_RFO  |  1 +
 .../events/intel/SandyBridge/L2_RQSTS.CODE_RD_HIT  |  1 +
 .../events/intel/SandyBridge/L2_RQSTS.CODE_RD_MISS |  1 +
 .../intel/SandyBridge/L2_RQSTS.DEMAND_DATA_RD_HIT  |  1 +
 .../x86/events/intel/SandyBridge/L2_RQSTS.PF_HIT   |  1 +
 .../x86/events/intel/SandyBridge/L2_RQSTS.PF_MISS  |  1 +
 .../x86/events/intel/SandyBridge/L2_RQSTS.RFO_HITS |  1 +
 .../x86/events/intel/SandyBridge/L2_RQSTS.RFO_MISS |  1 +
 .../intel/SandyBridge/L2_STORE_LOCK_RQSTS.ALL      |  1 +
 .../intel/SandyBridge/L2_STORE_LOCK_RQSTS.HIT_E    |  1 +
 .../intel/SandyBridge/L2_STORE_LOCK_RQSTS.HIT_M    |  1 +
 .../intel/SandyBridge/L2_STORE_LOCK_RQSTS.MISS     |  1 +
 .../events/intel/SandyBridge/LD_BLOCKS.ALL_BLOCK   |  1 +
 .../intel/SandyBridge/LD_BLOCKS.DATA_UNKNOWN       |  1 +
 .../x86/events/intel/SandyBridge/LD_BLOCKS.NO_SR   |  1 +
 .../intel/SandyBridge/LD_BLOCKS.STORE_FORWARD      |  1 +
 .../SandyBridge/LD_BLOCKS_PARTIAL.ADDRESS_ALIAS    |  1 +
 .../SandyBridge/LD_BLOCKS_PARTIAL.ALL_STA_BLOCK    |  1 +
 .../events/intel/SandyBridge/LOAD_HIT_PRE.HW_PF    |  1 +
 .../events/intel/SandyBridge/LOAD_HIT_PRE.SW_PF    |  1 +
 .../SandyBridge/LOCK_CYCLES.CACHE_LOCK_DURATION    |  1 +
 .../LOCK_CYCLES.SPLIT_LOCK_UC_LOCK_DURATION        |  1 +
 .../intel/SandyBridge/LONGEST_LAT_CACHE.MISS       |  1 +
 .../intel/SandyBridge/LONGEST_LAT_CACHE.REFERENCE  |  1 +
 .../intel/SandyBridge/MISALIGN_MEM_REF.LOADS       |  1 +
 .../intel/SandyBridge/MISALIGN_MEM_REF.STORES      |  1 +
 .../OFFCORE_REQUESTS_OUTSTANDING.ALL_DATA_RD       |  1 +
 .../OFFCORE_REQUESTS_OUTSTANDING.DEMAND_DATA_RD    |  1 +
 .../OFFCORE_REQUESTS_OUTSTANDING.DEMAND_RFO        |  1 +
 .../SandyBridge/PARTIAL_RAT_STALLS.FLAGS_MERGE_UOP |  1 +
 .../SandyBridge/PARTIAL_RAT_STALLS.MUL_SINGLE_UOP  |  1 +
 .../SandyBridge/PARTIAL_RAT_STALLS.SLOW_LEA_WINDOW |  1 +
 .../SandyBridge/RESOURCE_STALLS2.ALL_FL_EMPTY      |  1 +
 .../SandyBridge/RESOURCE_STALLS2.ALL_PRF_CONTROL   |  1 +
 .../intel/SandyBridge/RESOURCE_STALLS2.BOB_FULL    |  1 +
 .../intel/SandyBridge/RESOURCE_STALLS2.OOO_RSRC    |  1 +
 .../intel/SandyBridge/RS_EVENTS.EMPTY_CYCLES       |  1 +
 .../intel/SandyBridge/SIMD_FP_256.PACKED_DOUBLE    |  1 +
 .../intel/SandyBridge/SIMD_FP_256.PACKED_SINGLE    |  1 +
 .../x86/events/intel/SandyBridge/UOPS_ISSUED.ANY   |  1 +
 tools/perf/arch/x86/util/pmu.c                     | 98 ++++++++++++++++++++++
 tools/perf/util/parse-events.l                     |  4 +-
 tools/perf/util/pmu.c                              | 18 ++--
 tools/perf/util/pmu.h                              |  4 +
 111 files changed, 233 insertions(+), 8 deletions(-)
