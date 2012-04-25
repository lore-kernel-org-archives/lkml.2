Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab2DYPYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:24:05 -0400
Received: from mail1.windriver.com ([147.11.146.13]:35715 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab2DYPYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:24:02 -0400
Message-ID: <4F9816F3.8040302@windriver.com>
Date: Wed, 25 Apr 2012 10:23:31 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] kgdb: Do not allow function tracing of kgdb code
References: <1335367093.28106.165.camel@gandalf.stny.rr.com>
In-Reply-To: <1335367093.28106.165.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 10:18 AM, Steven Rostedt wrote:
> As function tracing the kgdb code can cause issues, as kgdb is a
> debugger itself, do not trace the kgdb functions.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 532d2e0..b7828ce 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -15,6 +15,7 @@ CFLAGS_REMOVE_pvclock.o = -pg
> CFLAGS_REMOVE_kvmclock.o = -pg
> CFLAGS_REMOVE_ftrace.o = -pg
> CFLAGS_REMOVE_early_printk.o = -pg
> +CFLAGS_REMOVE_kgdb.o = -pg
> endif
>
> obj-y := process_$(BITS).o signal.o entry_$(BITS).o
>
>

Per our off mailing list discussion, I absolutely agree.

This came up in the course of looking through the new code proposed
around removing the stop machine for ftrace.

Acked-by: Jason Wessel <jason.wessel@windriver.com>

Cheers,
Jason.
