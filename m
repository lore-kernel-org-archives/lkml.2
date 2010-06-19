Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab0FSJPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 05:15:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33775 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab0FSJPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 05:15:20 -0400
Date: Sat, 19 Jun 2010 11:15:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Walls <awalls@md.metrocast.net>,
       Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
Message-ID: <20100619091518.GG18946@basil.fritz.box>
References: <1276695665.9309.17.camel@m0nster>
 <4C18D574.1040903@kernel.org>
 <1276697146.9309.27.camel@m0nster>
 <1276776066.2461.15.camel@localhost>
 <87vd9fo1sk.fsf@basil.nowhere.org>
 <4C1C8263.9040404@kernel.org>
 <87fx0jo0z6.fsf@basil.nowhere.org>
 <4C1C8772.8090406@kernel.org>
 <20100619090851.GF18946@basil.fritz.box>
 <4C1C8A18.2030709@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1C8A18.2030709@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, in general, queueing to execution latency should be fairly low
> especially if it's put at the front of the queue but well it's nothing
> with any kind of guarantee.

This is not a hard real time situation with a hard deadline,
just "ASAP"

> I'm currently writing a kthread wrapper which basically provides
> similar interface to wq but guarantees binding to a specific thread
> which can be RT of course.  If single threadedness is acceptable, I
> think this would render better behavior.  What do you think?

I think I would prefer simply high priority, but normal work item.

Otherwise we have the thread hanging around all the time 
and on a large system it's still only a single one, so
it'll never scale.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
