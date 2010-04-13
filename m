Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0DMUFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:05:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab0DMUFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:05:31 -0400
Date: Wed, 14 Apr 2010 06:05:27 +1000
From: Nick Piggin <npiggin@suse.de>
To: Chris Mason <chris.mason@oracle.com>,
       Manfred Spraul <manfred@colorfullife.com>, zach.brown@oracle.com,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in
 semtimedop
Message-ID: <20100413200527.GG5683@laptop>
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
 <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
 <4BC4A6B2.1090906@colorfullife.com>
 <20100413173941.GI13327@think>
 <20100413180945.GD5683@laptop>
 <20100413181937.GM13327@think>
 <20100413185756.GE5683@laptop>
 <20100413190110.GR13327@think>
 <20100413192551.GF5683@laptop>
 <20100413193801.GT13327@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100413193801.GT13327@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 03:38:01PM -0400, Chris Mason wrote:
> On Wed, Apr 14, 2010 at 05:25:51AM +1000, Nick Piggin wrote:
> > I didn't notice anything that should make that go faster?
> 
> Since I'm avoiding the ipc lock while operating on the array, it'll help
> any workload that hits on two or more semaphores in the array at
> once.

Yeah, I don't think SAP did that, significantly to matter. Possibly
some (aside from Oracle of course), do though.


> > Yes, with such a workload, using semops is basically legacy and simple
> > mutexes should work better. So I'm not outright against improving sysv
> > sem performance for more complex cases where nothing else we have works
> > as well.
> > 
> 
> I'm not in a hurry to overhaul a part of the kernel that has been stable
> for a long time.  But it really needs some love I think.  I'll have more
> numbers from a tpc run later this week.

Yep, I'm not against it. "industry standard benchmark" numbers would
be great.

I do think we need to be really careful with semantics though. The
API's been around for long enough that it is going to have been
(ab)used in every way possible :)

