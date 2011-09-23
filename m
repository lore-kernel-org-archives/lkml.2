Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1IWQbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 12:31:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43189 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1IWQbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 12:31:19 -0400
Date: Fri, 23 Sep 2011 11:31:13 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110923163113.GA3820@sergelap>
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
> 
> > But you sound more alarmed than that.
> 
> I am ;)

Ok, thanks for setting me straight, Oleg.  It looks like I can fix all the
cases at send_signal() by checking whether si_fromuser(info) and
current_user_ns() != task_cred_xxx(t, user_ns), and mapping the uid if
so.

-serge
