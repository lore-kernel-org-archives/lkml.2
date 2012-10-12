Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2JLVC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:02:59 -0400
Received: from science.horizon.com ([71.41.210.146]:56261 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751848Ab2JLVC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:02:58 -0400
Date: 12 Oct 2012 17:02:57 -0400
Message-ID: <20121012210257.11451.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging instruction sequence and saving register
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some Phenom results for that benchmark.  The average time
increases from 700 to 760 cycles (+8.6%).

vendor_id       : AuthenticAMD
cpu family      : 16
model           : 2
model name      : AMD Phenom(tm) 9850 Quad-Core Processor
stepping        : 3
microcode       : 0x1000083
cpu MHz         : 2500.210
cache size      : 512 KB
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs hw_pstate npt lbrv svm_lock
bogomips        : 5000.42
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64

                       	copy_page_org	copy_page_new	
TPT: Len 4096, alignment  0/ 0:	678	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
                       	copy_page_org	copy_page_new	
TPT: Len 4096, alignment  0/ 0:	667	760
TPT: Len 4096, alignment  0/ 0:	673	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
                       	copy_page_org	copy_page_new	
TPT: Len 4096, alignment  0/ 0:	667	760
TPT: Len 4096, alignment  0/ 0:	673	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
                       	copy_page_org	copy_page_new	
TPT: Len 4096, alignment  0/ 0:	671	760
TPT: Len 4096, alignment  0/ 0:	673	760
TPT: Len 4096, alignment  0/ 0:	671	760
TPT: Len 4096, alignment  0/ 0:	709	760
TPT: Len 4096, alignment  0/ 0:	708	760
                       	copy_page_org	copy_page_new	
TPT: Len 4096, alignment  0/ 0:	667	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
                       	copy_page_org	copy_page_new	
TPT: Len 4096, alignment  0/ 0:	671	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
                       	copy_page_org	copy_page_new	
TPT: Len 4096, alignment  0/ 0:	678	760
TPT: Len 4096, alignment  0/ 0:	709	758
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	709	759
TPT: Len 4096, alignment  0/ 0:	710	760
                       	copy_page_org	copy_page_new	
TPT: Len 4096, alignment  0/ 0:	680	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
                       	copy_page_org	copy_page_new	
TPT: Len 4096, alignment  0/ 0:	667	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	709	760
TPT: Len 4096, alignment  0/ 0:	709	759
TPT: Len 4096, alignment  0/ 0:	710	760
                       	copy_page_org	copy_page_new	
TPT: Len 4096, alignment  0/ 0:	678	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
TPT: Len 4096, alignment  0/ 0:	710	760
