Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab1DLTyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:54:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655Ab1DLTyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:54:44 -0400
Date: Tue, 12 Apr 2011 21:53:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] signal: retarget_shared_pending: consider
	shared/unblocked signals only
Message-ID: <20110412195321.GA15586@redhat.com>
References: <20110411171957.GA32469@redhat.com> <20110411172045.GC32469@redhat.com> <20110412124022.6256b8ed@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412124022.6256b8ed@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, Matt Fleming wrote:
>
> On Mon, 11 Apr 2011 19:20:45 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > exit_signals() checks signal_pending() before
> > retarget_shared_pending() but this is suboptimal. We can avoid the
> > while_each_thread() loop in case when there are no shared signals
> > visible to us.
> >
> > Add the has_pending_signals(shared_pending, blocked) check. We don
> > not use tsk->blocked directly but pass this sigset_t as an argument,
> > this is needed for the next patch.
> >
> > Note: we can optimize this more. while_each_thread(t) can check
> > t->blocked into account and stop after every pending signal has the
> > new target.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Nice. Do you have plans to implement that further optimisation?

Probably yes, this is straightforward...

> Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

Thanks Matt, thanks all.

I'll reply to other emails tomorrow. I was distracted by other things,
sorry. Oh, as always :/

Oleg.

