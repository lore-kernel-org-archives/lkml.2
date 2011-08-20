Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1HTKsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 06:48:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45637 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab1HTKst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 06:48:49 -0400
Date: Sat, 20 Aug 2011 13:48:43 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@localhost6.localdomain6
To: Christoph Lameter <cl@linux.com>
cc: linux-kernel@vger.kernel.org, rientjes@google.com, andi@firstfloor.org,
        mgorman@suse.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [slub p4 0/7] slub: per cpu partial lists V4
In-Reply-To: <20110809211221.831975979@linux.com>
Message-ID: <alpine.DEB.2.00.1108201345130.3008@localhost6.localdomain6>
References: <20110809211221.831975979@linux.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011, Christoph Lameter wrote:
> V3->V4 : Use a single linked per cpu list instead of a per cpu array.
> 	This results in improvements even for the single threaded
> 	case. I think this is ready for more widespread testing (-next?)
> 	The number of partial pages per cpu is configurable via
> 	/sys/kernel/slab/<name>/cpu_partial
>
> V2->V3 : Work on the todo list. Still some work to be done to reduce
>         code impact and make this all cleaner. (Pekka: patch 1-3
>         are cleanup patches of general usefulness. You got #1 already
>         2+3 could be picked up w/o any issue).
>
> The following patchset introduces per cpu partial lists which allow
> a performance increase of around ~10-20% with hackbench on my Sandybridge
> processor.
>
> These lists help to avoid per node locking overhead. Allocator latency
> could be further reduced by making these operations work without
> disabling interrupts (like the fastpath and the free slowpath) but that
> is another project.
>
> It is interesting to note that BSD has gone to a scheme with partial
> pages only per cpu (source: Adrian). Transfer of cpu ownerships is
> done using IPIs. Probably too much overhead for our taste. The approach
> here keeps the per node partial lists essentially meaning the "pages"
> in there have no cpu owner.

These patches are now in slub/partial branch of slab.git. I'll probably 
queue them for linux-next early next week if they don't explode on my 
machine.

 			Pekka
