Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2FZUoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:44:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62161 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab2FZUoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:44:04 -0400
Date: Tue, 26 Jun 2012 22:43:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Kay Sievers <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v2] printk: Have printk() never buffer its data
Message-ID: <20120626204358.GA11771@gmail.com>
References: <1340630505.27036.294.camel@gandalf.stny.rr.com>
 <20120625135611.GA1301@gmail.com>
 <1340634366.27036.324.camel@gandalf.stny.rr.com>
 <CAPXgP13=4fgTuL3fawZUV+Khzx=RK9froKe-iD5KBY1c8wWVGw@mail.gmail.com>
 <1340639741.27036.337.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340639741.27036.337.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> >  It also sounds like quite a lot of wasted headers in the 
> > buffer, which we need to carry around and throw away when we 
> > reconstruct the line for output again. If we merge them 
> > internally we mess around with the sequence numbers, if we 
> > merge them in userspace we would need to export the flags to 
> > do that.
> 
> As I'm still on debian and fedora 14, I have to admit that I 
> do not quite understand exactly what you are trying to do with 
> systemd or your logging facility. But it seems to become clear 
> that printk isn't a tool for it.
> 
> What exactly are you trying to record from the kernel? Device 
> information, kernel diagnostics, or something else? Maybe 
> there should be another facility besides printk that can pass 
> what you want to your utilities.
> 
> printk is the first line of attack for kernel developers to 
> find their bugs. If it becomes bloated and focused on users, 
> it will make development of the kernel much more difficult.
> 
> Perhaps we should have added a hook or a tracepoint at the 
> beginning of printk that your logging facility could attach 
> to, [...]

That was my immediate suggestion very early on in the printk 
discussion, months ago, when Kay was still giving us nightmares 
about UUID printk's and other nonsense.

Adding the printk tracepoint and feeding it to kmesg would have 
been a few trivial lines of code plus tracing code reuse, it 
would have made a ton of sense and it would have enhanced 
tracing and profiling as well, not just kmdesg/syslogd-ng.

I guess the triviality of it must have been one of the reasons 
why it wasn't implemented that way ;-)

Today I'd be happy with at least having clean separation of a 
direct, relatively simple printk() from whatever special purpose 
new logging facilities feed off of printk().

Thanks,

	Ingo
