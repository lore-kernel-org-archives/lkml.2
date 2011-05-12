Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab1ELS4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:56:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab1ELS4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:56:17 -0400
Date: Thu, 12 May 2011 20:54:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] signal: introduce do_sigtimedwait() to factor
	out compat/native code
Message-ID: <20110512185434.GA27589@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110426194822.GA8520@redhat.com> <20110426194904.GC8520@redhat.com> <BANLkTikhJkFtJUwUJ3stT=juKKuo+6xT7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikhJkFtJUwUJ3stT=juKKuo+6xT7g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Mike Frysinger wrote:
>
> On Tue, Apr 26, 2011 at 15:49, Oleg Nesterov wrote:
> > --- sigprocmask/include/linux/signal.h~2_do_sigtimedwait        2011-04-26 19:52:30.000000000 +0200
> > +++ sigprocmask/include/linux/signal.h  2011-04-26 19:53:42.000000000 +0200
> > @@ -242,6 +242,8 @@ extern int __group_send_sig_info(int, st
> >  extern long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig,
> >                                 siginfo_t *info);
> >  extern long do_sigpending(void __user *, unsigned long);
> > +extern int do_sigtimedwait(const sigset_t *, siginfo_t *,
> > +                               const struct timespec *);
> >  extern int sigprocmask(int, sigset_t *, sigset_t *);
> >  extern void set_current_blocked(const sigset_t *);
> >  extern int show_unhandled_signals;
>
> this causes a build warning:
> In file included from arch/blackfin/kernel/signal.c:8:
> include/linux/signal.h:246: warning: 'struct timespec' declared inside
> parameter list

Oh, thanks Mike. I'll send the simple fix tomorrow.

Oleg.

