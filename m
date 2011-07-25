Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab1GYSUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:20:23 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64165 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1GYSUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:20:21 -0400
MIME-Version: 1.0
In-Reply-To: <20110722125934.GA25433@elte.hu>
References: <20110722125934.GA25433@elte.hu>
Date: Mon, 25 Jul 2011 14:20:20 -0400
Message-ID: <CACqU3MW-7_gCqNARdrPA5rZoZGLti+DMvkZsJN40VSDtU+VhpQ@mail.gmail.com>
Subject: Re: [GIT PULL] core/printk changes for v3.1
From: Arnaud Lacombe <lacombar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 22, 2011 at 8:59 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Linus,
>
> Please pull the latest core-printk-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-printk-for-linus
>
> ( These are just the tested-safe commits - the ones that were causing
>  problems are not included. )
>
>  Thanks,
>
>        Ingo
>
> ------------------>
> Peter Zijlstra (3):
>      [...]
>      lockdep: Fix trace_[soft,hard]irqs_[on,off]() recursion
>
This commit is triggering:

WARNING: at /src/linux/linux/kernel/lockdep.c:2529
trace_hardirqs_on_caller+0x52/0x79()
Hardware name: Bochs
Modules linked in:
Pid: 0, comm: swapper Not tainted 3.0.0-rc2+ #12
Call Trace:
 [<c101be35>] warn_slowpath_common+0x65/0x7a
 [<c103d976>] ? trace_hardirqs_on_caller+0x52/0x79
 [<c11fdfc4>] ? restore_all+0xf/0xf
 [<c1003254>] ? math_state_restore+0x40/0x40
 [<c101be59>] warn_slowpath_null+0xf/0x13
 [<c103d976>] trace_hardirqs_on_caller+0x52/0x79
 [<c10df760>] trace_hardirqs_on_thunk+0xc/0x10
 [<c11fdfc4>] ? restore_all+0xf/0xf
 [<c1003254>] ? math_state_restore+0x40/0x40
 [<c146a774>] ? check_bugs+0x54/0xdd
 [<c14750ab>] ? proc_root_init+0x8d/0x8f
 [<c1465680>] ? start_kernel+0x27f/0x28e
 [<c14650b0>] ? i386_start_kernel+0xb0/0xb7

in qemu.

 - Arnaud
