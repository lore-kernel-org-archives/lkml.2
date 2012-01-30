Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2A3PH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:07:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45663 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab2A3PHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:07:42 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0ow4NSV8tcgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=LaRNS1r_4HzIRXcygL4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327936060.22710.165.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/5 v2] [GIT PULL] x86/jump label: Paranoid checks and 2
 or 5 byte nops
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 30 Jan 2012 10:07:40 -0500
In-Reply-To: <20120130144857.GA22013@elte.hu>
References: <20120128160925.275163704@goodmis.org>
	 <20120130144857.GA22013@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-30 at 15:48 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Ingo,
> > 
> > This is the second round with the suggestions made by Peter 
> > and Andrew incorporated (and tested).
> 
> they are crashing my testbox:
> 
> Policy zone: DMA32
> Kernel command line: root=/dev/sda6 earlyprintk=ttyS0,115200 
> console=ttyS0,115200 debug initcall_de
> bug sysrq_always_enabled ignore_loglevel selinux=0 
> nmi_watchdog=1 panic=1 3
> sysrq: sysrq always enabled.
> PANIC: early exception 06 rip 10:ffffffff8101546d error 0 cr2 
> f06f53
> Pid: 0, comm: swapper Not tainted 
> 3.3.0-rc1-tip-02083-ga5066f8-dirty #170372
> Call Trace:
>  [<ffffffff8101546d>] ? __jump_label_transform+0x81/0x14e
>  [<ffffffff81063ee4>] ? try_to_wake_up+0x1f8/0x2cc
>  [<ffffffff8184d19e>] early_idt_handler+0x5e/0x71
>  [<ffffffff8101546d>] ? __jump_label_transform+0x81/0x14e
>  [<ffffffff81015457>] ? __jump_label_transform+0x6b/0x14e
>  [<ffffffff810155f8>] arch_jump_label_transform_static+0x6f/0x77
>  [<ffffffff81865162>] jump_label_init+0x68/0x98
>  [<ffffffff8184d98b>] start_kernel+0x182/0x3b8
>  [<ffffffff8184d2c3>] x86_64_start_reservations+0xae/0xb2
>  [<ffffffff8184d40d>] x86_64_start_kernel+0x146/0x153
> RIP __jump_label_transform+0x81/0x14e
> 
> Do you need the config or is the bug obvious at first sight?

Could you post the exact line of that address?

<ffffffff8101546d>

I know there was some work to default enable some code. I'm not sure how
much made it in. I'm thinking the line you triggered was:
		/*
		 * The location is not a nop that we were expecting,
		 * something went wrong. Crash the box, as something could be
		 * corrupting the kernel.
		 */
		BUG();


It hits this if we enable a nop that is not what we expect it to be.

Yeah, send me the config too, and I'll run this against tip/master with
all the patches applied.

Thanks!

-- Steve


