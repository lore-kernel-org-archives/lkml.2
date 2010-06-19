Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0FSJIy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 05:08:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55696 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab0FSJIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 05:08:53 -0400
Date: Sat, 19 Jun 2010 11:08:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
Message-ID: <20100619090851.GF18946@basil.fritz.box>
References: <1276694825.9309.12.camel@m0nster>
 <4C18D1FD.9060804@kernel.org>
 <1276695665.9309.17.camel@m0nster>
 <4C18D574.1040903@kernel.org>
 <1276697146.9309.27.camel@m0nster>
 <1276776066.2461.15.camel@localhost>
 <87vd9fo1sk.fsf@basil.nowhere.org>
 <4C1C8263.9040404@kernel.org>
 <87fx0jo0z6.fsf@basil.nowhere.org>
 <4C1C8772.8090406@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1C8772.8090406@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I see.  The thing is that if you have "as soon as possible" + "high
> priority", you're basically required to have a dedicated worker or
> dedicated pool of them.  Making cmwq to support some level of priority
> definitely is possible (multiple prioritized queues or pushing work at
> the front at the simplest) but for such emergency works it doesn't
> make sense to share the usual worker pool, as resource pressure can
> easily make any work wait regardless of where they're in the queue.

I think it's reasonable to just put on front. The individual
items shouldn't take that long, right?

(in fact I have an older patch for work queues which implemented
that) 

> If there are multiple of such use cases, it would make sense to create
> a prioritized worker pools along with prioritized per-cpu queues but
> if there are only a few of them, I think it makes more sense to use
> dedicated threads for them.  Do those threads need to be per-cpu?

Not strictly, although it might be useful on a error flood when
a whole DIMM goes bad.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
