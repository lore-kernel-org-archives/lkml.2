Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab0KQK4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 05:56:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35884 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541Ab0KQK4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 05:56:06 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/28] [rfc] dcache scaling part 1
References: <20101116140900.039761100@kernel.dk>
Date: Wed, 17 Nov 2010 11:56:02 +0100
In-Reply-To: <20101116140900.039761100@kernel.dk> (Nick Piggin's message of
	"Wed, 17 Nov 2010 01:09:00 +1100")
Message-ID: <877hgcrzgd.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@kernel.dk> writes:

> There are 3 main parts to dcache scaling. This one primarily adds new locks
> to take over dcache_lock, and some pre/post prep and streamlining patches.
>
> The second implements fine grained locking, and is rather trivial after
> part 1.
>
> The third implements rcu-walk. rcu-walk depends on the first part, because it
> relies on using d_lock to protect the state of the dentry (when converting from
> rcu-walk to refcounted walk). Without the fine grained locing, we'd need to use
> dcache_lock for that, which would be a step backwards to put into path walking
> again.
>
> Comments?

I read 15, 10, 8, 5, 4, 3, 1 so far (weird order, it showed that way in
my reader :-) There was nothing surprising in any of those and they all
seem to do what the description advertises.

I was scared a bit by the upto 4 level dcache lock nestings, but I
assume those will get better again when everything is done.
At least from a quick look they seem to be all in the right order
(I assume you attempted some runtime coverage with lockdep too, right?)

For some of the hash lists it may become attractive to consider
the newly posted lockless list, but it wasn't fully clear
if that was easy to do (the lock protected a bit more than
just the list node)

For the level file system tree sweep changes it would be nice
if there were semantic patches available. That would make
it easier to verify the changes have been consistently
done, by rerunning the patcher.

You can add a Reviewed-by: Andi Kleen <ak@linux.intel.com>
to the patches listed above.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
