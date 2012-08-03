Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2HCM1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:27:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab2HCM1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:27:41 -0400
Date: Fri, 3 Aug 2012 09:26:57 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rafael Aquini <aquini@linux.com>
Subject: Re: [PATCH v4 1/3] mm: introduce compaction and migration for virtio
 ballooned pages
Message-ID: <20120803122656.GB1848@t510.redhat.com>
References: <cover.1342485774.git.aquini@redhat.com>
 <49f828a9331c9b729fcf77226006921ec5bc52fa.1342485774.git.aquini@redhat.com>
 <20120718054824.GA32341@bbox>
 <20120720194858.GA16249@t510.redhat.com>
 <20120723023332.GA6832@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120723023332.GA6832@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 11:33:32AM +0900, Minchan Kim wrote:
> Look at memory-hotplug, offline_page calls has_unmovable_pages, scan_lru_pages
> and do_migrate_range which calls isolate_lru_page. They consider only LRU pages
> to migratable ones.
>
As promised, I looked into those bits. Yes, they only isolate LRU pages, and as
such, having this series merged or not doesn't change a bit for that code path.
In fact, having this series merged and teaching hotplug's
offline_pages()/do_migrate_rage() about ballooned pages might be extremely
beneficial in the rare event offlining memory stumbles across a balloon page.

As Rik said, I believe this is something we can look into in the near future.
 
> IMHO, better approach is that after we can get complete free pageblocks
> by compaction or reclaim, move balloon pages into that pageblocks and make
> that blocks to unmovable. It can prevent fragmentation and it makes
> current or future code don't need to consider balloon page.
> 
I totally agree with Rik on this one, as well. This is the wrong approach here.

All that said, I'll soon respin a v5 based on your comments on branch hinting and
commentary improvements, as well as addressing AKPM's concerns. I'll also revert
isolate_balloon_page() last changes back to make it a public symbol again, as
(I believe) we'll shortly be using it for letting hotplug bits aware of how to
isolate ballooned pages.


