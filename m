Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab1ITSgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 14:36:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab1ITSgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 14:36:45 -0400
Message-ID: <4E78DD10.4000900@redhat.com>
Date: Tue, 20 Sep 2011 14:36:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Johannes Weiner <jweiner@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Minchan Kim <minchan.kim@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] mm: writeback: distribute write pages across allowable
 zones
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com> <1316526315-16801-3-git-send-email-jweiner@redhat.com>
In-Reply-To: <1316526315-16801-3-git-send-email-jweiner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2011 09:45 AM, Johannes Weiner wrote:
> This patch allows allocators to pass __GFP_WRITE when they know in
> advance that the allocated page will be written to and become dirty
> soon.  The page allocator will then attempt to distribute those
> allocations across zones, such that no single zone will end up full of
> dirty, and thus more or less, unreclaimable pages.
>
> The global dirty limits are put in proportion to the respective zone's
> amount of dirtyable memory and allocations diverted to other zones
> when the limit is reached.
>
> For now, the problem remains for NUMA configurations where the zones
> allowed for allocation are in sum not big enough to trigger the global
> dirty limits, but a future approach to solve this can reuse the
> per-zone dirty limit infrastructure laid out in this patch to have
> dirty throttling and the flusher threads consider individual zones.
>
> Signed-off-by: Johannes Weiner<jweiner@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

The amount of work done in a __GFP_WRITE allocation looks
a little daunting, but doing that a million times probably
outweighs waiting on the disk even once, so...
