Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab1CBL2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:28:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35162 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1CBL2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:28:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=d5DGQUUVcDkmSJ5U5l63UEGa1Vdcsr7MU5g/DylU/fVIk7vPVQAm8M+gadvSUNsJ2G
         5G2S5/aTQWivD4DmwQfSvtKxKcVVQNn8E0mlniVdprbBpQDzHqEVTWbJ6pEfrlHJIakl
         pZ7O1W8bhIS0Mg6tgByyN53ooaEagpAVgqOrk=
Date: Wed, 2 Mar 2011 12:27:56 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110302112756.GI3319@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <AANLkTi=cUM9S5M7h0unMfbQ88CzqhoDN9CUEVf_9HrdS@mail.gmail.com>
 <20110302073727.GD19669@htj.dyndns.org>
 <AANLkTimA8wtM4sJu1SMVuOaNXyxEtLcfaj7kJf2NovAd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimA8wtM4sJu1SMVuOaNXyxEtLcfaj7kJf2NovAd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 12:21:28PM +0100, Denys Vlasenko wrote:
> > I think WSTOPSIG should be SIGTRAP as the tracee left group stop and
> > entered ptrace trap.
> 
> This would be, by my count, 13th kind of SIGTRAP use by ptrace.
> Which makes multi-level if's in debuggers even more complex
> and more error-prone.

Of course, all ptrace traps are SIGTRAPs.

> Why not SIGCONT? This event is, after all, caused by SIGCONT.
> It would be so much nicer to be able to detect it with single if()
> in the debugger...

I disagree.  It's a ptrace trap.  It should use SIGTRAP.  We just need
well defined siginfo output to distinguish between them.  It's not
like we can avoid siginfo anyway.

> > No, it's not a signal delivery notification.  It's a ptrace trap
> > notification.  SIGCONT may not be delivered to this task.  Please
> > remember that it's the emission of SIGCONT which ends a group stop,
> > not delivery.
> 
> From userspace POV it's really a kernel's implementation detail.

Not really.  This is actually a visible difference.  Roland wrote in
the previous discussion.  One visible difference is that ptrace can
veto job control stop but it can't veto the end of job control.  Job
control actions happen before SIGCONT hits the signal delivery path
which is visible through ptrace.

> >> (b) does PTRACE_CONT(<other_sig>)? or
> >> (c) does PTRACE_CONT(0)?
> >
> > See above.
> 
> This means that SIGCONT handler will be executed in the tracee
> after debugger does PTRACE_CONT(<any_signo>) at this point.
> 
> Which makes SIGCONT special: debugger can suppress execution
> of other signal handlers in tracee, but not SIGCONT handler.
> Another special case. Can we avoid having it?

Hmmm.... I think you're confused about how SIGCONT is handled or maybe
I am.  Either way, please elaborate.  I can't really follow.

Thanks.

-- 
tejun
