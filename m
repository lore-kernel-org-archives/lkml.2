Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1H3Wmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:42:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752446Ab1H3Wmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:42:36 -0400
Date: Tue, 30 Aug 2011 15:41:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Daniel Ehrenberg <dehrenberg@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: Approaches to making io_submit not block
Message-Id: <20110830154157.d802d097.akpm@linux-foundation.org>
In-Reply-To: <4E5D64E8.7000102@kernel.dk>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
	<CAAK6Zt0Sh1GdEOb-tNf2FGXJs=e1Jbcqew13R_GdTqrv6vW97w@mail.gmail.com>
	<x49k49uk2ox.fsf@segfault.boston.devel.redhat.com>
	<4E5D5817.6040704@kernel.dk>
	<CAAK6Zt2C1646qwDiZ7sWheSWrnx2yrDtCE=+VTx7QNyh2bEz_g@mail.gmail.com>
	<4E5D64E8.7000102@kernel.dk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 16:32:08 -0600
Jens Axboe <axboe@kernel.dk> wrote:

> On 2011-08-30 16:19, Daniel Ehrenberg wrote:
> > On Tue, Aug 30, 2011 at 2:37 PM, Jens Axboe <axboe@kernel.dk> wrote:
> >> On 2011-08-30 15:30, Jeff Moyer wrote:
> >>> Daniel Ehrenberg <dehrenberg@google.com> writes:
> >>>
> >>>> Hi Jens, Jeff,
> >>>>
> >>>> I just sent a letter to LKML wondering about changes to io_submit that
> >>>> I'm thinking of working on. Based on your past contributions to this
> >>>> area, I'd really like to know what you think of this plan--how well it
> >>>> matches with the existing design, the potential for inclusion in
> >>>> upstream Linux, if you see problems.
> >>>
> >>> Hi, Dan,
> >>>
> >>> Thanks for taking the time to make AIO better!  There is a mailing list
> >>> for aio discussions: linux-aio@kvack.org, so please CC that in the
> >>> future (I don't read lkml anymore).
> >>>
> >>> Right now I'm a bit inundated, so I can't give this a proper review.
> >>> I should be able to free up some time in the next two weeks, though.
> >>>
> >>> In the mean time, you can google for suparna's retry-based aio patches.
> >>> Specifically, take a look at how she used prepare_to_wait/finish_wait.
> >>> If you haven't done any empirical tests to see where io_submit blocks,
> >>> there is a sample systemtap script for that:
> >>>   http://sourceware.org/systemtap/examples/io/io_submit.stp
> >>> Other attempts at non-blocking aio were off the deep end: fibrils and
> >>> syslets.  Fibrils didn't go anywhere because Ingo didn't like them (for
> >>> good reason, they essentially introduced another scheduling layer).
> >>> Syslets didn't go anywhere b/c they were insane (returned to the
> >>> user-space process with a different PID, among other things!).
> >>>
> >>> If you do go forward in the meantime, you can likely use EIOCBRETRY
> >>> instead of EAGAIN.
> >>>
> >>> I hope that helps!
> >>
> >> FWIW, I updated the buffered AIO retry patches some time after Suparna
> >> droped them. By the date stamp in my branch, they are now 23 months
> >> old... Anyway, at least it's more recent, you can find them here:
> >>
> >> http://git.kernel.dk/?p=linux-block.git;a=shortlog;h=refs/heads/aio-buffered
> >>
> >> --
> >> Jens Axboe
> >>
> >>
> > Thanks! Do you know why the patches weren't merged? I can't find much
> > discussion about them.
> 
> Not quite sure, and after working on them and fixing thing up, I don't
> even think they are that complex or intrusive (which I think otherwise
> would've been the main objection). Andrew may know/remember.

Boy, that was a long time ago.  I was always unhappy with the patches
because of the amount of additional code/complexity they added.

Then the great syslets/threadlets design session happened and it was
expected that such a facility would make special async handling for AIO
unnecessary.  Then syslets/threadlets didn't happen.

