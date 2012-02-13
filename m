Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab2BMJvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:51:00 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:55344 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619Ab2BMJu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:50:59 -0500
Date: Mon, 13 Feb 2012 11:50:57 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Grant Likely <grant.likely@secretlab.ca>
cc: Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <20120213080618.GA11077@ponder.secretlab.ca>
Message-ID: <alpine.SOC.1.00.1202131145590.1488@math.ut.ee>
References: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee> <20120213080618.GA11077@ponder.secretlab.ca>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Another variation of the crash, without the patch, but backtrace is 
slightly different (strlen) - maybe fixed by the patch, maybe not.

   0.000000] Unable to handle kernel NULL pointer dereference
[    0.000000] tsk->{mm,active_mm}->context = 0000000000000000
[    0.000000] tsk->{mm,active_mm}->pgd = fffff800604ea3a8
[    0.000000]               \|/ ____ \|/
[    0.000000]               "@'/ .. \`@"
[    0.000000]               /_| \__/ |_\
[    0.000000]                  \__U_/
[    0.000000] swapper(0): Oops [#1]
[    0.000000] TSTATE: 0000004480e01606 TPC: 00000000005be460 TNPC: 00000000005be464 Y: 00000037    Not d
[    0.000000] TPC: <strlen+0x60/0xd4>
[    0.000000] g0: 000000000000002f g1: 0000000000000001 g2: 0000000000000000 g3: 000000000073a700
[    0.000000] g4: 000000000085ea50 g5: 0000000000000000 g6: 0000000000854000 g7: 0030a80000000000
[    0.000000] o0: 0000000000000000 o1: 0000000000000000 o2: 0000000001010101 o3: 0000000080808080
[    0.000000] o4: 0000000001010000 o5: fffff8006feae140 sp: 00000000008572c1 ret_pc: 0000000000655108
[    0.000000] RPC: <of_alias_scan+0x68/0x200>
[    0.000000] l0: 00000000008a4380 l1: fffff8006feae6b5 l2: fffff8006feae140 l3: fffff8006fe98e00
[    0.000000] l4: 0000000000000000 l5: 0000000000000000 l6: 0000000000000000 l7: 00000000008678d0
[    0.000000] i0: 00000000008c3f24 i1: 0000000000896ca0 i2: 00000000008268c0 i3: 00000000008268b8
[    0.000000] i4: 00000000008038c8 i5: fffff8006feae5c0 i6: 0000000000857381 i7: 00000000008c4314
[    0.000000] I7: <of_pdt_build_devicetree+0x90/0xa0>
[    0.000000] Call Trace:
[    0.000000]  [00000000008c4314] of_pdt_build_devicetree+0x90/0xa0
[    0.000000]  [00000000008b0330] prom_build_devicetree+0x10/0x3c
[    0.000000]  [00000000008b3bb8] paging_init+0xa3c/0xde8
[    0.000000]  [00000000008af978] setup_arch+0x324/0x688
[    0.000000]  [00000000008ae4ec] start_kernel+0x80/0x338
[    0.000000]  [0000000000715b30] tlb_fixup_done+0x88/0x90
[    0.000000]  [0000000000000000]           (null)
[    0.000000] Disabling lock debugging due to kernel taint
[    0.000000] Caller[00000000008c4314]: of_pdt_build_devicetree+0x90/0xa0
[    0.000000] Caller[00000000008b0330]: prom_build_devicetree+0x10/0x3c
[    0.000000] Caller[00000000008b3bb8]: paging_init+0xa3c/0xde8
[    0.000000] Caller[00000000008af978]: setup_arch+0x324/0x688
[    0.000000] Caller[00000000008ae4ec]: start_kernel+0x80/0x338
[    0.000000] Caller[0000000000715b30]: tlb_fixup_done+0x88/0x90
[    0.000000] Caller[0000000000000000]:           (null)
[    0.000000] Instruction DUMP: 96132080  19004040  94132101 <da020000> 9823400a  808b000b  024ffffd  9 

-- 
Meelis Roos (mroos@linux.ee)
