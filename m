Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab0C3Xcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:32:55 -0400
Received: from theiggy.com ([66.220.1.110]:53105 "EHLO mail.theiggy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858Ab0C3Xcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:32:51 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Mar 2010 19:32:51 EDT
From: Brian Jackson <iggy@theiggy.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: KVM warning about uncertified CPU for SMP for AMD model 2, stepping3
Date: Tue, 30 Mar 2010 18:25:56 -0500
User-Agent: KMail/1.13.1 (Linux/2.6.32-16-generic; KDE/4.4.1; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
References: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003301825.57229.iggy@theiggy.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 March 2010 06:03:02 pm Jiri Kosina wrote:
> Hi,
> 
> booting 32bit guest on 32bit host on AMD system gives me the following
> warning when KVM is instructed to boot as SMP:


This has been discussed before (fairly recently). Subject was "tainted Linux 
kernel in default SMP QEMU/KVM guests". A few solutions were mentioned, so I 
won't bother boring everyone with repeating them.



> 
> 
> 
> CPU0: AMD QEMU Virtual CPU version 0.9.1 stepping 03
> Booting Node   0, Processors  #1
> Initializing CPU#1
> Leaving ESR disabled.
> Mapping cpu 1 to node 0
> ------------[ cut here ]------------
> WARNING: at linux-2.6.32/arch/x86/kernel/cpu/amd.c:187
> init_amd_k7+0x178/0x187() Hardware name:
> WARNING: This combination of AMD processors is not suitable for SMP.
> Modules linked in:
> Pid: 0, comm: swapper Not tainted 2.6.32.9-0.5-pae #1
> Call Trace:
>  [<c02069a1>] try_stack_unwind+0x1b1/0x1f0
>  [<c020596f>] dump_trace+0x3f/0xe0
>  [<c02065ab>] show_trace_log_lvl+0x4b/0x60
>  [<c02065d8>] show_trace+0x18/0x20
>  [<c052dc19>] dump_stack+0x6d/0x74
>  [<c023ebbf>] warn_slowpath_common+0x6f/0xd0
>  [<c023ec6b>] warn_slowpath_fmt+0x2b/0x30
>  [<c052875c>] init_amd_k7+0x178/0x187
>  [<c052896f>] init_amd+0x138/0x279
>  [<c0527d74>] identify_cpu+0xc2/0x223
>  [<c0527ee1>] identify_secondary_cpu+0xc/0x1a
>  [<c052b3bc>] smp_callin+0xd4/0x1a1
>  [<c052b493>] start_secondary+0xa/0xe7
> 
> 
> 
> The virtual CPU identifies itself as cpu family 6, model 2, stepping 3 in
> /proc/cpuinfo.
> 
> Model 2 is indeed not handled by amd_k7_smp_check() and thus this warning
> is spit out.
> 
> Is that correct? Model 2 refers to Pluto/Orion (K75) if I remember
> correctly, right? That one is not oficially certified for SMP by AMD?
> 
> If it is not, maybe KVM should better emulate different CPU for
> SMP-enabled configurations, right?
> On the other hand, if it is certified (I have no idea), amd_k7_smp_check()
> should handle this model properly.
> 
> Thanks,
