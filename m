Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1GSPiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 11:38:21 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56367 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1GSPiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 11:38:19 -0400
Subject: Re: [RFC][PATCH] Anonymous shared memory (ashmem) subsystem
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Bryan Donlan <bdonlan@gmail.com>, John Stultz <john.stultz@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20110719033602.GA4867@infradead.org>
References: <1311015274-28650-1-git-send-email-john.stultz@linaro.org>
	 <20110719021947.GA16986@infradead.org>
	 <CAF_S4t_oOwsuPJdMXv+wPVhzecUag=TOWj1-KtFJqYUZOCBbog@mail.gmail.com>
	 <20110719033602.GA4867@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 08:37:43 -0700
Message-ID: <1311089863.29817.172.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 23:36 -0400, Christoph Hellwig wrote:
> > But yes, tmpfs
> > already solved the problem of getting a shared-memory file descriptor
> > - just open a random-name file in tmpfs, unlink it, and start passing
> > it around.
> 
> Indeed.  And as mentioned before using /dev/zero as the file will
> get you a pre-unlinked tmpfs fd without any races, and without the
> need of actually mounting shmem into any namespace. 

"Why not use tmpfs?" was my gut reaction, too.  The patch is named a bit
unfortunately, but I think the key bit in them is the "volatile" pages,
not the "anonymous" or "shared memory" features.

Those let userspace allocate things like caches, and lets the kernel
destructively (but safely) reclaim them when there's memory pressure
(implemented as a slab shrinker here).  It's kinda like a kernel-driven
garbage collector, or even like a distant relative of those CMM2 patches
from the s390 folks a few years ago.

This implementation has some real show-stopper things in it, like its
own LRU.  But, the concept seems interesting at least.

-- Dave

