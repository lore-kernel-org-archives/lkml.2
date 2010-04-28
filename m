Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0D1QVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:21:00 -0400
Received: from mail.openrapids.net ([64.15.138.104]:60503 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751690Ab0D1QU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:20:59 -0400
Date: Wed, 28 Apr 2010 12:20:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Greg KH <greg@kroah.com>, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Jiri Kosina <jkosina@suse.cz>, Anton Blanchard <anton@samba.org>
Subject: Re: [171/197] module: fix __module_ref_addr()
Message-ID: <20100428162056.GA2846@Krystal>
References: <20100422191857.GA13268@kroah.com> <20100422190922.702027944@kvm.kroah.org> <20100428165201.3d7d6b4a@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100428165201.3d7d6b4a@griffin.suse.cz>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:16:38 up 95 days, 18:53,  7 users,  load average: 0.06, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Benc (jbenc@suse.cz) wrote:
> On Thu, 22 Apr 2010 12:10:22 -0700, Greg KH wrote:
> > __module_ref_addr() should use per_cpu_ptr() to obfuscate the pointer
> > (RELOC_HIDE is needed for per cpu pointers).
> 
> Hi,
> 
> this patch triggers NaT consumption exception on IA64, at least with
> gcc 4.3.4:
> 
> ------------
> modprobe[151]: NaT consumption 2216203124768 [1]
> Modules linked in:
> Supported: Yes
> Pid: 151, CPU 2, comm:             modprobe
> psr : 0000121009526030 ifs : 8000000000001430 ip  : [<a000000100129871>]    Not tainted (2.6.32.12-0.2-default)
> ip is at load_module+0xdd1/0x2300
> unat: 0000000000000000 pfs : 0000000000001430 rsc : 0000000000000003
> rnat: a000000100b45e28 bsps: 0000000000000000 pr  : 0000000000165a59
> ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c0270033f
> csd : 0000000000000000 ssd : 0000000000000000
> b0  : a000000100129830 b6  : a000000100122ae0 b7  : a000000100011370
> f6  : 000000000000000000000 f7  : 1003ee21a291c077975b9
> f8  : 1003e0000000000000089 f9  : 1003e0000000000000001
> f10 : 1003e0000000000000089 f11 : 000000000000000000000
> r1  : a0000001015befe0 r2  : 0000000000000000 r3  : 0000000000001000
> r8  : 0000000000000000 r9  : a0000001013dcc70 r10 : a0000001013dcc70
> r11 : 0000000000000008 r12 : e00000018b26fdc0 r13 : e00000018b260000
> r14 : 0000000000000008 r15 : 0000000000000fc0 r16 : 0000000000000000
> r17 : 0000000000000000 r18 : 0000000000000000 r19 : 0000000000000000
> r20 : 00000000000000fe r21 : 0000000000000008 r22 : 0000000000004a68
> r23 : 0000000000004a68 r24 : 0000000000004a68 r25 : 00000000ffff4a68
> r26 : e0000001820f1ec0 r27 : 0000000000000000 r28 : 0000000000000000
> r29 : 0000000000000003 r30 : 0000000000000004 r31 : 0000000000000002
> 
> Call Trace:
>  [<a000000100017a80>] show_stack+0x80/0xa0
>                                 sp=e00000018b26f910 bsp=e00000018b261438
>  [<a0000001000180e0>] show_regs+0x640/0x920
>                                 sp=e00000018b26fae0 bsp=e00000018b2613d8
>  [<a000000100029470>] die+0x190/0x2e0
>                                 sp=e00000018b26faf0 bsp=e00000018b261398
>  [<a000000100029610>] die_if_kernel+0x50/0x80
>                                 sp=e00000018b26faf0 bsp=e00000018b261368
>  [<a0000001008ea750>] ia64_fault+0xf0/0xda0
>                                 sp=e00000018b26faf0 bsp=e00000018b261320
>  [<a00000010000cb60>] ia64_native_leave_kernel+0x0/0x270
>                                 sp=e00000018b26fbf0 bsp=e00000018b261320
>  [<a000000100129870>] load_module+0xdd0/0x2300
>                                 sp=e00000018b26fdc0 bsp=e00000018b261198
>  [<a00000010012ae70>] sys_init_module+0xd0/0x620
>                                 sp=e00000018b26fe30 bsp=e00000018b261120
>  [<a00000010000c9c0>] ia64_ret_from_syscall+0x0/0x20
>                                 sp=e00000018b26fe30 bsp=e00000018b261120
>  [<a000000000010720>] __kernel_syscall_via_break+0x0/0x20
>                                 sp=e00000018b270000 bsp=e00000018b261120
> ------------
> 
> It's dying here:
> 
> static inline local_t *__module_ref_addr(struct module *mod, int cpu)
> {
> #ifdef CONFIG_SMP
> --->        return (local_t *) (mod->refptr + per_cpu_offset(cpu));
> #else
>         return &mod->ref;
> #endif
> }
> 
> This particular instance of __module_ref_addr is inlined in
> module_unload_init, which is inlined in load_module.
> 
> I don't know whether this is a gcc or a kernel bug but the code
> produced on IA64 is not what has been intended.
> 
> Comparing the code generated by gcc -S [1]. For the working case, i.e.
> (local_t *) (mod->refptr + per_cpu_offset(cpu)),
> per_cpu_offset(cpu) translates to:
> 
> ld8.mov r35 = [r83], __per_cpu_offset#  // tmp2056, tmp2056,
> ...
> sxt4 r18 = r8   // cpu, cpu
> ...
> shladd r17 = r18, 3, r35        // tmp1140, cpu,, tmp2056
> 
> For the crashing case, i.e.
> (local_t *) per_cpu_ptr(mod->refptr, cpu),
> per_cpu_offset(cpu) translates to:
> 
> sxt4 r17 = r8   // cpu, cpu
> ...
> shladd r11 = r17, 3, r0 // tmp1140, cpu,
> 
> Note that r0 is always zero, which means __per_cpu_offset is considered
> to be always NULL.
> 
> The problem seems to be triggered by RELOC_HIDE. I don't understand gcc
> well enough to be able to tell what's going on here. Any ideas?

Can you try reverting commit c8d52465f95c4187871f8e65666c07806ca06d41 and see if
it helps ?

That would revert the =r constraint back to an =g in RELOC_HIDE. The move from
=g to =r has originally been done to work around a ppc64 compiler bug in the
first place. My gut feeling is that ia64 does something unexpected if we apply a
=r constraint where we should not.

If you have other compiler versions handy, that would also be helpful to see if
the problem is specific to the gcc version you are using.

Thanks,

Mathieu


> 
> Thanks,
> 
>  Jiri
> 
> [1] http://labs.suse.cz/jbenc/kernel/reloc_hide-ia64-crash/
> 
> -- 
> Jiri Benc
> SUSE Labs

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
