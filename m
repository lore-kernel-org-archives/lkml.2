Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab2DYNIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:08:30 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37103 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2DYNI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:08:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAJ8eaTzRZdO6a_p+qsuFZkF7LbVcBD1Np190vVPaoRpin5=RsQ@mail.gmail.com>
References: <CAJ8eaTzRZdO6a_p+qsuFZkF7LbVcBD1Np190vVPaoRpin5=RsQ@mail.gmail.com>
Date: Wed, 25 Apr 2012 18:38:28 +0530
Message-ID: <CAJ8eaTyJnqkyVN4k_cVZ1SXvwGf_4JYGVWZDwZ_Zjvq34NGvtg@mail.gmail.com>
Subject: Re: backtrace issue in MIPS 3.0
From: naveen yadav <yad.naveen@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lkml also

On Wed, Apr 25, 2012 at 6:17 PM, naveen yadav <yad.naveen@gmail.com> wrote:
> Dear Ralf,
>
> We observe the following issue in kernel backtrace.
>
> Scenario:1
> Correct backtrace - if HAVE_FUNCTION_TRACER is disable.
>
> ====[ backtrace testing ]===========
> Testing a backtrace from process context.
> The following trace is a kernel self test and not a bug!
> Testing a backtrace.
> The following trace is a kernel self test and not a bug!
> Call Trace:
> [<80295134>] dump_stack+0x8/0x34
> [<c0946060>] backtrace_regression_test+0x60/0x94 [sisc_backtrcae]
> [<800004f0>] do_one_initcall+0xf0/0x1d0
> [<80060954>] sys_init_module+0x19c8/0x1c60
> [<8000a418>] stack_done+0x20/0x40
>
> Scenaro-2:
> if HAVE_FUNCTION_TRACER is enabled
>        HAVE_FUNCTION_TRACER function enables FRAME_POINTER
>      menuconfig->
>               kernel hacking->
>                                    tracers->
>                                                 Kernel Function Tracer
>
> ====[ backtrace testing ]===========
>
> Testing a backtrace from process context.
>
> The following trace is a kernel self test and not a bug!
>
> Testing a backtrace.
>
> The following trace is a kernel self test and not a bug!
>
> Call Trace:
>
> [<802e5164>] dump_stack+0x1c/0x50
>
> [<802e5164>] dump_stack+0x1c/0x50
>
> ====[ end of backtrace testing ]====
>  ----------------------------------------------------------------------------------------------------------------------------------------------------
>
> Sample Code:
>
> #include <linux/module.h>
> #include <linux/sched.h>
> #include <linux/delay.h>
> //static struct timer_list backtrace_timer;
>
> static void backtrace_test_timer()
> {
>        printk("Testing a backtrace.\n");
>        printk("The following trace is a kernel self test and not a bug!\n");
>        dump_stack();
> }
> static int backtrace_regression_test(void)
> {
>        printk("====[ backtrace testing ]===========\n");
>        printk("Testing a backtrace from process context.\n");
>        printk("The following trace is a kernel self test and not a bug!\n");
>        backtrace_test_timer();
>        msleep(10);
>        printk("====[ end of backtrace testing ]====\n");
>        return 0;
> }
> static void exitf(void)
> {
> }
>
> module_init(backtrace_regression_test);
> module_exit(exitf);
> MODULE_LICENSE("GPL");
>
>
> objdump is also attached.
>
> Thanks
