Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1IUR5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 13:57:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab1IUR5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 13:57:53 -0400
Date: Wed, 21 Sep 2011 19:53:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge.hallyn@canonical.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com
Subject: Re: [PATCH] user namespace: make signal.c respect user namespaces
Message-ID: <20110921175357.GA25590@redhat.com>
References: <20110919214531.GA18085@sergelap> <20110920174849.GB22317@redhat.com> <20110920185354.GA19629@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920185354.GA19629@sergelap>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20, Serge E. Hallyn wrote:
>
> Quoting Oleg Nesterov (oleg@redhat.com):
> > On 09/19, Serge E. Hallyn wrote:
> > >
> > > __send_signal: convert the uid being sent in SI_USER to the target task's
> > > user namespace.
> > >
> > > do_notify_parent and do_notify_parent_cldstop: map task's uid to parent's
> > >  user namespace
> > >
> > > ptrace_signal: map parent's uid into current's user namespace before
> > > including in signal to current.
> >
> > Btw, what about the other users of ->si_uid? Say, kill() or tkill().
>
> Well, they end up calling __send_signal().

Sure. But your patch changes only the __send_signal(SEND_SIG_NOINFO).
Note that SEND_SIG_NOINFO is rarely used, and only by kernel.

> But you sound more alarmed than that.

I am ;)

Oleg.

