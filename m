Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1HNRNI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 13:13:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab1HNRNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 13:13:06 -0400
Date: Sun, 14 Aug 2011 19:10:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        containers@lists.linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] add SA_CLDREBOOT flag
Message-ID: <20110814171007.GA2097@redhat.com>
References: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr> <1313094241-3674-2-git-send-email-daniel.lezcano@free.fr> <20110814161532.GA30846@redhat.com> <20110814183611.05937c96@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110814183611.05937c96@neptune.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14, Bruno Prémont wrote:
>
> On Sun, 14 August 2011 Oleg Nesterov <oleg@redhat.com> wrote:
> > On 08/11, Daniel Lezcano wrote:
> > >
> > > Add the SA_CLDREBOOT flag to enable the CLD_REBOOT on SIGCHLD
> > > when a process of a child pid namespace calls the reboot syscall.
> >
> > I doubt this is really useful in general. SIGCHLD doesn't queue,
> > if the parent of init already has the pending SIGCHLD it won't see
> > CLD_REBOOTED anyway. Anyway, you do not need a special helper to
> > fill siginfo.
> >
> > And personally I strongly dislike SA_CLDREBOOT. For what? Imho, this
> > is unnecessary complication. If we want SIGCHLD-on-reboot, just send
> > it unconditionally.
>
> The information that is needed is what options the container did pass
> to sys_reboot().
> Did the container want a reboot or a power-off (or maybe just touch the
> LINUX_REBOOT_CMD_CAD_* status)?
>
> As long as that information can reach parent/reaper of container's init
> the needed functionality should be there.

Sorry, can't understand.

Once again, why do you want SA_CLDREBOOT?

OK, you may be need to pass some info via siginfo (but note that it can
be lost, and you do not need a special helper for that). But why do you
want this hack in sa_flags?

Oleg.

