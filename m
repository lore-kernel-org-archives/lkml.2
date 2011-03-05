Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab1CEIrO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 03:47:14 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43476 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1CEIrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 03:47:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KZps2Nr/LhAzEF24x57D0iqcY2v2Nobi83Gfj+NrxXdWY1Q+RqS9ujjtpC3fljTWRj
         7/hiu7kzpdTNVVBPtUge2VxQbaKn1sEtsqzqV+oF/ZnnpHgqOZaS/WmjAyN2WMqwMMuE
         tHT5dxXxi9uFSKc1VYEbD3IbObf1tRgMewNqQ=
Date: Sat, 5 Mar 2011 09:47:08 +0100
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110305084708.GE20499@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110301190638.GA12196@host1.dyn.jankratochvil.net>
 <AANLkTiknaHNADRa3R4Tefg2TGuFmKPZY-_08_krFiNFF@mail.gmail.com>
 <20110304161441.GA12987@host1.jankratochvil.net>
 <20110304170737.GA26904@redhat.com>
 <20110304181250.GA31141@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304181250.GA31141@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 07:12:50PM +0100, Jan Kratochvil wrote:
> On Fri, 04 Mar 2011 18:07:37 +0100, Oleg Nesterov wrote:
> > Suppose that the tracee reports, say, a signal after PTRACE_SEIZE/INTERRUPT.
> > And this is possible anyway if the debugger races with kill(). Why this
> > is bad?
> 
> I was asking if it is possible or if it could be avoided.

First of all, if the conditions are distinguishible reliably, I think
things should be fine.  Also, after seizing, at least two conditions
must be distinguishible immediately - whether the tracee was in group
stop or just ptrace trapped, so I don't think guaranteeing single
condition is feasible to begin with.

> When the tracer has a function to attach a task it should be a self-sufficient
> function returning the tracee in some normal task like after other events.
> So the attach operation should neither leave pending some excessive signals
> nor it should eat some normal vital signals (like PTRACE_EVENT_FORK).

That was one of the reasons why I suggested PTRACE_SEIZE to be both
attach and interrupt.  In both cases, the possible states of the task
would be exactly the same.  As debugger is likely to travel various
paths in the interrupt case regularly, it will be much easier to get
it right and once you get that right, attach becomes right at no
additional cost!

> Sure the tracer can always handle it some way, ignore this signal,
> remember if it has seen that signal etc.  But if we design a new
> ptrace interface it should be simple to use and it should not
> suggest coding racy/buggy tracers.

There's no signal to ignore.  It might not be as simple as you fancy
but will (at least strive to) be reliable and race-free.  I think
racy/buggy tracers have a lot more to do with lack of documentation
and clear rules.  Everyone is left to guess and everyone of course
ends up with different conclusions.  Let's add a detailed
documentation of rules and subtleties.

Thanks.

-- 
tejun
