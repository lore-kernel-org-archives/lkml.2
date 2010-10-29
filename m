Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917Ab0J2OZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:25:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:57625 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933907Ab0J2OZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:25:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,259,1286175600"; 
   d="scan'208";a="342132535"
Date: Fri, 29 Oct 2010 16:27:41 +0200
From: Andi Kleen <andi.kleen@intel.com>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Russell King <linux@arm.linux.org.uk>, Pawel Osciak <pawel@osciak.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 0/3] big chunk memory allocator v2
Message-ID: <20101029142741.GB19823@gargoyle.fritz.box>
References: <20101026190042.57f30338.kamezawa.hiroyu@jp.fujitsu.com>
 <AANLkTim4fFXQKqmFCeR8pvi0SZPXpjDqyOkbV6PYJYkR@mail.gmail.com>
 <op.vlbywq137p4s8u@pikus>
 <20101029103154.GA10823@gargoyle.fritz.box>
 <20101029195900.88559162.kamezawa.hiroyu@jp.fujitsu.com>
 <20101029122928.GA17792@gargoyle.fritz.box>
 <op.vlb8bda87p4s8u@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vlb8bda87p4s8u@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 01:43:51PM +0100, Michał Nazarewicz wrote:
> >>>> (ii) is used only if all other (non-reserved) pages have
> >>>> been allocated.
> 
> >>> That will be near always the case after some uptime, as memory fills up
> >>> with caches. Unless you do early reclaim?
> 
> Hmm... true.  Still the point remains that only movable and reclaimable pages are
> allowed in the marked regions.  This in effect means that from unmovable pages
> point of view, the area is unusable but I havn't thought of any other way to
> guarantee that because of fragmentation, long sequence of free/movable/reclaimable
> pages is available.

Essentially a movable zone as defined today.

That gets you near all the problems of highmem (except for the mapping
problem and you're a bit more flexible in the splits): 

Someone has to decide at boot how much should be movable
and what not, some workloads will run out of space, some may
deadlock when it runs out of management objects, etc.etc. 
Classic highmem had a long string of issues with all of this.

If it was an easy problem it had been long solved, but it isn't really.

-Andi

