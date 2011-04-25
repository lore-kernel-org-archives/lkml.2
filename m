Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab1DYOmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 10:42:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47433 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340Ab1DYOmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 10:42:51 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=QK7HZy2CBTsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=1XWaLZrsAAAA:8 a=-UFDxyoSAAAA:8 a=CCpqsmhAAAAA:8 a=b01i9L7eAAAA:8 a=tTsET3oCFtj_Ro9qjqwA:9 a=fwBbaufQMwyECbGs0vsA:7 a=PUjeQqilurYA:10 a=aKLL4rI2UX8A:10 a=X_4dqEl-T5QA:10 a=H9p3eNo9e8EA:10 a=oxEsQzvqF_oA:10 a=MSl-tDqOz04A:10 a=K300mP2t83u6Lji3:21 a=Hm6aDLaGhINeVKVj:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: KGTP (Linux Kernel debugger and tracer) 20110424 release
From: Steven Rostedt <rostedt@goodmis.org>
To: Hui Zhu <teawater@gmail.com>
Cc: linux-kernel@vger.kernel.org, Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>,
        Steven <mqyoung@gmail.com>, colyli@gmail.com,
        Christoph Hellwig <hch@infradead.org>
In-Reply-To: <BANLkTinOwu+MazHDhJLtsSZVkJHLBtWSzw@mail.gmail.com>
References: <BANLkTinOwu+MazHDhJLtsSZVkJHLBtWSzw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Apr 2011 10:42:48 -0400
Message-ID: <1303742568.18763.7.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-24 at 22:28 +0800, Hui Zhu wrote:


There is several grammar mistakes, I'll correct those here that caused
me to have trouble understanding what you were saying. There's more
mistakes that I'm not correcting because I still understand what you
meant. I'll let Randy correct those, as he can come up with better
sentences than I can.

Do not take this as an insult, I have an utmost respect for those that
communicate on LKML in a language that is not their own mother tongue.
And I also understand that the Asian languages are even more different
than English that it makes it 10 times more difficult to get it right
(as suppose to those that speak German).
> --- /dev/null
> +++ b/Documentation/trace/gtp.txt
> @@ -0,0 +1,873 @@
> +		Linux Kernel GDB tracepoint module (KGTP)
> +		=========================================
> +		By Hui Zhu <teawater@gmail.com>
> +		https://code.google.com/p/kgtp/wiki/HOWTO
> +		2011-04-24
> +
> +Table of contents
> +-----------------
> +
> +What is KGTP
> +Report issue about KGTP
> +Get info about GDB tracepoint
> +Get KGTP through http
> +Get KGTP through svn
> +Config KGTP
> +Compile KGTP
> +Install KGTP
> +Uninstall KGTP
> +Howto use
> +	Exec it
> +	Make GDB connect to gtp
> +	Add module symbols to GDB
> +	Get GDB tracepoint commands
> +	Get registers info from Kernel
> +	Get the value of variable from Kernel
> +	How to use use tracepoint condition
> +	How to use trace state variables
> +		Simple trace state variables
> +		Special trace state variables $current_task,
> +		    $current_thread_info, $cpu_id, $dump_stack, $printk_level,
> +		    $printk_format, $printk_tmp and $clock
> +	Show all the traced data of current frame
> +	Get backtrace info from Kernel
> +	Howto let tracepoint output value directly
> +		Output stack dump directly
> +		Switch collect to output the value directly
> +		Use printf command in actions
> +	Get status of KGTP from Kernel
> +	Set the trace buffer into a circular buffer
> +	Do not stop tracepoint when the GDB disconnect
> +	Howto show the variable that value of it is optimized
> +		Linux kernel "Compile with almost no optimization" patch
> +		Update your GCC
> +	Offline debug
> +
> +
> +
> +
> +What is KGTP
> +------------
> +
> +KGTP is a realtime and lightweight Linux Kernel GDB debugger and tracer that
> +use Kprobe.

"uses Kprobes."

> +
> +It make Linux Kernel supply a GDB remote debug interface. Then GDB in current

It supplies the Linux Kernel with a GDB remote debug interface. ...

> +machine or remote machine(see "Make GDB connect to gtp") can debug Linux
> +through GDB tracepoint without stop the Linux Kernel.

without stopping the Linux Kernel.

