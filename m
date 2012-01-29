Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2A2Lik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 06:38:40 -0500
Received: from ozlabs.org ([203.10.76.45]:39884 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab2A2Lij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 06:38:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to -mm tree
In-Reply-To: <20120127143234.GA13056@redhat.com>
References: <20120126175612.GA24011@redhat.com> <87ipjxdfbg.fsf@rustcorp.com.au> <20120127143234.GA13056@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Sun, 29 Jan 2012 11:19:00 +1030
Message-ID: <87y5srbaf7.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012 15:32:34 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/27, Rusty Russell wrote:
> > On Thu, 26 Jan 2012 18:56:12 +0100, Oleg Nesterov <oleg@redhat.com> wrote:
> > > Can't we simply kill khelper_wq and use system_unbound_wq instead?
> >
> > I'd prefer that, because then we'd hit the existing "too many modprobes"
> > check.
> 
> Hmm. Why? I mean, why do you think that s/khelper_wq/system_unbound_wq/
> leads to recursive __request_module's ?
> 
> Note that that this patch (which adds kmod_thread_locker) can not limit
> the recursive modprobe loop.
> 
> 
> OK, yes, with system_unbound_wq we can hit this warning if we have
> max_modprobes UMH_WAIT_EXEC's resulting in __request_module at the
> same time, but probably this is good?

Yes, that's what I'm saying.

We already have a check against too many modprobes, it might be best to
use it.

Cheers,
Rusty.
