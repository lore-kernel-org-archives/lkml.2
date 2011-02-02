Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1BBSR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:17:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64074 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab1BBSR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:17:58 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=mwaJKvhHZ3QA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=D19gQVrFAAAA:8 a=V5fybmPF-PxOupvM8XkA:9 a=gpwl8YynUTC4k4i_FOUixmbaIhkA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Using ftrace/perf as a basis for generic seccomp
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Eric Paris <eparis@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org,
        agl@google.com, Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        2nddept-manager@sdl.hitachi.co.jp
In-Reply-To: <20110202175556.GA13948@elte.hu>
References: <1294867725.3237.230.camel@localhost.localdomain>
	 <AANLkTi=tmzKqLL30q9Mq+9u7s-M3sG2-MKz7pUJ1R08Z@mail.gmail.com>
	 <4D494AB1.1040508@hitachi.com> <20110202122620.GA11427@elte.hu>
	 <1296665124.3145.17.camel@localhost.localdomain>
	 <20110202175556.GA13948@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 02 Feb 2011 13:17:55 -0500
Message-ID: <1296670675.10797.58.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 18:55 +0100, Ingo Molnar wrote:

> The filter expression engine executes in the kernel, when the event happens. The 
> user-space perf tool parses the --filter parameter and passes it to the kernel as a 
> string in essence. The kerner parses this into atomic predicaments which are linked 
> to the event structure. When the event happens the predicaments are executed by the 
> filter engine.
> 
> The expressions are simple, but rather flexible, so you can do 'fd==0||fd==1' and 
> more complex expressions, etc. The engine could also be extended.
> 
> The kernel code is mostly in kernel/trace/trace_events_filter.c.
> 
> I've Cc:-ed Tom, Frederic, Steve, Li Zefan and Arnaldo who have worked on the filter 
> engine, in case something is broken with this functionality or if there are other 
> questions :)

Yep, and I'm currently working on them as well. As they currently have a
32 pred limit (may seem like a lot, but I actually hit it). And I've
also added short circuits (0 && .... no need to process more).

I posted an RFC:

https://lkml.org/lkml/2011/1/27/438

and I'm again working on finishing it. Just a few more things to do. I
got side tracked because my employer actually asked me to do something
for them ;)

-- Steve


