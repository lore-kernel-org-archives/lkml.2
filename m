Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab2EIVPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:15:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab2EIVPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:15:53 -0400
Date: Wed, 9 May 2012 23:14:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Pedro Alves <palves@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        pacman@kosh.dhis.org, linux-man <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: ptrace.2: PTRACE_KILL needs a stopped process too
Message-ID: <20120509211429.GA2455@redhat.com>
References: <20091216004533.22261.qmail@kosh.dhis.org> <4FAAC706.6000808@redhat.com> <20120509201219.GA32051@redhat.com> <201205091241.59060.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205091241.59060.vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09, Mike Frysinger wrote:
>
> On Wednesday 09 May 2012 16:12:19 Oleg Nesterov wrote:
> > On 05/09, Pedro Alves wrote:
> > > On 05/09/2012 04:09 PM, Mike Frysinger wrote:
> > > > probably not that big of a deal, but the reason i like using
> > > > ptrace(PTRACE_KILL) over a raw kill() is that you are less likely to
> > > > kill the wrong process by accident.  maybe not that big of a deal in
> > > > practice though.
> > >
> > > And you can do tgkill instead.  It was specifically invented to handle
> > > the reuse case.
> >
> > tgkill() can kill the wrong process/thread too, although it lessens the
> > risk.
> >
> > But I don't really understand the problem. The traced thread can't go away
> > until the tracer does wait/detach, and thus its pid can't be reused?
>
> or the process has received a SIGKILL for some reason

And? In this case it will be killed, yes. But this zombie can't go away
until the tracer does do_wait().

OK, the multi-threaded exec adds more fun.

> > May be, "by accident" above means something else, not pid reuse...
>
> i like to assume that my code isn't going to be bug free, so the more
> mechanisms i have in place to protect innocent bystanders the better :)
> -mike

>From this pov PTRACE_KILL is safer, I agree ;)

Oleg.

