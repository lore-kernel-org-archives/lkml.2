Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0F1XSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 19:18:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35559 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab0F1XSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 19:18:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gklXZZ6uQrLmjwNRtRR9GkLmyrw46+6pQNHUyqPBReNNJn+I3jdXns6sx67uuixJCE
         9o+E74hm7gNulAEPX2BzUVNMkykA/Qb1+KfK5D4grndkXveM8/8X9h1RUuJnbVbt8/vH
         oQRPKMpEEWdbAJ8h9M735aWf2Ci99cAImQauU=
Date: Tue, 29 Jun 2010 01:18:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, dwalker@codeaurora.org,
       stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#6
Message-ID: <20100628231812.GC10104@nowhere>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277759063-24607-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 11:03:48PM +0200, Tejun Heo wrote:
> B. General documentation of Concurrency Managed Workqueue (cmwq)
> ================================================================


It would be nice to get this in Documentation/workqueue-design.txt,
as the design is complicated enough to deserve this file :)



> == B-4. Concurrency managed shared worker pool
> 
> For any worker pool, managing the concurrency level (how many workers
> are executing simultaneously) is an important issue.  cmwq tries to
> keep the concurrency at minimal but sufficient level.
> 
> Concurrency management is implemented by hooking into the scheduler.
> The gcwq is notified whenever a busy worker wakes up or sleeps and
> keeps track of the level of concurrency.  Generally, works aren't
> supposed to be cpu cycle hogs and maintaining just enough concurrency
> to prevent work processing from stalling is optimal.  As long as
> there's one or more workers running on the cpu, no new worker is
> scheduled, but, when the last running worker blocks, the gcwq
> immediately schedules a new worker so that the cpu doesn't sit idle
> while there are pending works.
> 
> This allows using minimal number of workers without losing execution
> bandwidth.  Keeping idle workers around doesn't cost other than the
> memory space for kthreads, so cmwq holds onto idle ones for a while
> before killing them.
> 
> As multiple execution contexts are available for each wq, deadlocks
> around execution contexts is much harder to create.  The default wq,
> system_wq, has maximum concurrency level of 256 and unless there is a
> scenario which can result in a dependency loop involving more than 254
> workers, it won't deadlock.



Why this arbitrary limitation?

Thanks.

