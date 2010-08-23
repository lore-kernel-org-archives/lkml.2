Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0HWMQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 08:16:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:35712 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab0HWMQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 08:16:43 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] Per file dirty limit throttling
Date: Mon, 23 Aug 2010 17:49:19 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: Wu Fengguang <fengguang.wu@intel.com>, Bill Davidsen <davidsen@tmr.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
References: <201008160949.51512.knikanth@suse.de> <201008181452.05047.knikanth@suse.de> <1282125536.1926.3675.camel@laptop>
In-Reply-To: <1282125536.1926.3675.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008231749.19836.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 August 2010 15:28:56 Peter Zijlstra wrote:
> On Wed, 2010-08-18 at 14:52 +0530, Nikanth Karthikesan wrote:
> > On Tuesday 17 August 2010 13:54:35 Peter Zijlstra wrote:
> > > On Tue, 2010-08-17 at 10:39 +0530, Nikanth Karthikesan wrote:
> > > > Oh, nice.  Per-task limit is an elegant solution, which should help
> > > > during most of the common cases.
> > > >
> > > > But I just wonder what happens, when
> > > > 1. The dirtier is multiple co-operating processes
> > > > 2. Some app like a shell script, that repeatedly calls dd with seek
> > > > and skip? People do this for data deduplication, sparse skipping
> > > > etc.. 3. The app dies and comes back again. Like a VM that is
> > > > rebooted, and continues writing to a disk backed by a file on the
> > > > host.
> > > >
> > > > Do you think, in those cases this might still be useful?
> > >
> > > Those cases do indeed defeat the current per-task-limit, however I
> > > think the solution to that is to limit the amount of writeback done by
> > > each blocked process.
> >
> > Blocked on what? Sorry, I do not understand.
> 
> balance_dirty_pages(), by limiting the work done there (or actually, the
> amount of page writeback completions you wait for -- starting IO isn't
> that expensive), you can also affect the time it takes, and therefore
> influence the impact.
> 

But this has nothing special to do with the cases like multi-threaded dirtier, 
which is why I was confused. :)

Thanks
Nikanth
