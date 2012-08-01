Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab2HAUxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:53:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab2HAUxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:53:38 -0400
Message-ID: <501996CD.70007@redhat.com>
Date: Wed, 01 Aug 2012 16:51:25 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rafael Aquini <aquini@linux.com>
Subject: Re: [PATCH v4 1/3] mm: introduce compaction and migration for virtio
 ballooned pages
References: <cover.1342485774.git.aquini@redhat.com> <49f828a9331c9b729fcf77226006921ec5bc52fa.1342485774.git.aquini@redhat.com> <20120718054824.GA32341@bbox> <20120720194858.GA16249@t510.redhat.com> <20120723023332.GA6832@bbox>
In-Reply-To: <20120723023332.GA6832@bbox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2012 10:33 PM, Minchan Kim wrote:

> IMHO, better approach is that after we can get complete free pageblocks
> by compaction or reclaim, move balloon pages into that pageblocks and make
> that blocks to unmovable. It can prevent fragmentation and it makes
> current or future code don't need to consider balloon page.

I believe this is the wrong thing to do.

In a KVM guest, getting applications in transparent
huge pages can be a 10-25% performance benefit.

Therefore, we need to make all the 2MB pageblocks
we can available for use by userland.

Using 2MB blocks for the balloon (which is never
touched) is extremely wasteful and could result in
a large performance penalty, if we cannot defragment
the remaining memory enough to give 2MB pages to
applications.

The 2MB blocks are prime real estate. They should
remain available for applications.


