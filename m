Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab0CSQMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 12:12:06 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:57956 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0CSQMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 12:12:02 -0400
Message-ID: <4BA3A20A.4090102@oracle.com>
Date: Fri, 19 Mar 2010 09:10:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: 2.6.33 GP fault only when built with tracing
References: <4BA2B69D.3000309@oracle.com> <1268964941.758.21.camel@gandalf.stny.rr.com>
In-Reply-To: <1268964941.758.21.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BA3A24D.004C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/10 19:15, Steven Rostedt wrote:
> On Thu, 2010-03-18 at 16:26 -0700, Randy Dunlap wrote:
>> I can build/boot 2.6.33 with CONFIG_TRACE/TRACING disabled successfully,
>> but when I enable lots of tracing config options and then boot with
>> ftrace=nop on the kernel command line, I see a GP fault when the parport &
>> parport_pc modules are loading/initializing.
>>
>> It happens in drivers/parport/share.c::parport_register_device(), when that
>> function calls try_module_get().
>>
>> If I comment out the trace_module_get() calls in include/linux/module.h,
>> the kernel boots with no problems.
>>
>> [   21.852829] general protection fault: 0000 [#1] SMP 
>> [   21.856321] last sysfs file: /sys/module/parport/initstate
>> [   21.856321] CPU 0 
>> [   21.856321] Pid: 2089, comm: modprobe Not tainted 2.6.33 #11 0HH807/OptiPlex GX620               
>> [   21.856321] RIP: 0010:[<ffffffffa0437671>]  [<ffffffffa0437671>] parport_register_device+0xe4/0x48c [parport]
>> [   21.856321] RSP: 0018:ffff8800765cba78  EFLAGS: 00010283
>> [   21.856321] RAX: ffff10007b04a3d0 RBX: ffff88007a6a5e30 RCX: 0000000000000000
>> [   21.856321] RDX: 0000000000000000 RSI: ffffffffa043d1de RDI: ffff88007a6a5e30
>> [   21.856321] RBP: ffff8800765cbad8 R08: 0000000000000000 R09: 0000000000000000
>> [   21.856321] R10: ffffffffa043dff8 R11: 0000000000000000 R12: ffffffffa043d1de
>> [   21.856321] R13: ffffffffa043d1de R14: ffffffffa045c940 R15: 0000000000000000
>> [   21.856321] FS:  00007f09cc3fb6f0(0000) GS:ffff880004a00000(0000) knlGS:0000000000000000
>> [   21.856321] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> [   21.856321] CR2: 0000003fb5ad62c0 CR3: 00000000764f6000 CR4: 00000000000006f0
>> [   21.856321] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   21.856321] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [   21.856321] Process modprobe (pid: 2089, threadinfo ffff8800765ca000, task ffff88007664a3d0)
>> [   21.856321] Stack:
> 
> 
> Is this fully reproducible at every boot up? I just booted your config
> (no changes) and loaded the parport_pc module with no issues. I even
> added your command line (just modifying root=.. )

Yes, it has failed for me 100% of the time (about 10 boots).

I'm rebuilding to test with Mathieu's request now.

-- 
~Randy
