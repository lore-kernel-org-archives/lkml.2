Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704Ab1DYR2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:28:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758551Ab1DYR2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:28:10 -0400
Date: Mon, 25 Apr 2011 19:26:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signal: sys_rt_sigtimedwait: simplify the timeout
	logic
Message-ID: <20110425172644.GA20689@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110423175922.GB484@redhat.com> <20110425113746.GM17734@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425113746.GM17734@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Tejun Heo wrote:
>
> On Sat, Apr 23, 2011 at 07:59:22PM +0200, Oleg Nesterov wrote:
> >
> > I don't understand why we are adding (ts.tv_sec || ts.tv_nsec) to
> > timespec_to_jiffies(&ts). Perhaps to ensure we will sleep at least
> > one jiffy if ts != 0? But in this case we should only check tv_nsec,
> > I don't think timespec_to_jiffies() can return zero if tv_sec != 0.
> > In fact I suspect timespec_to_jiffies() can only return zero if
> > tv_sec == tv_nsec == 0 because we add "TICK_NSEC - 1", but I am not
> > sure I understand correctly this math.
> >
> It might be a good idea to note the weird jiffies calculation with a
> comment?

If only I knew what this comment could say except

	/* Why do we add (tv_sec || tv_nsec) ?  */

I'd better send 4/3 which simply removes this (I hope) unneeded code.

Oleg.

