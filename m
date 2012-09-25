Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2IYBQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 21:16:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab2IYBQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 21:16:12 -0400
Date: Tue, 25 Sep 2012 03:17:25 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v10 0/5] make balloon pages movable by compaction
Message-ID: <20120925011725.GB22893@redhat.com>
References: <cover.1347897793.git.aquini@redhat.com>
 <20120917151531.e9ac59f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917151531.e9ac59f2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 03:15:31PM -0700, Andrew Morton wrote:
> How can a patchset reach v10 and have zero Reviewed-by's?

I think the problem is, this adds an API between mm and balloon
device that is pretty complex: consider that previously we literally
only used alloc_page, __free_page and page->lru field.

So you end up with a problem: mm bits don't do anything
by themselves so mm people aren't very interested and
don't know about virtio anyway, while
we virtio device driver people lack a clue about compaction.

Having said that I think I'm getting my head about some of the issues so
I commented and the patchset is hopefully getting there.

-- 
MST
