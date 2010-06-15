Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab0FOKTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:19:19 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53258 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab0FOKTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:19:16 -0400
Date: Tue, 15 Jun 2010 11:18:58 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/12] vmscan: Write out dirty pages in batch
Message-ID: <20100615101857.GB26788@csn.ul.ie>
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-12-git-send-email-mel@csn.ul.ie> <4C169B81.8010707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4C169B81.8010707@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 05:13:37PM -0400, Rik van Riel wrote:
> On 06/14/2010 07:17 AM, Mel Gorman wrote:
>> Page reclaim cleans individual pages using a_ops->writepage() because from
>> the VM perspective, it is known that pages in a particular zone must be freed
>> soon, it considers the target page to be the oldest and it does not want
>> to wait while background flushers cleans other pages. From a filesystem
>> perspective this is extremely inefficient as it generates a very seeky
>> IO pattern leading to the perverse situation where it can take longer to
>> clean all dirty pages than it would have otherwise.
>
> Reclaiming clean pages should be fast enough that this should
> make little, if any, difference.
>

Indeed, this was a bit weak. The original point of the patch was to write
contiguous pages belonging to the same inode when they were encountered in
that batch which made a bit more sense but didn't work out at first
pass.

>> This patch queues all dirty pages at once to maximise the chances that
>> the write requests get merged efficiently. It also makes the next patch
>> that avoids writeout from direct reclaim more straight-forward.
>
> However, this is a convincing argument :)
>

Thanks.

>> Signed-off-by: Mel Gorman<mel@csn.ul.ie>
>
> Reviewed-by: Rik van Riel <riel@redhat.com>
>

Thanks again :)

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
