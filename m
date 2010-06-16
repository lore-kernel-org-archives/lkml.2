Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab0FPN1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:27:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18383 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab0FPN1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:27:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6014"; a="44609559"
Subject: Re: Overview of concurrency managed workqueue
From: Daniel Walker <dwalker@codeaurora.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
In-Reply-To: <4C18BF40.40607@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	 <4C17C598.7070303@kernel.org>
	 <1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	 <4C18BF40.40607@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 06:27:05 -0700
Message-ID: <1276694825.9309.12.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 14:10 +0200, Tejun Heo wrote:
> Hello,
> 
> On 06/15/2010 09:43 PM, Daniel Walker wrote:
> > I noticed that you removed the RT workqueue since it's no longer used,
> > but it's possible that a user can raise the priority of a given work
> > queue thread into real time priorities. So with single threaded, and
> > multithreaded workqueues specific to certain areas of the kernel the
> > user would have a greater ability to control priorities of those areas.
> > 
> > It looks like with your patches it would remove that level of
> > flexability effectively making all the work item the same priority with
> > no ability to raise or lower .. Is that accurate ?
> 
> Yes, that is.  With new cmwq, a wq can't assume association with
> specific kthread and thus can't use wq as simple frontend to kthreads,
> but if somebody wants dedicated kthreads instead of shared ones in
> units of work, [s]he should be using kthread.

I'm not talking about coders using workqueues when they should be using
kthreads .. We're talking about currently existing workqueues. Aren't
you converting all _current_ workqueues to your system?

> wq does provide nicer tools for synchronization but in general I don't
> think using kthread is too hard and there aren't too many cases
> anyway.  If there are many users && kthread is difficult to use
> directly, we can definitely write up a wrapping layer tho.  But I
> really think using wq as wrapper around kthreads and manipulating
> worker thread directly is an abusement.

It would be a hack the user would have to patch onto there kernel in
order to get back functionality your taking away.

I think from your perspective workqueue threads are all used for
"concurrency management" only, but I don't think that's true. Some will
be user for prioritization (I'm talking about _current_ workqueues).

Could you address or ponder how the work items could be prioritized
under your system?

Daniel