> +And even if the board doesn't have GDB on it and doesn't have interface for
> +remote debug. It can debug the Linux Kernel use offline debug (See "Offline

using offline debug.

> +debug").
> +It support X86-32, X86-64, MIPS and ARM.
> +http://www.tudou.com/programs/view/_p6VTgxmCRA/ This is a video(in Chinese)
> +to show how to use it.
> +
> +
> +
> +
> +Report issue about KGTP

Report an issues about KGTP

> +-----------------------
> +You can post it in https://code.google.com/p/kgtp/issues/list or write Email

or write an email to ...

> +to teawater@gmail.com.
> +
> +
> +
> +
> +Get info about GDB tracepoint
> +-----------------------------
> +Please goto http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html
> +
> +
> +
> +
> +Get KGTP through http
> +---------------------
> +Please goto http://code.google.com/p/kgtp/downloads/list OR UPDATE to down

to download the package (?)

> +the package.
> +
> +
> +
> +
> +Get KGTP through svn
> +--------------------
> +Some people have trouble with access to KGTP website. You can access kgtp
> +through svn:
> +
> +------------------------------------------------------------
> +svn checkout http://kgtp.googlecode.com/svn/ kgtp-read-only
> +------------------------------------------------------------
> +
> +kgtp-read-only/tags/ There is the each release of KGTP.

This has each release of KGTP (?)

> +kgtp-read-only/trunk/ There is the main trunk of KGTP.

This is the main code repository of KGTP (?)

> +
> +
> +
> +
> +Config KGTP
> +-----------
> +
> +Before compile KGTP, you can choice which Kernel you want build with and

Before compiling KGTP, you can choose which kernel you want to build
with and

> +which compiler you want through change the Makefile. For example:

which compiler you want by changing the Makefile in your KGTP
repository. (?)


> +
> +-------------------------------------------
> +KERNELDIR := /lib/modules/`uname -r`/build
> +CROSS_COMPILE :=
> +-------------------------------------------
> +
> +KERNELDIR is set the directory which Kernel you want build for. Now it set to

KERELDIR is set to the directory which holds the kernel you want to
build for. By default, it is set to the kernel that you are running.

> +the current kernel that you use.

> +CROSS_COMPILE is set the compiler that you want to build the KGTP. Empty mean
> +use current compiler.

CROSS_COMPILE is set to the compiler you want to build KGTP. Leave empty
to compile with your default compiler.

> +ARCH is the architecture.
> +
> +------------------------------------------
> +KERNELDIR := /home/teawater/kernel/bamd64
> +CROSS_COMPILE :=x86_64-glibc_std-
> +ARCH := x86_64
> +------------------------------------------
> +
> +KERNELDIR is set to /home/teawater/kernel/bamd64. Compiler will
> +use x86_64-glibc_std-gcc.
> +
> +
> +
> +
> +Compile KGTP
> +------------
> +
> +For normal use:
> +
> +---------
> +cd kgtp/
> +make
> +---------
> +
> +If you want KGTP out the debug message,please use following (It is available
> +after 20100825):


I'm not sure what you mean by the above. Do you mean:

If you want KGTP to output debug messages, then us the following (....)

> +
> +---------
> +cd kgtp/
> +make D=1
> +---------
> +
> +
> +
> +
> +Install KGTP
> +------------
> +
> +------------------
> +cd kgtp/
> +sudo make install
> +------------------
> +
> +
> +
> +
> +Uninstall KGTP
> +--------------
> +
> +--------------------
> +cd kgtp/
> +sudo make uninstall
> +--------------------
> +
> +
> +
> +
> +Howto use
> +---------
> +
> +Exec it
> +-------
> +
> +If you had installed the KGTP in your system, you can:
> +
> +------------------
> +sudo modprobe gtp
> +------------------
> +
> +Or you can use the kgtp module in the directory.
> +
> +-------------------
> +cd kgtp/
> +sudo insmod gtp.ko
> +-------------------
> +
> +
> +
> +Make GDB connect to gtp
> +-----------------------
> +
> +In current machine:

On current machine.

Now it may be better to use "server" instead of current machine. I guess
you mean the man box the user is using.

> +
> +---------------------------------
> +sudo gdb ./vmlinux
> +(gdb) target remote /sys/kernel/debug/gtp
> +Remote debugging using /sys/kernel/debug/gtp
> +0x0000000000000000 in ?? ()
> +---------------------------------
> +
> +In remote machine:

On remote machine:

"target" may also be better, but I'm fine with "remote".

> +
> +---------------------------------------------
> +#Open the KGTP interface in current machine.

Now do you mean current == remote? I'm confused here. It is best to stay
consistent. Always use "remote" and always use "server".

> +sudo su
> +nc -l 1234 </sys/kernel/debug/gtp >/sys/kernel/debug/gtp
> +(nc -l -p 1234 </sys/kernel/debug/gtp >/sys/kernel/debug/gtp for old version
> +netcat.)
> +#Let gdb connect to the port 1234
> +gdb ./vmlinux
> +(gdb) target remote xxx.xxx.xxx.xxx:1234

You run gdb on the remote machine too?

> +---------------------------------------------
> +
> +
> +
> +Add module symbols to GDB
> +-------------------------
> +
> +Sometime, you need add the Linux Kernel module(lkm) symbols to GDB to debug it.
> +Following a example howto add ext3.ko's symbols to GDB:

The following example howto adds ext3.ko symbols to GDB:

> +
> +--------------------------------------------------------------------------------
> +cat /proc/modules  | grep ext
> +ext3 116512 3 - Live 0xf9083000
> +#Get the address 0xf9083000.
> +modinfo ext3
> +filename:       /lib/modules/2.6.36-rc2+/kernel/fs/ext3/ext3.ko
> +#Get the directory name of ext3.
> +(gdb) add-symbol-file /lib/modules/2.6.36-rc2+/kernel/fs/ext3/ext3.ko
> 0xf9083000
> +#Then, GDB get the symbols of ext3.

Now GDB has the symbols for ext3 (?)

> +--------------------------------------------------------------------------------
> +
> +You will see that it just add the text section info to GDB, sometime you need
just adds the ..., sometimes you need to add the info section of another
section. For example:

> +add another section info of other section, for example:
> +
> +--------------------------------------------------------------------------------
> +cat /sys/module/ext3/sections/.bss
> +0xf908170c
> +#Get the bss address 0xf908170c.
> +(gdb) add-symbol-file /lib/modules/2.6.36-rc2+/kernel/fs/ext3/ext3.ko
> 0xf9083000 -s .bss 0xf908170c
> +#Then, GDB get the symbols of ext3.

Now GDB has the .bss symbols for ext3 (?)

> +--------------------------------------------------------------------------------
> +
> +
> +
> +Get GDB tracepoint commands
> +---------------------------
> +
> +Please goto http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoints.html
> +
> +
> +Get registers info from Kernel
> +------------------------------
> +
> +Following part is an example that record the value of all registers when Linux
> +Kernel call function "vfs_readdir".

The following is an example that records the value of all registers when
"vfs_readdir" is called.

> +
> +--------------------------------------------------------------------------------
> +(gdb) trace vfs_readdir

Is this on the server or remote? Or do you mean that you can do this
from either one or the other.

Again, I'm a bit confused ;)


> +Tracepoint 1 at 0xc01a1ac0: file
> +/home/teawater/kernel/linux-2.6/fs/readdir.c, line 23.
> +(gdb) actions
> +Enter actions for tracepoint 1, one per line.
> +End with a line saying just "end".
> +>collect $reg
> +>end
> +(gdb) tstart
> +(gdb) shell ls

I take it that this is run on the remote (target) box. I don't think
this would work on the server, would it?

> +(gdb) tstop
> +(gdb) tfind
> +Found trace frame 0, tracepoint 1
> +#0  0xc01a1ac1 in vfs_readdir (file=0xc5528d00, filler=0xc01a1900 <filldir64>,
> +   buf=0xc0d09f90) at /home/teawater/kernel/linux-2.6/fs/readdir.c:23
> +23      /home/teawater/kernel/linux-2.6/fs/readdir.c: No such file or
> directory.
> +       in /home/teawater/kernel/linux-2.6/fs/readdir.c
> +(gdb) info reg
> +eax            0xc5528d00       -984445696
> +ecx            0xc0d09f90       -1060069488
> +edx            0xc01a1900       -1072031488
> +ebx            0xfffffff7       -9
> +esp            0xc0d09f8c       0xc0d09f8c
> +ebp            0x0      0x0
> +esi            0x8061480        134616192
> +edi            0xc5528d00       -984445696
> +eip            0xc01a1ac1       0xc01a1ac1 <vfs_readdir+1>
> +eflags         0x286    [ PF SF IF ]
> +cs             0x60     96
> +ss             0x8061480        134616192
> +ds             0x7b     123
> +es             0x7b     123
> +fs             0x0      0
> +gs             0x0      0
> +(gdb) tfind
> +Found trace frame 1, tracepoint 1
> +0xc01a1ac1      23      in /home/teawater/kernel/linux-2.6/fs/readdir.c
> +(gdb) info reg
> +eax            0xc5528d00       -984445696
> +ecx            0xc0d09f90       -1060069488
> +edx            0xc01a1900       -1072031488
> +ebx            0xfffffff7       -9
> +esp            0xc0d09f8c       0xc0d09f8c
> +ebp            0x0      0x0
> +esi            0x8061480        134616192
> +edi            0xc5528d00       -984445696
> +eip            0xc01a1ac1       0xc01a1ac1 <vfs_readdir+1>
> +eflags         0x286    [ PF SF IF ]
> +cs             0x60     96
> +ss             0x8061480        134616192
> +ds             0x7b     123
> +es             0x7b     123
> +fs             0x0      0
> +gs             0x0      0
> +--------------------------------------------------------------------------------
> +
> +
> +
> +Get the value of variable from Kernel
> +-------------------------------------
> +
> +Following part is an example that record the value of "jiffies_64" when Linux
> +Kernel call function "vfs_readdir".

