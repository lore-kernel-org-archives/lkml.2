Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab0C3XDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:03:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab0C3XDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:03:08 -0400
Date: Wed, 31 Mar 2010 01:03:02 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: KVM warning about uncertified CPU for SMP for AMD model 2, stepping
 3
Message-ID: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

booting 32bit guest on 32bit host on AMD system gives me the following 
warning when KVM is instructed to boot as SMP:



CPU0: AMD QEMU Virtual CPU version 0.9.1 stepping 03
Booting Node   0, Processors  #1
Initializing CPU#1
Leaving ESR disabled.
Mapping cpu 1 to node 0
------------[ cut here ]------------
WARNING: at linux-2.6.32/arch/x86/kernel/cpu/amd.c:187 init_amd_k7+0x178/0x187()
Hardware name: 
WARNING: This combination of AMD processors is not suitable for SMP.
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.32.9-0.5-pae #1
Call Trace:
 [<c02069a1>] try_stack_unwind+0x1b1/0x1f0
 [<c020596f>] dump_trace+0x3f/0xe0
 [<c02065ab>] show_trace_log_lvl+0x4b/0x60
 [<c02065d8>] show_trace+0x18/0x20
 [<c052dc19>] dump_stack+0x6d/0x74
 [<c023ebbf>] warn_slowpath_common+0x6f/0xd0
 [<c023ec6b>] warn_slowpath_fmt+0x2b/0x30
 [<c052875c>] init_amd_k7+0x178/0x187
 [<c052896f>] init_amd+0x138/0x279
 [<c0527d74>] identify_cpu+0xc2/0x223
 [<c0527ee1>] identify_secondary_cpu+0xc/0x1a
 [<c052b3bc>] smp_callin+0xd4/0x1a1
 [<c052b493>] start_secondary+0xa/0xe7



The virtual CPU identifies itself as cpu family 6, model 2, stepping 3 in 
/proc/cpuinfo.

Model 2 is indeed not handled by amd_k7_smp_check() and thus this warning 
is spit out.

Is that correct? Model 2 refers to Pluto/Orion (K75) if I remember 
correctly, right? That one is not oficially certified for SMP by AMD?

If it is not, maybe KVM should better emulate different CPU for 
SMP-enabled configurations, right? 
On the other hand, if it is certified (I have no idea), amd_k7_smp_check() 
should handle this model properly.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
