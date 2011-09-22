Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334Ab1IVPX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 11:23:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51516 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1IVPX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 11:23:56 -0400
Date: Thu, 22 Sep 2011 10:23:46 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110922152346.GA18731@peqn>
References: <20110919214531.GA18085@sergelap>
 <20110920174849.GB22317@redhat.com>
 <20110920185354.GA19629@sergelap>
 <20110921175357.GA25590@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921175357.GA25590@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 09/20, Serge E. Hallyn wrote:
> >
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > On 09/19, Serge E. Hallyn wrote:
> > > >
> > > > __send_signal: convert the uid being sent in SI_USER to the target task's
> > > > user namespace.
> > > >
> > > > do_notify_parent and do_notify_parent_cldstop: map task's uid to parent's
> > > >  user namespace
> > > >
> > > > ptrace_signal: map parent's uid into current's user namespace before
> > > > including in signal to current.
> > >
> > > Btw, what about the other users of ->si_uid? Say, kill() or tkill().
> >
> > Well, they end up calling __send_signal().
> 
> Sure. But your patch changes only the __send_signal(SEND_SIG_NOINFO).
> Note that SEND_SIG_NOINFO is rarely used, and only by kernel.

Ah, I was misreading.  I was mistakenly thinking tkill for instance was going
to be handled by the SEND_SIG_NOINFO case.  I'll fix my patch, thanks!

-serge
