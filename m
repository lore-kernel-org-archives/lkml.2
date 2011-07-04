Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab1GDH4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:56:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:47700 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab1GDH4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 03:56:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,471,1304319600"; 
   d="scan'208";a="23490023"
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] perf: memory load/store events generalization
Date: Mon,  4 Jul 2011 08:02:01 +0000
Message-Id: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all

Intel PMU provides 2 facilities to monitor memory operation: load latency and precise store.
This patchset tries to generalize memory load/store events.
So other arches may also add such features.

A new sub-command "mem" is added,

$ perf mem

 usage: perf mem [<options>] {record <command> |report}

    -t, --type <type>     memory operations(load/store)
    -L, --latency <n>     latency to sample(only for load op)

$ perf mem -t load record make -j8

<building kernel ..., monitoring memory load opeartion>

$ perf mem -t load report

Memory load operation statistics
================================
                      L1-local: total latency=   28027, count=    3355(avg=8)
                      L2-snoop: total latency=    1430, count=      29(avg=49)
                      L2-local: total latency=     124, count=       8(avg=15)
             L3-snoop, found M: total latency=     452, count=       4(avg=113)
          L3-snoop, found no M: total latency=       0, count=       0(avg=0)
L3-snoop, no coherency actions: total latency=     875, count=      18(avg=48)
        L3-miss, snoop, shared: total latency=       0, count=       0(avg=0)
     L3-miss, local, exclusive: total latency=       0, count=       0(avg=0)
        L3-miss, local, shared: total latency=       0, count=       0(avg=0)
    L3-miss, remote, exclusive: total latency=       0, count=       0(avg=0)
       L3-miss, remote, shared: total latency=       0, count=       0(avg=0)
                    Unknown L3: total latency=       0, count=       0(avg=0)
                            IO: total latency=       0, count=       0(avg=0)
                      Uncached: total latency=     464, count=      30(avg=15)

$ perf mem -t store record make -j8

<building kernel ..., monitoring memory store opeartion>

$ perf mem -t store report

Memory store operation statistics
=================================
                data-cache hit:     8138
               data-cache miss:        0
                      STLB hit:     8138
                     STLB miss:        0
                 Locked access:        0
               Unlocked access:     8138

Any comment is appreciated.

Thanks,
Lin Ming
