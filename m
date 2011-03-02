Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1CBOu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:50:59 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45822 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1CBOu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:50:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tvCufTI05pb/tZIEo/uPuPslMbP7VNVh0+sTfAM8FoPcwE6AYdmaWrz6vmVBBi3wbs
         N2hedlMmXJyEnj5RhMTFy8dLvrJcdL8Sl/B1ehsUgGLWVV/5Mkd8hG98GoJDEdMi9aBw
         bEKqOv7c4+WpctaxdUKdbUfh52wnMYRgTxqtQ=
Date: Wed, 2 Mar 2011 15:50:48 +0100
From: Tejun Heo <tj@kernel.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110302145048.GK3319@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <201103011757.48593.vda.linux@googlemail.com>
 <20110301170953.GB17933@htj.dyndns.org>
 <AANLkTi=8=Tw2aYzvwM_s8dsMmw3W_tYjsYkqTHS9moUW@mail.gmail.com>
 <20110301183454.GC23527@mtj.dyndns.org>
 <830cc1666bd4a610d5e870218f06bd2d.squirrel@webmail.greenhost.nl>
 <20110302074447.GE19669@htj.dyndns.org>
 <6b211a19ed02fa7f001343fbd8e3d5a9.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b211a19ed02fa7f001343fbd8e3d5a9.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Mar 02, 2011 at 12:32:36PM +0100, Indan Zupancic wrote:
> What might happen is that, because the current code handles the traced
> task as stopped, the new SIGSTOP signal is first added and then cleared
> when the task continues. This doesn't explain the double SIGSTOP
> notifications, I'd expect it to either loop indefinitely or to not
> notify the SIGSTOP twice.

That happens with any stopping signals.  They're two different
notifications for two different events.  Please read the original
thread referenced in the RFC for details.

>  "When waitpid indicates stop on a *stop* signal, then it may be either:
>  * a signal delivery (strace will inject this signal with PTRACE_SYSCALL(sig));
>  * or it may be a stop notification, in which case strace *must not*
>    try to inject this signal (this would be a bug, it'd make task running).
>    Instead, strace should just go back to waiting in waitpid().
> 
>  These two possibilities can be distinquished by querying
>  PTRACE_GETSIGINFO. On stop notifications, PTRACE_GETSIGINFO
>  errors out - stop notification is not a signal delivery
>  and therefore it has no siginfo."
> 
> End quote.
> 
> You don't get the second case when not setting the WUNTRACED flag.

WUNTRACED is ignored while ptracing.

> > Again, not following.  In the proposal, job control and ptrace operate
> > independently, so on that we seem to agree, but I can't understand
> > where the STOP signal for the parent comes from?  What are you
> > referring to?
> 
> What I mean is, if you have a parent P with a child C, and C is ptraced by T,
> P shouldn't get SIGSTOP notifications when it waits for C with WUNTRACED set
> and C is stopped because of a ptrace event.

Yeah, sure, what I'm confused about is why you're bringing that up.
Nothing changes anything related to that.  There's no reason to bring
it up.  Am I missing something?

Thanks.

-- 
tejun