The following is an example that records the value of "jiffies_64" when
the function "vfs_readdir" is called:

> +
> +--------------------------------------------------------------------------------
> +(gdb) trace vfs_readdir
> +Tracepoint 1 at 0xc01ed740: file
> /home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
> +(gdb) actions
> +Enter actions for tracepoint 1, one per line.
> +End with a line saying just "end".
> +>collect jiffies_64
> +>collect file->f_path.dentry->d_iname
> +>end
> +(gdb) tstart
> +(gdb) shell ls
> +arch    drivers   include  kernel    mm               Module.symvers
> security  System.map  virt
> +block   firmware  init     lib       modules.builtin  net
> sound     t           vmlinux
> +crypto  fs        ipc      Makefile  modules.order    scripts
> source    usr         vmlinux.o
> +(gdb) tstop
> +(gdb) tfind
> +Found trace frame 0, tracepoint 1
> +#0  0xc01ed741 in vfs_readdir (file=0xf4063000, filler=0xc01ed580
> <filldir64>, buf=0xd6dfdf90)
> +    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
> +24      {
> +(gdb) p jiffies_64
> +$1 = 4297248706
> +(gdb) p file->f_path.dentry->d_iname
> +$1 = "b26", '\000' <repeats 28 times>
> +--------------------------------------------------------------------------------
> +
> +
> +
> +How to use use tracepoint condition
> +-----------------------------------
> +
> +http://sourceware.org/gdb/current/onlinedocs/gdb/Tracepoint-Conditions.html
> +Like the breakpoint, we can set condition to tracepoint. But it speed is more
> +fast than breakpoint's condition because KGTP do all the condition check.

Like breakpoints, conditions can be set to tracepoints. The speed of
tracepoints is faster than breakpoints because KGTP can do all the
condition checks.

> +For example:
> +
> +------------------------------
> +(gdb) trace handle_irq
> +(gdb) condition 1 (irq == 47)
> +------------------------------
> +
> +This action of tracepoint 1 will work only when irq number is 47.
> +
> +
> +
> +How to use trace state variables
> +--------------------------------
> +
> +http://sourceware.org/gdb/current/onlinedocs/gdb/Trace-State-Variables.html
> +Tracepoint have special variables. You can trace it or use it in tracepoint
> +condition.

Tracepoints have special variables. The variables can be traced
directly, or used in tracepoint conditions.

> +Note that only GDB 7.2.1 and later version support use trace state variables

Note that only GDB versions 7.2.1 and later support the sue of trace
state variables directly,..

> +directly, the old version GDB just can show the value of trace state variables

, the old version of GDB can show the value of trace ...

> +through command "info tvariables".
> +
> +
> +Simple trace state variables
> +----------------------------
> +
> +Define a trace state variable $c.
> +
> +-------------------
> +(gdb) tvariable $c
> +-------------------
> +
> +Trace state variable $c created, with initial value 0.

... variable $c is created with initial value 0.

> +Use it in the action. Follow action will use $c to count how much irq happen
> +in Kernel.

The following action uses $c to count how many irqs happened in the
Kernel.

> +
> +-----------------------------------------------------------------------
> +(gdb) trace handle_irq
> +(gdb) actions
> +Enter actions for tracepoint 3, one per line.
> +End with a line saying just "end".
> +>collect $c     #Save current value of $c to the trace frame buffer.
> +>teval $c=$c+1  #Increase the $c.
> +>end
> +-----------------------------------------------------------------------
> +
> +You can get the current value of $c when the trace is running or stop.

... of $c while the trace is running or stopped.

> +
> +----------------------------------
> +(gdb) tstart
> +(gdb) info tvariables
> +$c              0           31554
> +(gdb) p $c
> +$5 = 33652
> +(gdb) tstop
> +(gdb) p $c
> +$9 = 105559
> +----------------------------------
> +
> +When use the tfind parse the trace frame buffer, if the value of trace state
> +variable is collect. You can use it.

I do not understand the above at all.

> +
> +------------------------------
> +(gdb) tstop
> +(gdb) tfind
> +(gdb) info tvariables
> +$c              0           0
> +(gdb) p $c
> +$6 = 0
> +(gdb) tfind 100
> +(gdb) p $c
> +$7 = 100
> +------------------------------

Nor do I understand the above example.


> +
> +
> +Special trace state variables $current_task, $current_thread_info, $cpu_id,
> +$dump_stack, $printk_level, $printk_format, $printk_tmp and $clock
> +--------------------------------------------------------------------------
> +
> +KGTP have special trace state variables $current_task, $current_thread_info,

KGTP has special ...

> +$cpu_id and $clock can very easy to access to some special value. You can see

... $clock that can be used to access their special values. (?)

> +them when GDB connect to the KGTP. You can use them in tracepoint condition

                 connects                                           conditions

> +or actions.
> +Access $current_task in tracepoint condition and action will get the return
> +of get_current().

The use of $current_task in tracepoint conditions will return the action
of get_current().

> +Access $current_thread_info in tracepoint condition and action will get the
> +return of current_thread_info().

Same

> +Access $cpu_id in tracepoint condition and action will get the return of
> +smp_processor_id().

Same

> +Access $clock in tracepoint condition and action will get the return of
> +local_clock() that return the timestamp in nanoseconds.

Same

> +
> +And KGTP have other special trace state variables $dump_stack, $printk_level,

KGTP has other special trace state variables ...

> +$printk_format and $printk_tmp, all of them are for output value directly that

                      $print_tmp. Their output is explained in
"Howto ..."

> +will introduce in "Howto let tracepoint output value directly".
> +
> +Following example will count process 16663 call how many sys_read in $c
> +and collect the struct thread_info of current task:

I'm confused by what $c is to give it a proper translation.

> +
> +--------------------------------------------------------------------------------
> +(gdb) trace vfs_read if ((*(struct task_struct *)$current_task)->pid == 16663)
> +(gdb) tvariable $c
> +(gdb) actions
> +Enter actions for tracepoint 4, one per line.
> +End with a line saying just "end".
> +>teval $c=$c+1
> +>collect (*(struct thread_info *)$current_thread_info)
> +>end
> +(gdb) tstart
> +(gdb) info tvariables
> +Name            Initial     Current
> +$c              0           184
> +$current_task   0           <unknown>
> +$current_thread_info 0           <unknown>
> +$cpu_id         0           <unknown>
> +(gdb) tstop
> +(gdb) tfind
> +(gdb) p *(struct thread_info *)$current_thread_info
> +$10 = {task = 0xf0ac6580, exec_domain = 0xc07b1400, flags = 0, status
> = 0, cpu = 1, preempt_count = 2, addr_limit = {
> +    seg = 4294967295}, restart_block = {fn = 0xc0159fb0
> <do_no_restart_syscall>, {{arg0 = 138300720, arg1 = 11,
> +        arg2 = 1, arg3 = 78}, futex = {uaddr = 0x83e4d30, val = 11,
> flags = 1, bitset = 78, time = 977063750,
> +        uaddr2 = 0x0}, nanosleep = {index = 138300720, rmtp = 0xb,
> expires = 335007449089}, poll = {
> +        ufds = 0x83e4d30, nfds = 11, has_timeout = 1, tv_sec = 78,
> tv_nsec = 977063750}}},
> +  sysenter_return = 0xb77ce424, previous_esp = 0, supervisor_stack =
> 0xef340044 "", uaccess_err = 0}
> +--------------------------------------------------------------------------------


This is all I have time for this now, but this work looks very
promising. When I get some more time, I will have to start playing with
it.

Thanks!

-- Steve


