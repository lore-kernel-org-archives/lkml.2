Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1DYQCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 12:02:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab1DYQCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 12:02:40 -0400
Date: Mon, 25 Apr 2011 18:01:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] signal: do_sigtimedwait() needs
	retarget_shared_pending()
Message-ID: <20110425160115.GC14934@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110423180000.GD484@redhat.com> <20110425115253.GP17734@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425115253.GP17734@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Tejun Heo wrote:
>
> > @@ -2322,7 +2327,8 @@ int do_sigtimedwait(sigset_t *these, sig
> >  		/*
> >  		 * None ready -- temporarily unblock those we're
> >  		 * interested while we are sleeping in so that we'll
> > -		 * be awakened when they arrive.
> > +		 * be awakened when they arrive. Unblocking is always
> > +		 * fine, we can avoid set_current_blocked().
> >  		 */
> >  		tsk->real_blocked = tsk->blocked;
> >  		sigandsets(&tsk->blocked, &tsk->blocked, these);
>
> Maybe it would be a good idea to introduce a new helper which checks /
> enforces that the operation indeed is only unblocking?

I hope nobody will change ->blocked directly, except this function
and force_sig_info(). And daemonize/allow_signal/disallow_signal, but
there are special and probably we can already kill this deprecated
block/unblock code and forbid kernel_thread(CLONE_SIGHAND) + daemonize().
In fact I think daemonize() should go away.

So, I don't really think we need another helper to unblock something.

> Also, it can
> be a pure preference but I think _locked suffix is better / more
> common for APIs which expect the caller to be responsible for locking.

Again, I can rename... Cough, but in this case please simply suggest
another name. set_tsk_blocked_locked?

Oleg.

