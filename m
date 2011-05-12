Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab1ELRIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:08:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757918Ab1ELRH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:07:58 -0400
Date: Thu, 12 May 2011 19:06:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 04/11] ptrace: implement PTRACE_INTERRUPT
Message-ID: <20110512170617.GB20215@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-5-git-send-email-tj@kernel.org> <20110509165857.GA30607@redhat.com> <20110510095022.GR1661@htj.dyndns.org> <20110510140620.GB21834@redhat.com> <20110510142033.GY1661@htj.dyndns.org> <20110510180811.GB32637@redhat.com> <20110511082947.GB1661@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511082947.GB1661@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Tejun Heo wrote:
>
> On Tue, May 10, 2011 at 08:08:11PM +0200, Oleg Nesterov wrote:
> >
> > Hmm. Suddenly I got lost. Perhaps instead JOBCTL_TRAP_INTERRUPT should
> > be cleared on any trap too, like SEIZE.
>
> I don't think that's a good idea especially because there are
> functionality differences among different traps.  ie. group stop and
> interrupt traps support re-trapping on job control events while other
> traps don't, so there will be cases where the debugger wants to put
> tracee specifically into INTERRUPT trap.  It's just cleaner to use and
> say that if you ask for INTERRUPT, you get an INTERRUPT.

Hmm. This is not clear to me... OK, I'll read other emails first.

> > Another special (and nasty!) case is PTRACE_TRACEME. I do not know
> > how often it is used, but probabaly it is important enough. At least,
> > iirc, it is used by strace. Probably we need PTRACE_SEIZEME as well.
>
> I don't agree.  PTRACE_TRACEME predates PTRACE_ATTACH and is
> completely redundant.  If you can make the child do PTRACE_TRACEME,
> you might as well just make it do pause() and PTRACE_SEIZE yourself,
> so unless there's something PTRACE_SEIZE can't do, I don't think I'll
> be adding SEIZEME.

Heh. I think that you are very right technically and I thought the
same. That is why I never mentioned PTRACE_TRACEME before. In fact
I never understood why PTRACE_TRACEME exists.

However. Perhaps this is wrong from the practical pov. SEIZEME can
simplify the conversion of the existing code. People are lazy, but
we need the users of PTRACE_SEIZE.

Anyway. SEIZEME is absolutely trivial. We can add it at any moment,
right now this is almost offtopic.

Oleg.

