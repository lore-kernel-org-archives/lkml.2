Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab0HRHpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 03:45:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:9784 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab0HRHps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 03:45:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,226,1280732400"; 
   d="scan'208";a="313860653"
Subject: libpfm4 faults on P4 machine
From: Lin Ming <ming.m.lin@intel.com>
To: Stephane Eranian <eranian@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Cc: perfmon2-devel@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 15:46:01 +0800
Message-ID: <1282117561.11858.54.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On P4 machine, intel_x86_arch_support.get_event_info(...) faults because
intel_x86_arch_support.pe is NULL.

intel_x86_arch_support.pe is set at run time, but P4 does not have arch
event support, so intel_x86_arch_support.pe is always NULL.

#gdb libpfm4/examples/check_events

Program received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0xb785caf0 (LWP 3950)]
0x0804d74b in pfm_intel_x86_get_event_info (this=0x81c5f80, idx=0, info=0xbff45f14)
    at pfmlib_intel_x86.c:667
667		info->desc  = pe[idx].desc;
(gdb) bt
#0  0x0804d74b in pfm_intel_x86_get_event_info (this=0x81c5f80, idx=0, info=0xbff45f14)
    at pfmlib_intel_x86.c:667
#1  0x08049cd3 in pfmlib_parse_event (event=0x804fb7b "PERF_COUNT_HW_CPU_CYCLES", d=0xbff45f7c)
    at pfmlib_common.c:676
#2  0x08049f3f in pfm_get_event_encoding (str=0x804fb7b "PERF_COUNT_HW_CPU_CYCLES", dfl_plm=8, 
    fstr=0xbff464d4, idx=0xbff464c8, codes=0xbff464d0, count=0xbff464cc) at pfmlib_common.c:877
#3  0x08048dc1 in main (argc=<value optimized out>, argv=0xbff46584) at check_events.c:118
(gdb) list
662	
663		/*
664		 * pmu and idx filled out by caller
665		 */
666		info->name  = pe[idx].name;
667		info->desc  = pe[idx].desc;
668		info->code  = pe[idx].code;
669		info->equiv = pe[idx].equiv;
670	
671		/* unit masks + modifiers */
(gdb)

Any fix?

Lin Ming

