Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab0KXMrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 07:47:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60634 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab0KXMrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 07:47:40 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=dloADZ4KP7gA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=2NBdsOTBWeKKZg1EIqkA:9 a=gz64nLcHZ_JPiqfHr06T4UU52gUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/3] jump label: updates for 2.6.37
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <1290587362.2072.429.camel@laptop>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <1290548527.30543.401.camel@gandalf.stny.rr.com>
	 <20101123215604.GC4715@redhat.com>
	 <1290553854.30543.406.camel@gandalf.stny.rr.com>
	 <1290587362.2072.429.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 24 Nov 2010 07:47:36 -0500
Message-ID: <1290602856.30543.465.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 09:29 +0100, Peter Zijlstra wrote:
> On Tue, 2010-11-23 at 18:10 -0500, Steven Rostedt wrote:
> 
> > Anyway, I just tried what you explained with the current kernel, with
> > and without jump labels and, without jump labels, the module has its
> > kmalloc tracepoint traced, but with jump labels it does not. So we can
> > treat this as a regression, which is something that can go into an -rc.
> > 
> > The change log must state that this _is_ a regression, or Linus may not
> > accept it.
> 
> I really dislike the first patch... Preferably I'd simply fully revert
> all the jump-label stuff and try again next round with a saner
> interface.

Well, it is configurable and default off. Lets leave it as is for 37
then, and we can rework it for 38.

> 
> There's a really good simple fix for this, simply disable the gcc
> trickery for .37 and use the fallback.

Again, its default off. Unless you specifically enable it, it does the
old style tracepoints.

> 
> Then for .38, mandate the key type to be atomic_t * and switch to the
> SWITCH_POINT() interface from hpa.

I agree about the SWITCH_POINT() type interface, but I'm still not sure
about forcing atomic_t. I'll have to think about that one.

-- Steve


