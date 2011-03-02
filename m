Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1CBHK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 02:10:59 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49936 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab1CBHK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 02:10:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=G7QQM4Qu55rKAbJt8EedIfYqjpfN3b6Bui3hN1jD8mP2zF4V1GTjH3uuPEW7nG+AG6
         styAppyBnPHZcVL/XDiAuiI02/U6r0ApKgoyQC6bevUeUQqlKTpKPgcozXlrb3fi3F6z
         6pqTyimufUDMh+2ksEClsEXUGryvz3gNt6Ixg=
Date: Wed, 2 Mar 2011 08:10:52 +0100
From: Tejun Heo <tj@kernel.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [RFC] Proposal for ptrace improvements
Message-ID: <20110302071052.GA19669@htj.dyndns.org>
References: <20110301152457.GE26074@htj.dyndns.org>
 <201103011757.48593.vda.linux@googlemail.com>
 <20110301170953.GB17933@htj.dyndns.org>
 <AANLkTi=8=Tw2aYzvwM_s8dsMmw3W_tYjsYkqTHS9moUW@mail.gmail.com>
 <20110301183454.GC23527@mtj.dyndns.org>
 <AANLkTikC=EETfwN+Se+KyETP12nxDGmWSQth_UFS36tJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikC=EETfwN+Se+KyETP12nxDGmWSQth_UFS36tJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Denys.

On Wed, Mar 02, 2011 at 12:51:24AM +0100, Denys Vlasenko wrote:
> > Maybe it should, maybe not, but that's mostly irrelevant because the
> > described behavior is the current behavior.
> 
> This is not a good argument. We are in this discussion exactly because
> there are cases of current behavior in strace and gdb which are clearly
> wrong and which we want to change. Therefore, "it's the current
> behavior" does not automatically mean it is desired behavior.

That actually is the whole point of the proposal and the only viable
way to proceed.  We shouldn't change the kernel so that gdb somehow
magically changes its behavior to fit someone's "should"s.  We fix the
bugs and provide new features which future versions of strace and gdb
can take advantage of to implement better behavior.

So, _NO_, we don't want to make things work magically.

> > There is no
> > continue-if-not-job-control-stopped operation and we shouldn't change
> > that beneath gdb
> 
> I feel that "continue" is meant to be such operation. Currently
> it is not merely because ptrace is buggy.

Again, that's _YOUR_ feeling.  I feel differently and what you or I
feel ultimately is irrelevant because that's a very user-visible
behavior.  We CAN'T change that.  What we can do is providing
mechanisms to userland so that they can implement what they think is
appropriate.

If gdb maintainers think cont should obey job control, fine, but
that's gdb's decision to make.  e.g. gdb can be updated to inform the
user that the tracee entered job control stop instead and ask what the
user wants to do - wait, resume the tracee or send SIGCONT, but these
decisions don't belong in the kernel and we definitely can't and
shouldn't make that happen beneath gdb.

> There is already continue-no-matter-what command in gdb:
> 
> (gdb) signal SIGCONT

Whatever, it doesn't matter.  That's not the current mode of operation
people are used to.  People expect the tracee to resume execution no
matter which condition it was in when they type cont and press enter.
That's it.

> > because otherwise not only the behavior changes
> > unexpectedly
> 
> "strace no longer breaks ^Z" is also an unexpected
> change in behavior. This doesn't mean we should avoid it,
> right?

The proposal doen't change that either.  It _PROVIDES_ ways to
implement better behavior.  It doesn't magically change the existing
behaviors.  That's the whole frigging point.

> Bottom line is: I am not trying to shoot your proposal down.
> It looks good to me.
> 
> I am only discussing it in more detail from the userspace API
> POV and from "what changes will be needed in strace and gdb?"
> and "what improvements in strace and gdb are becoming possible
> with this proposal, and how exactly to implement them there?"
> POVs.

If you were arguing "what change will be needed in userland", we
wouldn't be arguing at all.  You're arguing about changing existing
behavior beneath the current users.  If you're trying to do the
former, I gotta pull a SJ here, you're doing it wrong.

Thanks.

-- 
tejun
