Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1CCHDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:03:25 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57528 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab1CCHDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:03:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cF+wd+i9zn7UZLHTuTPP1MSKWqN6AOSuHCl74NrdeXQKc/qSnljafIDUTK7Ro5DbtT
         pqia64U7cxyLDAiAvhEVB4JwCd6kJdn+K6YKefc+5YHy/RVHE4opNlRh0NFLrdUxYXZJ
         ar5OMPZpuRIOYWPUJhbGBp+/0W3D/dcXoF6zw=
Date: Thu, 3 Mar 2011 08:03:17 +0100
From: Tejun Heo <tj@kernel.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org,
        Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110303070317.GM28266@mtj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <20110302133206.GA9838@redhat.com>
 <0a2c2dfb67198c5bd2cfc6e6c1896f23.squirrel@webmail.greenhost.nl>
 <201103030230.27363.vda.linux@googlemail.com>
 <019ad511a576046f79364a846041a64c.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <019ad511a576046f79364a846041a64c.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Indan.

On Thu, Mar 03, 2011 at 02:55:32AM +0100, Indan Zupancic wrote:
> > It can be argued that after this the task is running _precisely_
> > because it was continued by the debugger.
> 
> That would be an incorrect argument. PTRACE_CONT is supposed to let the
> task continue doing whatever it was doing, and in the case of receiving
> SIGSTOP that was going into a stopped state.

Again, that's your "supposed" which apparently is widely different
depending on who you ask and irrelevant because the currently
implemented visible behavior is completely different.

> Stopped for tracing is not the same as stopped by SIGSTOP! So saying
> to just hang in the traced state is not a good solution. This would
> mean that there are special rules for SIGSTOP handling compared to
> other signals, that's stupid.
> 
> - The tracer shouldn't get that second notification at all if it didn't
>   ask for it.

You're confused about the two notifications.  The first one is signal
delivery notification.  The second one is job control stop
notification.  They are completely separate.

> - It's hard to distinguish a SIGSTOP from an undocumented "task stopping"
>   notification which is lying because the task didn't stop after that
>   event was handled.

It is not difficult to distinguish.  Use GET_SIGINFO.  It has been
like that from the beginning.

> - There is no need or use for this complexity, just pass along SIGSTOP!

No, SIGSTOP delivery and job control stop are two separate steps.

> > The bug is that it can't be continued with SIGCONT after that.
> 
> No, that is a side effect of your buggy work around which proves that
> SIGSTOP doesn't currently work.

You're basically trying to restart the previous discussion from the
beginning.  Go back and read the thread and read the RFC again.

> For a debugger it doesn't matter much, but for anything that tries to be
> unobtrusive like strace this is just madness.

It actually seems pretty sane to me, but if you think it's a madness,
think of it as wiring in front of sensors.  It will help you to accept
it.  Why do you think I spent time writing the RFC?

> > Oleg's proposal is a bit different. It proposes that we do need
> > to do PTRACE_CONT after second SIGSTOP notification too,
> > but task will be indeed stopped after this, and resumed
> > when SIGCONT arrives.
> 
> Please implement Oleg's proposal, anything else is madness.
> 
> Ptrace and task stopping because of SIGSTOP are two independent things
> and should be treated like that, if you want to improve ptrace.

Again, go back, read the thread.  Understand it.  Read the RFC.
Understand it and come back if you still have something to contribute.
You're pretty short on details but long on claims.

Thanks.

-- 
tejun
