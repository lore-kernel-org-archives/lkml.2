Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab1ELRae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 13:30:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758008Ab1ELRab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 13:30:31 -0400
Date: Thu, 12 May 2011 10:37:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mel Gorman <mgorman@suse.de>, Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
Message-Id: <20110512103709.abbc9872.akpm@linux-foundation.org>
In-Reply-To: <1305216638.3795.36.camel@edumazet-laptop>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de>
	<1305127773-10570-4-git-send-email-mgorman@suse.de>
	<alpine.DEB.2.00.1105120942050.24560@router.home>
	<1305213359.2575.46.camel@mulgrave.site>
	<alpine.DEB.2.00.1105121024350.26013@router.home>
	<1305214993.2575.50.camel@mulgrave.site>
	<alpine.DEB.2.00.1105121050220.26013@router.home>
	<1305216638.3795.36.camel@edumazet-laptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011 18:10:38 +0200 Eric Dumazet <eric.dumazet@gmail.com> wrote:

> More fuel to this discussion with commit 6d4831c2
> 
> Something is wrong with high order allocations, on some machines.
> 
> Maybe we can find real cause instead of limiting us to use order-0 pages
> in the end... ;)
> 
> commit 6d4831c283530a5f2c6bd8172c13efa236eb149d
> Author: Andrew Morton <akpm@linux-foundation.org>
> Date:   Wed Apr 27 15:26:41 2011 -0700
> 
>     vfs: avoid large kmalloc()s for the fdtable

Well, it's always been the case that satisfying higher-order
allocations take a disproportionate amount of work in page reclaim. 
And often causes excessive reclaim.

That's why we've traditionally worked to avoid higher-order
allocations, and this has always been a problem with slub.

But the higher-order allocations shouldn't cause the VM to melt down. 
We changed something, and now it melts down.  Changing slub to avoid
that meltdown doesn't fix the thing we broke.

