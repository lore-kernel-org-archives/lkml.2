Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab2HXDMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 23:12:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51875 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376Ab2HXDMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 23:12:44 -0400
Message-ID: <5036F111.4040607@redhat.com>
Date: Thu, 23 Aug 2012 23:12:17 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rafael Aquini <aquini@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v8 1/5] mm: introduce a common interface for balloon pages
 mobility
References: <20120822011930.GA23753@t510.redhat.com> <20120822093317.GC10680@redhat.com> <20120823021903.GA23660@x61.redhat.com> <20120823100107.GA17409@redhat.com> <20120823121338.GA3062@t510.redhat.com> <20120823123432.GA25659@redhat.com> <20120823130606.GB3746@t510.redhat.com> <20120823135328.GB25709@redhat.com> <20120823162504.GA1522@redhat.com> <20120823172844.GC10777@t510.redhat.com> <20120823233616.GB2775@redhat.com>
In-Reply-To: <20120823233616.GB2775@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 07:36 PM, Michael S. Tsirkin wrote:

> --->
>
> virtio-balloon: replace page->lru list with page->private.
>
> The point is to free up page->lru for use by compaction.
> Warning: completely untested, will provide tested version
> if we agree on this direction.

A singly linked list is not going to work for page migration,
which needs to get pages that might be in the middle of the
balloon list.

-- 
All rights reversed
