Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0FNVOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 17:14:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab0FNVOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 17:14:31 -0400
Message-ID: <4C169B81.8010707@redhat.com>
Date: Mon, 14 Jun 2010 17:13:37 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/12] vmscan: Write out dirty pages in batch
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-12-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1276514273-27693-12-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 07:17 AM, Mel Gorman wrote:
> Page reclaim cleans individual pages using a_ops->writepage() because from
> the VM perspective, it is known that pages in a particular zone must be freed
> soon, it considers the target page to be the oldest and it does not want
> to wait while background flushers cleans other pages. From a filesystem
> perspective this is extremely inefficient as it generates a very seeky
> IO pattern leading to the perverse situation where it can take longer to
> clean all dirty pages than it would have otherwise.

Reclaiming clean pages should be fast enough that this should
make little, if any, difference.

> This patch queues all dirty pages at once to maximise the chances that
> the write requests get merged efficiently. It also makes the next patch
> that avoids writeout from direct reclaim more straight-forward.

However, this is a convincing argument :)

> Signed-off-by: Mel Gorman<mel@csn.ul.ie>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
