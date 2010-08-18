Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab0HRJ7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 05:59:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:39761 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0HRJ7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 05:59:11 -0400
Subject: Re: [RFC][PATCH] Per file dirty limit throttling
From: Peter Zijlstra <peterz@infradead.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Bill Davidsen <davidsen@tmr.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
In-Reply-To: <201008181452.05047.knikanth@suse.de>
References: <201008160949.51512.knikanth@suse.de>
	 <201008171039.23701.knikanth@suse.de> <1282033475.1926.2093.camel@laptop>
	 <201008181452.05047.knikanth@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 18 Aug 2010 11:58:56 +0200
Message-ID: <1282125536.1926.3675.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 14:52 +0530, Nikanth Karthikesan wrote:
> On Tuesday 17 August 2010 13:54:35 Peter Zijlstra wrote:
> > On Tue, 2010-08-17 at 10:39 +0530, Nikanth Karthikesan wrote:
> > > Oh, nice.  Per-task limit is an elegant solution, which should help
> > > during most of the common cases.
> > >
> > > But I just wonder what happens, when
> > > 1. The dirtier is multiple co-operating processes
> > > 2. Some app like a shell script, that repeatedly calls dd with seek and
> > > skip? People do this for data deduplication, sparse skipping etc..
> > > 3. The app dies and comes back again. Like a VM that is rebooted, and
> > > continues writing to a disk backed by a file on the host.
> > >
> > > Do you think, in those cases this might still be useful?
> > 
> > Those cases do indeed defeat the current per-task-limit, however I think
> > the solution to that is to limit the amount of writeback done by each
> > blocked process.
> > 
> 
> Blocked on what? Sorry, I do not understand.

balance_dirty_pages(), by limiting the work done there (or actually, the
amount of page writeback completions you wait for -- starting IO isn't
that expensive), you can also affect the time it takes, and therefore
influence the impact.


