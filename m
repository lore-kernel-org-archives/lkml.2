Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391Ab1HPTmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:42:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48216 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1HPTmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:42:09 -0400
Date: Tue, 16 Aug 2011 21:42:04 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 0/3] make vfork killable
Message-ID: <20110816194204.GF2803@mtj.dyndns.org>
References: <20110727163159.GA23785@redhat.com>
 <20110729192358.GB31717@mtj.dyndns.org>
 <20110812175550.GA7484@redhat.com>
 <20110813161814.GE4254@htj.dyndns.org>
 <20110815194209.GA19239@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815194209.GA19239@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Mon, Aug 15, 2011 at 09:42:09PM +0200, Oleg Nesterov wrote:
> > * Regular job control and ptrace.
> > * vfork wait.
> > * cgroup freeze.
> 
> I still can't understand what exactly you have in mind.
>
> And to me vfork() is closer to nanoslep() than to cgroup_freezer.
> (As for cgroup_freezer, I agree it would be nice to reimplent it
>  in any case).

Maybe, it would be better to handle vfork() that way.  I'm not sure,
but if we can handle all three waits in the same manner, that would be
a plus too.  I'll think more about it.

> > The downside is that that wouldn't work with cgroup freeze at
> > all - there's no syscall to restart.
> 
> Sure. Still I don't understand why restart is not suitable for vfork
> and why it would be better to unify freezer/vfork.

It's still in the works but the user visible behavior is more
consistent both with and without ptrace.  I'm still trying to wrap my
head around consolidating freezer into it.  Let's see how it fans out.

> OK. Let's discuss this later, I hope you will cc me ;)

Oh, no need to worry about that. :)

> But what do you think about this series? It is simple, it doesn't
> play with restarts. In some sense it even simplifies the code because
> it removes one user of ->vfork_done. I don't think these patches can
> complicate the further changes you are going to do.
> 
> No?

Was too lost in the freezer land.  Will review first thing tomorrow.

Thank you.

-- 
tejun
