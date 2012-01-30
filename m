Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2A3LwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 06:52:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55555 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2A3LwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 06:52:16 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=0LOP1KteNnsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=33GYsNxS1zUl5TSjGL4A:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327924333.22710.157.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] tracing/module: Move tracepoint out of module.h
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>
Date: Mon, 30 Jan 2012 06:52:13 -0500
In-Reply-To: <87ehuldf0m.fsf@rustcorp.com.au>
References: <1326807145.17534.26.camel@gandalf.stny.rr.com>
	 <20120118120711.GB14863@elte.hu>
	 <1326909412.17534.91.camel@gandalf.stny.rr.com>
	 <877h0jgx80.fsf@rustcorp.com.au>
	 <1327545664.22710.78.camel@gandalf.stny.rr.com>
	 <20120126102836.GD3853@elte.hu>
	 <1327585945.22710.87.camel@gandalf.stny.rr.com>
	 <20120126135504.GA13107@elte.hu>
	 <1327586669.22710.89.camel@gandalf.stny.rr.com>
	 <1327588606.22710.100.camel@gandalf.stny.rr.com>
	 <20120126183946.GA14709@elte.hu> <87ehuldf0m.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 13:32 +1030, Rusty Russell wrote:
> On Thu, 26 Jan 2012 19:39:46 +0100, Ingo Molnar <mingo@elte.hu> wrote:
> > Ok, i like this one best. Rusty, does it look good to you too?
> 
> No, the if (module) test belongs in the inline wrapper (since gcc knows
> that at compile time).

For some reason though it still adds 5K when we keep the code as a
static inline. Note, my test config does have all the necessary modules
to boot the box as compiled in (not as modules). If necessary, I could
compile with a distro config and see what the differences are with that.

Rusty, the final decision is yours. If you believe that the added code
size is worth having the static inlines, then I'll go back to the
previous version that had that.

I'll compile with a distro config, and then take a look at the
differences of the vmlinux.

Thanks,

-- Steve


