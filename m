Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab0JUNcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 09:32:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757016Ab0JUNcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 09:32:02 -0400
Subject: Re: Ftrace: can trace kthread?
From: Steven Rostedt <srostedt@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, rostedt@goodmis.org
Cc: "Figo.zhang" <zhangtianfei@leadcoretech.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1287655927.3488.100.camel@twins>
References: <1287647732.2237.7.camel@myhost>
	 <AANLkTim7g+8_rQSyewC6n_5WmC04kU-rj1g9k61=O2Vm@mail.gmail.com>
	 <1287649283.2237.8.camel@myhost>
	 <AANLkTikzSZNtTGfOcP-87u+pMZyW8WrdxwV52ZV3f=nX@mail.gmail.com>
	 <1287650668.2237.12.camel@myhost>
	 <AANLkTi=D_a_BH-HW9mqwLim+DjxARWzT8mxP_dah5iLY@mail.gmail.com>
	 <1287651542.2237.17.camel@myhost>  <1287655927.3488.100.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Thu, 21 Oct 2010 09:31:41 -0400
Message-ID: <1287667901.2824.13.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 12:12 +0200, Peter Zijlstra wrote:
> On Thu, 2010-10-21 at 16:59 +0800, Figo.zhang wrote:
> > > I just
> > > echo  0 > tracing_enabled

I need to remove that file. "tracing_enabled" is pretty much deprecated,
just use tracing_on to enable and disable the trace recording.

> > > echo function > current_tracer
> > > echo 374(pid of flush) > set_ftrace_pid
> > > echo 1 > tracing_enabled
> > > wait some time
> > > echo 0 > tracing_enabled
> > > cat trace
> > > 
> > > So I think this answer your question "could kthread be traced?"
> > 
> > i do it the same of you.
> 
> > but i canot trace nothing. 
> 
> Your initial attempt had:
> 
>         echo kswapd > /sys/kernel/debug/tracing/set_graph_function

Yeah, that wont work. That's because kswapd() is called at system
startup and goes into a loop. The function graph tracer will never see
that function again (it's not called again). It can't know what function
it is in, only what functions it enters.

-- Steve

> 
> have you reset that state?


