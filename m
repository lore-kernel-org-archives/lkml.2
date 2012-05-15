Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966410Ab2EOSzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:55:43 -0400
Received: from 1wt.eu ([62.212.114.60]:2092 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966209Ab2EOSzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:55:42 -0400
Date: Tue, 15 May 2012 20:55:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [34-longterm 167/179] futex: Fix regression with read only mappings
Message-ID: <20120515185513.GA13685@1wt.eu>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com> <1337048075-6132-168-git-send-email-paul.gortmaker@windriver.com> <alpine.LSU.2.00.1205142126180.2196@eggly.anvils> <1337079117.27694.28.camel@twins> <20120515160250.GA17760@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515160250.GA17760@windriver.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 12:02:50PM -0400, Paul Gortmaker wrote:
> [Re: [34-longterm 167/179] futex: Fix regression with read only mappings] On 15/05/2012 (Tue 12:51) Peter Zijlstra wrote:
> 
> > On Mon, 2012-05-14 at 21:38 -0700, Hugh Dickins wrote:
> > > I don't know: I'm not NAKking it, I'm just waving a reddish flag,
> > > and hoping that Peter will remember more, and have something more
> > > constructive to say, than I can think of at this moment. 
> > 
> > Ha! you're very optimistic :-)
> > 
> > going by git log kernel/futex.c on a recent kernel the proposed patch
> > should indeed be followed by your patch, but I can't seem to find more
> > relevant patches.
> 
> Thanks a lot guys.  That is a dependency I'd never have come up with.
> 
> Willy -- this is probably of interest to you as well.   Hugh says that
> commit e6780f7243 ("futex: Fix uninterruptible loop due to gate_area")
> should be used if 9ea71503a8 ("futex: Fix regression with read only
> mappings") is used.  The v2.6.32.46 added 9ea71503a8 (as d64ec7bb),
> but I don't see a cherry pick of e6780f7243 in any v2.6.32.x yet.
> 
> Greg already applied it to 3.0.16 and 3.1.8 and it appeared in v3.2
> by default, so no other active stable releases need to worry.
> 
> I had to change page_mapping --> page, since the 2.6.34 baseline does
> not have a5b338f2b0b1ff73 ("thp: update futex compound knowledge")
> [added to v2.6.38] which introduces the shadow variable page_mapping.

Thank you very much Paul, I'm queuing it then. I hope to have some time for
a new -32 review soon, probably next week-end.

Cheers,
Willy

