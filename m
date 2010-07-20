Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab0GTO04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 10:26:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330Ab0GTO0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 10:26:55 -0400
Date: Tue, 20 Jul 2010 10:26:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        axboe@kernel.dk, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
Message-ID: <20100720142647.GA8967@redhat.com>
References: <x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
 <AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
 <x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
 <AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
 <x49eif7p3z0.fsf@segfault.boston.devel.redhat.com>
 <20100713195650.GA21044@redhat.com>
 <x49aapvp1k0.fsf@segfault.boston.devel.redhat.com>
 <20100713204236.GB21044@redhat.com>
 <x4939vfv4i0.fsf@segfault.boston.devel.redhat.com>
 <20100720141102.GA6316@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100720141102.GA6316@infradead.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 10:11:03AM -0400, Christoph Hellwig wrote:
> Didn't you guys have a previous iteration of the fixes that gets
> rid of REQ_NODILE by improving the heuristics inside cfq?  That
> would be much, much preffered from the filesystem point of view.

Actually in this patch, I was thinking we can probably get rid of
RQ_NOIDLE flag and just check for WRITE_SYNC. Any WRITE_SYNC queue
gets served on sync-noidle tree. I am wondering will we not face jbd
thread issues with direct writes also? If yes, then not special casing
direct IO writes and treat them same as O_SYNC writes will make sense.

I really wished that we had some blktrace of some standard workloads
stored somewhere which we could simply replay using "btreplay" and come
to some kind of conclusion whenever we are faced with taking such
decisions.

Thanks
Vivek

