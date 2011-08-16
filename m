Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1HPTrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:47:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab1HPTrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:47:39 -0400
Date: Tue, 16 Aug 2011 21:44:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt@console-pimps.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 0/1] kthreads: allow_signal: don't play with ->blocked
Message-ID: <20110816194427.GA6602@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-42-git-send-email-matt@console-pimps.org> <20110816180644.GJ29190@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816180644.GJ29190@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Oleg Nesterov wrote:
>
> >  int allow_signal(int sig)
> >  {
> > +	sigset_t blocked;
> > +
> >  	if (!valid_signal(sig) || sig < 1)
> >  		return -EINVAL;
> >
> >  	spin_lock_irq(&current->sighand->siglock);
> >  	/* This is only needed for daemonize()'ed kthreads */
>
> Exactly. And nowadays the daemonize()'ed kthreads should not play
> with allow_signal().
>
> And more, I think it is the time to kill daemonize(). Contrary to
> what /bin/grep thinks, it has only one user.

No, daemonize() has no users which actually need it.

Imho we should deprecate it, it has no users after the patches I sent.

> In short: this code in allow_signal() should die.

Yes.

To clarify: this change breaks drivers/staging/rtl8712/, but I belive
it is wrong and should be fixed. I have already sent the patch.

Oleg.

