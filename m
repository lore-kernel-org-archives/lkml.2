Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1DWSN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 14:13:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab1DWSNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 14:13:25 -0400
Date: Sat, 23 Apr 2011 20:12:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] x86: signal: sys_rt_sigreturn() should use
	set_current_blocked()
Message-ID: <20110423181231.GA1472@redhat.com>
References: <20110418134421.GA15951@redhat.com> <20110418134641.GH15951@redhat.com> <20110422151418.3639a131@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110422151418.3639a131@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22, Matt Fleming wrote:
>
> On Mon, 18 Apr 2011 15:46:41 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Normally sys_rt_sigreturn() restores the old current->blocked which was
> > changed by handle_signal(), and unblocking is always fine.
> >
> > But the debugger or application itself can change frame->uc_sigmask and
> > thus we need set_current_blocked()->retarget_shared_pending().
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

Thanks Matt.

> But does sys_sigreturn() also need this change?

Of course, it needs. From 0/7:

	Once again: if we need this, then we need a lot more (trivial) changes
	like 6/7 and 7/7. Basically every change of ->blocked should be converted
	to use set_current_blocked().

6 and 7 are simple examples, most of the other changes will look similary.

Except sys_rt_sigtimedwait(), it changes both ->real_blocked and blocked,
see the patches I sent. sys_sigprocmask() is a bit annoying, but the
necessary changes are simple.

Oleg.

