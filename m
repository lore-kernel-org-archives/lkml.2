Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633Ab0FPNmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:42:32 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:38662 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757636Ab0FPNmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:42:31 -0400
Subject: Re: Overview of concurrency managed workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C18D420.8090008@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276695468.3640.19.camel@jlt3.sipsolutions.net>
	 <4C18D420.8090008@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 15:42:14 +0200
Message-ID: <1276695734.3640.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 15:39 +0200, Tejun Heo wrote:
> On 06/16/2010 03:37 PM, Johannes Berg wrote:
> >> As multiple execution contexts are available for each wq, deadlocks
> >> around execution contexts is much harder to create.  The default
> >> workqueue, system_wq, has maximum concurrency level of 256 and unless
> >> there is a use case which can result in a dependency loop involving
> >> more than 254 workers, it won't deadlock.
> > 
> > I see a lot of stuff about the current limitations etc., but nothing
> > about code that actually _relies_ on the synchronisation properties of
> > the current wqs. We talked about that a long time ago, is it still
> > guaranteed that a single-threaded wq will serialise all work put onto
> > it? It needs to be, but I don't see you explicitly mentioning it.
> 
> Oh yeah, if you have WQ_SINGLE_CPU + max inflight of 1, works on the
> wq are fully ordered.

Ok, great, thanks. FWIW, that's pretty much all I care about right
now :)

johannes

