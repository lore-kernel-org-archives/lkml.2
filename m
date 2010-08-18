Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0HROJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:09:13 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55796 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0HROJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:09:11 -0400
Date: Wed, 18 Aug 2010 19:38:56 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nikanth Karthikesan <knikanth@suse.de>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH] Per file dirty limit throttling
Message-ID: <20100818140856.GE28417@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <201008160949.51512.knikanth@suse.de>
 <201008171039.23701.knikanth@suse.de>
 <1282033475.1926.2093.camel@laptop>
 <201008181452.05047.knikanth@suse.de>
 <1282125536.1926.3675.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1282125536.1926.3675.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-08-18 11:58:56]:

> On Wed, 2010-08-18 at 14:52 +0530, Nikanth Karthikesan wrote:
> > On Tuesday 17 August 2010 13:54:35 Peter Zijlstra wrote:
> > > On Tue, 2010-08-17 at 10:39 +0530, Nikanth Karthikesan wrote:
> > > > Oh, nice.  Per-task limit is an elegant solution, which should help
> > > > during most of the common cases.
> > > >
> > > > But I just wonder what happens, when
> > > > 1. The dirtier is multiple co-operating processes
> > > > 2. Some app like a shell script, that repeatedly calls dd with seek and
> > > > skip? People do this for data deduplication, sparse skipping etc..
> > > > 3. The app dies and comes back again. Like a VM that is rebooted, and
> > > > continues writing to a disk backed by a file on the host.
> > > >
> > > > Do you think, in those cases this might still be useful?
> > > 
> > > Those cases do indeed defeat the current per-task-limit, however I think
> > > the solution to that is to limit the amount of writeback done by each
> > > blocked process.
> > > 
> > 
> > Blocked on what? Sorry, I do not understand.
> 
> balance_dirty_pages(), by limiting the work done there (or actually, the
> amount of page writeback completions you wait for -- starting IO isn't
> that expensive), you can also affect the time it takes, and therefore
> influence the impact.
>

There is an ongoing effort to look at per-cgroup dirty limits and I
honestly think it would be nice to do it at that level first. We need
it there as a part of the overall I/O controller. As a specialized
need it could handle your case as well. 

-- 
	Three Cheers,
	Balbir
