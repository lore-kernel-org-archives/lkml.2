Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965805Ab2EOWMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 18:12:30 -0400
Received: from joshcartwright.net ([69.164.192.171]:33669 "EHLO
	li107-171.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964948Ab2EOWM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 18:12:29 -0400
X-Greylist: delayed 2167 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2012 18:12:28 EDT
Date: Tue, 15 May 2012 17:36:19 -0400
From: Josh Cartwright <joshc@linux.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH -rt] mm: protect activate_mm() by
 preempt_[disable|enable]_rt()
Message-ID: <20120515213619.GA8880@joshcartwright.net>
References: <1337061236-1766-1-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337061236-1766-1-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 01:53:56PM +0800, Yong Zhang wrote:
> From: Yong Zhang <yong.zhang@windriver.com>
>
> Otherwise there will be warning on ARM like below:
>
> WARNING: at build/linux/kernel/smp.c:459 smp_call_function_many+0x98/0x264()
> Modules linked in:
> [<c0013bb4>] (unwind_backtrace+0x0/0xe4) from [<c001be94>] (warn_slowpath_common+0x4c/0x64)
> [<c001be94>] (warn_slowpath_common+0x4c/0x64) from [<c001bec4>] (warn_slowpath_null+0x18/0x1c)
> [<c001bec4>] (warn_slowpath_null+0x18/0x1c) from [<c0053ff8>](smp_call_function_many+0x98/0x264)
> [<c0053ff8>] (smp_call_function_many+0x98/0x264) from [<c0054364>] (smp_call_function+0x44/0x6c)
> [<c0054364>] (smp_call_function+0x44/0x6c) from [<c0017d50>] (__new_context+0xbc/0x124)
> [<c0017d50>] (__new_context+0xbc/0x124) from [<c009e49c>] (flush_old_exec+0x460/0x5e4)
> [<c009e49c>] (flush_old_exec+0x460/0x5e4) from [<c00d61ac>] (load_elf_binary+0x2e0/0x11ac)
> [<c00d61ac>] (load_elf_binary+0x2e0/0x11ac) from [<c009d060>] (search_binary_handler+0x94/0x2a4)
> [<c009d060>] (search_binary_handler+0x94/0x2a4) from [<c009e8fc>] (do_execve+0x254/0x364)
> [<c009e8fc>] (do_execve+0x254/0x364) from [<c0010e84>] (sys_execve+0x34/0x54)
> [<c0010e84>] (sys_execve+0x34/0x54) from [<c000da00>] (ret_fast_syscall+0x0/0x30)
> ---[ end trace 0000000000000002 ]---
>
> The reason is that ARM need irq enabled when doing activate_mm().
> According to mm-protect-activate-switch-mm.patch, actually
> preempt_[disable|enable]_rt() is sufficient.

Frank Rowand posted a very similar fix in December of last year that
we've been carrying to fix the same issue:

   http://permalink.gmane.org/gmane.linux.kernel/1229806

It looks like there was some deliberation as to whether or not it should
be pulled into stable-rt.  Perhaps its time to revisit this discussion?

-- 
                                             joshc
