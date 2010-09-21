Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab0IUPfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:35:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51962 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab0IUPf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:35:29 -0400
X-Authority-Analysis: v=1.1 cv=xllhIT3+0iZermAJQK9ulaVoiSOvD1gApk/LON5m1IU= c=1 sm=0 a=Ci446elm3-IA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=WpOxxcYV05c6l4cKtwoA:9 a=DSq63hbqmpWLkdaEpuuzymTsB88A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 08/10] jump label v11: x86 support
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Baron <jbaron@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, mhiramat@redhat.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, vgoyal@redhat.com,
        sam@ravnborg.org, tony@bakeyournoodle.com
In-Reply-To: <20100921152957.GA23380@elte.hu>
References: <cover.1284733808.git.jbaron@redhat.com>
	 <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com>
	 <4C981BC4.90405@zytor.com> <20100921152525.GC2873@redhat.com>
	 <20100921152957.GA23380@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 21 Sep 2010 11:35:24 -0400
Message-ID: <1285083324.23122.1955.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 17:29 +0200, Ingo Molnar wrote:

> > >From the documentation patch:
> > 
> > " The optimization depends on !CC_OPTIMIZE_FOR_SIZE. When 
> > CC_OPTIMIZE_FOR_SIZE is set, gcc does not always out of line the not 
> > taken label path in the same way that the "if unlikely()" paths are 
> > made out of line. Thus, with CC_OPTIMIZE_FOR_SIZE set, this 
> > optimization is not always optimal. This may be solved in subsequent 
> > gcc versions, that allow us to move labels out of line, while still 
> > optimizing for size. "
> 
> OTOH making a difficult optimization (HAVE_ARCH_JUMP_LABEL) dependent on 
> compiler flags is really asking for trouble.
> 
> So how about enabling it unconditionally, and just chalk up the cost 
> under CC_OPTIMIZE_FOR_SIZE as one of the costs it already has? This also 
> has the advantage that future compilers can improve things without 
> having to wait for yet another kernel patch that re-enables 
> HAVE_ARCH_JUMP_LABEL.

Agreed,

CC_OPTIMIZE_FOR_SIZE does not mean OPTIMIZE_FOR_PERFORMANCE. Although
people have argued that with smaller size you gain better cache
performance. I've noticed that the general case is that optimizing for
size has decreased performance (although I have not done any official
benchmarks, just my own personal observations).

I thought you may have had that there because OPTIMIZE_FOR_SIZE actually
broke the code (as some gcc compilers do for function graph tracer). If
its just a "we don't perform better with this set". Then get rid of it.

Thanks,

-- Steve


