Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1CBHox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:44:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54533 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1CBHov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:44:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ah5MNyIXksn/BSSNbqzjiDqtyQgBUPvciob37BD4cMwp62aScylLnPAJGUAFtNgt+N
         QTy1fat+zfaVzLrNQVCXEKgocYYmjIaPlrLJydouvdgqTs4+c0RPgfYxpRhHqRl+K7I4
         N1WMgIO+btLFmt4PPxwB3DTwLRMAPjRGPPz8U=
Date: Wed, 2 Mar 2011 08:44:47 +0100
From: Tejun Heo <tj@kernel.org>
To: Indan Zupancic <indan@nul.nu>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110302074447.GE19669@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <201103011757.48593.vda.linux@googlemail.com>
 <20110301170953.GB17933@htj.dyndns.org>
 <AANLkTi=8=Tw2aYzvwM_s8dsMmw3W_tYjsYkqTHS9moUW@mail.gmail.com>
 <20110301183454.GC23527@mtj.dyndns.org>
 <830cc1666bd4a610d5e870218f06bd2d.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <830cc1666bd4a610d5e870218f06bd2d.squirrel@webmail.greenhost.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 06:07:35AM +0100, Indan Zupancic wrote:
> I'm not sure what Denys is talking about: Currently it's impossible to
> pass along SIGSTOP to traced processes. Quoting the ptrace manpage:
> 
>    PTRACE_CONT
>           Restarts  the stopped child process.  If data is nonzero and not
>           SIGSTOP, it is interpreted as a signal to be  delivered  to  the
>           child;  otherwise,  no  signal is delivered.

AFAICS, that's not true.  SIGSTOP isn't treated differently from other
signals in the ptrace signal delivery path.  Maybe it was true in the
past.

> As for distinguishing STOP signals from stopped childs: Just don't set
> the WUNTRACED flag in the tracer for waitpid.

I'm not following.  Can you please elaborate?

> To me it seems clear that job ctl state should be managed independently
> of ptrace stopped state.  I'm not sure how that fits in with your
> proposed changes, but my impression is that you make everything a lot
> simpler by separating traced stopping/continuing from SIGSTOP/SIGCONT
> job control. It's just not the same. A task stopped by a trace event
> shouldn't generate a STOP signal for it's parent, only for real SIGSTOPS.

Again, not following.  In the proposal, job control and ptrace operate
independently, so on that we seem to agree, but I can't understand
where the STOP signal for the parent comes from?  What are you
referring to?

Thanks.

-- 
tejun
