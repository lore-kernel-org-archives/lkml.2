Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2JOFNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 01:13:35 -0400
Received: from science.horizon.com ([71.41.210.146]:25834 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751534Ab2JOFNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 01:13:34 -0400
Date: 15 Oct 2012 01:13:32 -0400
Message-ID: <20121015051332.13610.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: bp@alien8.de, ling.ma@intel.com
Subject: Re: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging instruction sequence and saving register
Cc: hpa@zytor.com, iant@google.com, konrad@kernel.org,
        linux-kernel@vger.kernel.org, linux@horizon.com, mingo@elte.hu,
        tglx@linutronix.de
In-Reply-To: <20121014105821.GB2165@liondog.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just for everyone's information, here's the updated benchmark code on
the same Phenom.  The REP MOVSQ code is indeed much faster.

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

                                   	copy_page_org	copy_page_new	REP MOVSQ
TPT: Len 4096, alignment  0/ 0:		708		758		611
TPT: Len 4096, alignment  0/ 0:		672		758		611
TPT: Len 4096, alignment  0/ 0:		708		758		611
TPT: Len 4096, alignment  0/ 0:		708		758		611
TPT: Len 4096, alignment  0/ 0:		708		758		611
                                   	copy_page_org	copy_page_new	REP MOVSQ
TPT: Len 4096, alignment  0/ 0:		694		759		611
TPT: Len 4096, alignment  0/ 0:		672		758		611
TPT: Len 4096, alignment  0/ 0:		708		758		611
TPT: Len 4096, alignment  0/ 0:		708		759		611
TPT: Len 4096, alignment  0/ 0:		708		757		611
                                   	copy_page_org	copy_page_new	REP MOVSQ
TPT: Len 4096, alignment  0/ 0:		697		758		611
TPT: Len 4096, alignment  0/ 0:		708		758		611
TPT: Len 4096, alignment  0/ 0:		708		758		611
TPT: Len 4096, alignment  0/ 0:		708		758		611
TPT: Len 4096, alignment  0/ 0:		708		757		611
                                   	copy_page_org	copy_page_new	REP MOVSQ
TPT: Len 4096, alignment  0/ 0:		703		758		612
TPT: Len 4096, alignment  0/ 0:		709		758		611
TPT: Len 4096, alignment  0/ 0:		709		757		611
TPT: Len 4096, alignment  0/ 0:		709		759		613
TPT: Len 4096, alignment  0/ 0:		709		759		611
                                   	copy_page_org	copy_page_new	REP MOVSQ
TPT: Len 4096, alignment  0/ 0:		669		758		613
TPT: Len 4096, alignment  0/ 0:		671		758		611
TPT: Len 4096, alignment  0/ 0:		708		758		611
TPT: Len 4096, alignment  0/ 0:		708		758		611
TPT: Len 4096, alignment  0/ 0:		708		758		613
                                   	copy_page_org	copy_page_new	REP MOVSQ
TPT: Len 4096, alignment  0/ 0:		679		758		612
TPT: Len 4096, alignment  0/ 0:		671		758		612
TPT: Len 4096, alignment  0/ 0:		684		759		612
TPT: Len 4096, alignment  0/ 0:		709		759		613
TPT: Len 4096, alignment  0/ 0:		709		759		611
                                   	copy_page_org	copy_page_new	REP MOVSQ
TPT: Len 4096, alignment  0/ 0:		682		758		612
TPT: Len 4096, alignment  0/ 0:		673		758		613
TPT: Len 4096, alignment  0/ 0:		704		759		613
TPT: Len 4096, alignment  0/ 0:		709		758		613
TPT: Len 4096, alignment  0/ 0:		709		758		611
                                   	copy_page_org	copy_page_new	REP MOVSQ
TPT: Len 4096, alignment  0/ 0:		669		759		611
TPT: Len 4096, alignment  0/ 0:		671		759		611
TPT: Len 4096, alignment  0/ 0:		709		759		613
TPT: Len 4096, alignment  0/ 0:		709		759		613
TPT: Len 4096, alignment  0/ 0:		708		759		613
                                   	copy_page_org	copy_page_new	REP MOVSQ
TPT: Len 4096, alignment  0/ 0:		668		759		612
TPT: Len 4096, alignment  0/ 0:		709		759		612
TPT: Len 4096, alignment  0/ 0:		709		759		612
TPT: Len 4096, alignment  0/ 0:		709		759		612
TPT: Len 4096, alignment  0/ 0:		709		759		612
                                   	copy_page_org	copy_page_new	REP MOVSQ
TPT: Len 4096, alignment  0/ 0:		694		758		611
TPT: Len 4096, alignment  0/ 0:		671		759		611
TPT: Len 4096, alignment  0/ 0:		708		759		611
TPT: Len 4096, alignment  0/ 0:		708		759		611
TPT: Len 4096, alignment  0/ 0:		708		759		613
