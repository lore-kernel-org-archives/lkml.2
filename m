Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1DYPel (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 11:34:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab1DYPej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 11:34:39 -0400
Date: Mon, 25 Apr 2011 17:33:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] signal: introduce do_sigtimedwait() to factor out
	compat/native code
Message-ID: <20110425153316.GB14934@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110423175940.GC484@redhat.com> <20110425114942.GO17734@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425114942.GO17734@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Tejun Heo wrote:
>
> Just one more thing.
>
> On Sat, Apr 23, 2011 at 07:59:40PM +0200, Oleg Nesterov wrote:
> > +int do_sigtimedwait(sigset_t *these, siginfo_t *info, long timeout)
>
> Maybe @these isn't the base name here?  It implies that these are the
> signals the function is interested in but in reality it is the
> negation of that.

Yees, I simply copied the old name. And yes, I tried to invent the
better name but failed.

Hmm. I think this patch can do a bit more. We can factor out
sigdelsetmask(SIGKILL | SIGSTOP) + signotset() as well, I'll resend.

Still, what should be the name? @set? @mask? @which?

Oleg.

