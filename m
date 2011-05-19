Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933990Ab1ESSVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:21:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933767Ab1ESSVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:21:14 -0400
Date: Thu, 19 May 2011 20:19:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] signal: trivial, fix the "timespec declared inside
	parameter list" warning
Message-ID: <20110519181931.GA22506@redhat.com>
References: <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com> <20110426194904.GC8520@redhat.com> <BANLkTikhJkFtJUwUJ3stT=juKKuo+6xT7g@mail.gmail.com> <20110513164435.GA22435@redhat.com> <BANLkTimGjunaA4Fzdo6dc5=cKTc_g90j5Q@mail.gmail.com> <20110516125702.GA7941@redhat.com> <20110516125728.GB7941@redhat.com> <20110518163725.13e816fe.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518163725.13e816fe.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18, Andrew Morton wrote:
>
> On Mon, 16 May 2011 14:57:29 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Fix the compile warning, do_sigtimedwait(struct timespec *) in signal.h
> > needs the forward declaration of timespec.
> >
>
> The offending patch is in your tree, so you may as well put this patch
> in there too.

Yes, it is already in my tree, sorry for confusion.

> > --- sigprocmask/include/linux/signal.h~15_stw_warning	2011-05-12 20:44:43.000000000 +0200
> > +++ sigprocmask/include/linux/signal.h	2011-05-16 14:53:08.000000000 +0200
> > @@ -234,6 +234,9 @@ static inline int valid_signal(unsigned 
> >  	return sig <= _NSIG ? 1 : 0;
> >  }
> >
> > +struct timespec;
> > +struct pt_regs;
> > +
> >  extern int next_signal(struct sigpending *pending, sigset_t *mask);
> >  extern int do_send_sig_info(int sig, struct siginfo *info,
> >  				struct task_struct *p, bool group);
>
> Please put the forward declarations at top-of-file.  In this case,
> inside #ifdef __KERNEL__.  This reduces the risk of accumulating
> duplicated forward declarations, as has happened in the past.

This is what Mike suggested from the very beginnig. Perhaps this
would be better but since I already applied this patch... I'd prefer
to not test my git skills, unless you or Mike object.

Oleg.

