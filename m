Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab0HNAoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 20:44:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:52711 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab0HNAoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 20:44:16 -0400
Date: Fri, 13 Aug 2010 17:11:58 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [0/3] 2.6.27.52 stable review
Message-ID: <20100814001158.GA2849@suse.de>
References: <20100813214704.GA18960@kroah.com>
 <p5ib66db7ilijjesu4dd3b351dtmsk175f@4ax.com>
 <20100813230712.GA1703@suse.de>
 <t5mb661vmb2a33gev3tqki89410a0795kc@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <t5mb661vmb2a33gev3tqki89410a0795kc@4ax.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 09:47:08AM +1000, Grant Coady wrote:
> Hi Greg,
> 
> I scraped the patches out of the messages and edited Makefile :)
> 
> On Fri, 13 Aug 2010 16:07:12 -0700, you wrote:
> 
> >On Sat, Aug 14, 2010 at 08:36:34AM +1000, Grant Coady wrote:
> >> On Fri, 13 Aug 2010 14:47:04 -0700, you wrote:
> >> 
> >> >NOTE!
> >> >
> >> >If I could get some people to please test this -rc release?  It contains
> >> >a few core changes that I couldn't validate myself as I don't seem to
> >> >have a machine that will even boot the .27 kernel anymore after my move.
> 
> Machine is running, but there's a lot of these in the dmesg:
> 
> WARNING: at include/linux/security.h:1826 acct_stack_growth+0xe7/0xf0()
> Modules linked in:
> Pid: 320, comm: khelper Not tainted 2.6.27.52-rc1a #57
>  [<c011b54f>] warn_on_slowpath+0x5f/0x90
>  [<c0145a53>] __alloc_pages_internal+0x93/0x420
>  [<c01456bd>] buffered_rmqueue+0x11d/0x210
>  [<c015e09a>] allocate_slab+0x4a/0xd0
>  [<c015e149>] setup_object+0x29/0x30
>  [<c015e204>] new_slab+0xb4/0x130
>  [<c015e6ec>] __slab_alloc+0xac/0x120
>  [<c01529e7>] acct_stack_growth+0xe7/0xf0
>  [<c0152afa>] expand_stack+0x7a/0x90
>  [<c014fc61>] do_anonymous_page+0x121/0x130
>  [<c0150268>] handle_mm_fault+0x1b8/0x1e0
>  [<c014e724>] get_user_pages+0xe4/0x270
>  [<c0166ac9>] get_arg_page+0x49/0xc0
>  [<c0166e5b>] copy_strings+0xdb/0x180
>  [<c0166f29>] copy_strings_kernel+0x29/0x40
>  [<c0167dae>] do_execve+0xde/0x1d0
>  [<c0101f1f>] sys_execve+0x2f/0x60
>  [<c0103036>] syscall_call+0x7/0xb
>  [<c011007b>] ioapic_register_intr+0x10b/0x110
>  [<c0106bfc>] kernel_execve+0x1c/0x30
>  [<c0128efc>] ____call_usermodehelper+0x5c/0xc0
>  [<c0128ea0>] ____call_usermodehelper+0x0/0xc0
>  [<c0103b1b>] kernel_thread_helper+0x7/0x1c
>  =======================
> ---[ end trace 62e879f3daf4be6a ]---

I'm guessing that 2.6.27.51 didn't cause those warnings as well?

That's a warning that current->mm is null.  I don't know enough about
the mm subsystem to say if this is normal or not, and I don't at first
glance, see how this patch could have caused this to happen.

Anyone else have an idea?

thanks,

greg k-h
