Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab2BJU23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:28:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab2BJU22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:28:28 -0500
Date: Fri, 10 Feb 2012 21:21:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] arm: Fix possible race on task->mm
Message-ID: <20120210202131.GA21408@redhat.com>
References: <20120207064809.GA29061@oksana.dev.rtsoft.ru> <20120207065004.GC1496@oksana.dev.rtsoft.ru> <20120208160808.GB17177@redhat.com> <20120209153346.GA346@oksana.dev.rtsoft.ru> <20120209154336.GA4769@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120209154336.GA4769@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09, Anton Vorontsov wrote:
>
> On Thu, Feb 09, 2012 at 07:33:46PM +0400, Anton Vorontsov wrote:
> > On Wed, Feb 08, 2012 at 05:08:08PM +0100, Oleg Nesterov wrote:
> > > On 02/07, Anton Vorontsov wrote:
> > > >
> > > > Checking for task->mm is dangerous as ->mm might disappear (exit_mm()
> > > > assigns NULL under task_lock(), so tasklist lock is not enough).
> > > >
> > > > We can't use get_task_mm()/mmput() pair as mmput() might sleep,
> > >
> > > Yes, but
> > >
> > > > so let's take the task lock while we care about its mm.
> > >
> > > it seems that this needs find_lock_task_mm() too ?
> > >
> > > the same for the rest patches in this series.
> >
> > Yep, I think you're right, will add this change.
>
> Thinking about it more... making the code use find_lock_task_mm
> would be a behaviour change. Sure, in trivial cases like ARM this
> looks like a 100% safe thing to do, but in e.g. UML case, I
> wouldn't bet much money on that 'mm->context.id.u.pid' would be
> still meaningful.

OK, perhaps UML differs. I don't know what context.id.u.pid means.
Although at first glance it would be meaningful anyway...

> So, I'd rather do it in a separate change, so this can be easily
> reverted.

In the !UML case find_lock_task_mm() "obviously looks like the right
thing...

But I won't argue, up to you.

Oleg.

