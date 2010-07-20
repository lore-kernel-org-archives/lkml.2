Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0GTTcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 15:32:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab0GTTcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 15:32:33 -0400
Date: Tue, 20 Jul 2010 15:32:24 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
        axboe@kernel.dk, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
Message-ID: <20100720193224.GM8967@redhat.com>
References: <x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
 <AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
 <x49eif7p3z0.fsf@segfault.boston.devel.redhat.com>
 <20100713195650.GA21044@redhat.com>
 <x49aapvp1k0.fsf@segfault.boston.devel.redhat.com>
 <20100713204236.GB21044@redhat.com>
 <x4939vfv4i0.fsf@segfault.boston.devel.redhat.com>
 <20100720141102.GA6316@infradead.org>
 <20100720142647.GA8967@redhat.com>
 <AANLkTimxrPLaAoH28PuxggHr99G9Xq8GlHaDJEd_QhNT@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimxrPLaAoH28PuxggHr99G9Xq8GlHaDJEd_QhNT@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 09:10:56PM +0200, Corrado Zoccolo wrote:
> On Tue, Jul 20, 2010 at 4:26 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Tue, Jul 20, 2010 at 10:11:03AM -0400, Christoph Hellwig wrote:
> >> Didn't you guys have a previous iteration of the fixes that gets
> >> rid of REQ_NODILE by improving the heuristics inside cfq?  That
> >> would be much, much preffered from the filesystem point of view.
> I think the previous iteration required more complex heuristics, while
> this one uses existing ones to handle one more class of problems.
> I understand that you still see the complexity from the fs side, but
> Vivek's proposal may help also there. It only needs to be tested thoroughly.
> 
> >
> > Actually in this patch, I was thinking we can probably get rid of
> > RQ_NOIDLE flag and just check for WRITE_SYNC. Any WRITE_SYNC queue
> > gets served on sync-noidle tree. I am wondering will we not face jbd
> > thread issues with direct writes also? If yes, then not special casing
> > direct IO writes and treat them same as O_SYNC writes will make sense.
> 
> Probably it is better to submit this first, since it is already
> tested, and then have a different patch that can finish the work
> This will help when bisecting for possible regressions, since I'm not
> sure why the other writes are not already marked with RQ_NOIDLE (maybe
> it was introduced for some good reason to distinguish the two sets,
> and we won't know unless we find the workload where it helped).
> I'll resend the current patch with Jeff's reviewed and tested tags.
> 

I am fine with pushing this patch as it is first and then once we have
an answer to question whether direct IO path and O_SYNC/fsync path need
same treatment or different treatment in IO scheduler, we can fix RQ_NOIDLE
flag issue also.

Vivek
