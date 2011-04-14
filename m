Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab1DNUQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:16:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab1DNUQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:16:38 -0400
Date: Thu, 14 Apr 2011 22:15:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] x86: signal: sys_rt_sigreturn() should use
	sigprocmask()
Message-ID: <20110414201546.GC25828@redhat.com>
References: <20110411171957.GA32469@redhat.com> <20110411172229.GG32469@redhat.com> <20110412131757.78e436d5@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110412131757.78e436d5@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12, Matt Fleming wrote:
>
> On Mon, 11 Apr 2011 19:22:29 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Normally sys_rt_sigreturn() restores the old current->blocked which was
> > changed by handle_signal(), and unblocking is always fine.
> >
> > But the debugger or application itself can change frame->uc_sigmask and
> > thus we need sigprocmask()->retarget_shared_pending().
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>

Thanks Matt.

> I'm just curious, have you actually seen this bug?

No, never.

But recently Nikita reported the problem which _might_ be explained by
this. see http://marc.info/?t=129732355500007 . Although it is quite
possible there is something else.

Oleg.

