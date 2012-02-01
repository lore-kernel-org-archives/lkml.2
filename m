Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2BADo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 22:44:29 -0500
Received: from ozlabs.org ([203.10.76.45]:51516 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab2BADo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 22:44:27 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
In-Reply-To: <20120131122016.GF32010@elte.hu>
References: <1327545664.22710.78.camel@gandalf.stny.rr.com> <20120126102836.GD3853@elte.hu> <1327585945.22710.87.camel@gandalf.stny.rr.com> <20120126135504.GA13107@elte.hu> <1327586669.22710.89.camel@gandalf.stny.rr.com> <1327588606.22710.100.camel@gandalf.stny.rr.com> <20120126183946.GA14709@elte.hu> <87ehuldf0m.fsf@rustcorp.com.au> <1327924333.22710.157.camel@gandalf.stny.rr.com> <87sjiwjzew.fsf@rustcorp.com.au> <20120131122016.GF32010@elte.hu>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 01 Feb 2012 11:40:22 +1030
Message-ID: <87lionjr41.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jan 2012 13:20:16 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> > Wow, we're really bikeshedding this!
> 
> Hey, I don't think this is bikesheddig: we are shedding 
> *kilobytes* of code from pretty hot codepaths, that kind of 
> topic does deserve some detailed attention :-)

I agree, but we put the bloat in without this much discussion :)

I get the impression last I looked that most get/put aren't actually hot
paths (though it was designed to allow that, such as an inc per packet).
Which is an even better reason to out-of-line it...

> > Doesn't save me much here, though.  What are your stats?
> 
> I suspect it depends on inlining options in the .config plus on 
> event tracing?
...
> Most distro kernels do tracepoints so I guess that's where the 
> size delta comes from :-) In any case:
> 

Yeah, I'm rebuilding an Ubuntu config kernel before and after to get
some more accurate stats on the final result for the commit message.

> Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,
Rusty.
