Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2CATds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:33:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab2CATdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:33:46 -0500
Date: Thu, 1 Mar 2012 20:26:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>, Roland McGrath <roland@hack.frob.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] epoll: introduce POLLFREE to flush
	->signalfd_wqh before kfree()
Message-ID: <20120301192636.GA10709@redhat.com>
References: <20120222173326.GA7139@redhat.com> <20120222173505.GD7147@redhat.com> <20120223154438.GA4354@redhat.com> <CA+55aFyaPY9xsDGDx0QqRR2gV_z541w_xXeQbh5Uknd26cvXCw@mail.gmail.com> <20120224190651.GA22287@redhat.com> <20120224190711.GB22287@redhat.com> <4F4E830E.3040307@mit.edu> <20120229200636.GA15729@redhat.com> <CAObL_7GdhNPNsSiTF+GfbJ3_8ud8px6=LBH173uy14y58FMivg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAObL_7GdhNPNsSiTF+GfbJ3_8ud8px6=LBH173uy14y58FMivg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29, Andrew Lutomirski wrote:
>
> On Wed, Feb 29, 2012 at 12:06 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 02/29, Andy Lutomirski wrote:
> >>
> >> On 02/24/2012 11:07 AM, Oleg Nesterov wrote:
> >> > This patch adds the special event, POLLFREE, currently only for
> >> > epoll. It expects that init_poll_funcptr()'ed hook should do the
> >> > necessary cleanup. Perhaps it should be defined as EPOLLFREE in
> >> > eventpoll.
> >>
> >> I have a bunch of userspace code that uses signalfd via epoll.  Does
> >> this affect the ABI?
> >
> > I hope not ;)
> >
>
> Excellent!
>
> To avoid further confusion, would it make sense to update the comment
> in poll.h to indicate that POLLFREE is only for epoll and is internal
> to the kernel?

Agreed. Or perhaps we can simply use POLLREMOVE instead...

But note that nobody (including me) likes this fix, just I was asked
to make something simple/backportable. Probably it will be reverted
later.

If not, then perhaps it makes sense to do a couple of simple changes
on top to cleanup the usage of POLLFREE and to ensure that POLLHUP
is actually delivered (the latter will be user-visible).

Oleg.

