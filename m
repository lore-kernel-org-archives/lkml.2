Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1B1Pck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:32:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526Ab1B1Pcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:32:39 -0500
Date: Mon, 28 Feb 2011 16:23:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
	PTRACE_ATTACH
Message-ID: <20110228152342.GA3663@redhat.com>
References: <201102132325.55353.vda.linux@googlemail.com> <20110214151340.GP18742@htj.dyndns.org> <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com> <20110214173012.GA18742@htj.dyndns.org> <AANLkTinntVGcOdZSS3gWz39eq3EDiMxXgYfc6+M1Z0iE@mail.gmail.com> <20110221151619.GM31267@htj.dyndns.org> <20110221152855.GA20769@redhat.com> <20110222162454.GB31267@htj.dyndns.org> <20110224210819.GB12258@redhat.com> <20110225154555.GP24828@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225154555.GP24828@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, Tejun Heo wrote:
>
> Hello,
>
> On Thu, Feb 24, 2011 at 10:08:19PM +0100, Oleg Nesterov wrote:
>
> > > If you mix ptrace trap and group stop and then fix group stop
> > > notification, not only multithreaded debugging becomes quite
> > > cumbersome (suddenly ptracing becomes per-process thing instead of
> > > per-thread),
> >
> > It should be, imho. Like SIGKILL, SIGSTOP/SIGCONT are not per-thread.
> > This is per-process thing.
>
> jctl should be and will stay to be per-process, but that doesn't mean
> ptrace needs to interact with them at process level.  ptrace can still
> be per-task and operate beneath jctl, which is what I'm proposing to
> do.

This is what I don't fully understand... Yes, ptrace can still be
per-thread. But yes, if gdb sends SIGCONT to one thread, this affects
the whole group even if it doesn't wake up them all, this is true.

OK, I think this doesn't matter, at least we understand how/where
we do not agree with each other.

> > > but in short I think we just need two more PTRACE calls (one for
> > > combined SIGSTOPless attach + INTERRUPT
> >
> > Yes, we are discussing these requests on archer,
>
> Can we please do that on LKML?  It's a kernel change after all.

Right now this has almost nothing to do with the kernel. Currently we
are trying to understand what gdb needs. But, of course, after that
we should discuss the possible kernel improvements/changes on lkml.

Oleg.

