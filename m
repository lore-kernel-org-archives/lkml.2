Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab0CSCPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 22:15:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53525 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0CSCPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 22:15:43 -0400
X-Authority-Analysis: v=1.0 c=1 a=FhWVZtC4hY8A:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=-sosOnZdk7ClBvAQVkoA:9 a=4mXHSWUsvvDdyTVZDZVAnGwWwMsA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33 GP fault only when built with tracing
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <4BA2B69D.3000309@oracle.com>
References: <4BA2B69D.3000309@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 18 Mar 2010 22:15:41 -0400
Message-ID: <1268964941.758.21.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-18 at 16:26 -0700, Randy Dunlap wrote:
> I can build/boot 2.6.33 with CONFIG_TRACE/TRACING disabled successfully,
> but when I enable lots of tracing config options and then boot with
> ftrace=nop on the kernel command line, I see a GP fault when the parport &
> parport_pc modules are loading/initializing.
> 
> It happens in drivers/parport/share.c::parport_register_device(), when that
> function calls try_module_get().
> 
> If I comment out the trace_module_get() calls in include/linux/module.h,
> the kernel boots with no problems.
> 
> [   21.852829] general protection fault: 0000 [#1] SMP 
> [   21.856321] last sysfs file: /sys/module/parport/initstate
> [   21.856321] CPU 0 
> [   21.856321] Pid: 2089, comm: modprobe Not tainted 2.6.33 #11 0HH807/OptiPlex GX620               
> [   21.856321] RIP: 0010:[<ffffffffa0437671>]  [<ffffffffa0437671>] parport_register_device+0xe4/0x48c [parport]
> [   21.856321] RSP: 0018:ffff8800765cba78  EFLAGS: 00010283
> [   21.856321] RAX: ffff10007b04a3d0 RBX: ffff88007a6a5e30 RCX: 0000000000000000
> [   21.856321] RDX: 0000000000000000 RSI: ffffffffa043d1de RDI: ffff88007a6a5e30
> [   21.856321] RBP: ffff8800765cbad8 R08: 0000000000000000 R09: 0000000000000000
> [   21.856321] R10: ffffffffa043dff8 R11: 0000000000000000 R12: ffffffffa043d1de
> [   21.856321] R13: ffffffffa043d1de R14: ffffffffa045c940 R15: 0000000000000000
> [   21.856321] FS:  00007f09cc3fb6f0(0000) GS:ffff880004a00000(0000) knlGS:0000000000000000
> [   21.856321] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   21.856321] CR2: 0000003fb5ad62c0 CR3: 00000000764f6000 CR4: 00000000000006f0
> [   21.856321] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   21.856321] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   21.856321] Process modprobe (pid: 2089, threadinfo ffff8800765ca000, task ffff88007664a3d0)
> [   21.856321] Stack:


Is this fully reproducible at every boot up? I just booted your config
(no changes) and loaded the parport_pc module with no issues. I even
added your command line (just modifying root=.. )

-- Steve


