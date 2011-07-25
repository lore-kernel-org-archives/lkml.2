Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab1GYXlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 19:41:07 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56896 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751Ab1GYXlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 19:41:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110725203705.GA21691@tassilo.jf.intel.com>
References: <1311625159-13771-1-git-send-email-jweiner@redhat.com>
	<1311625159-13771-5-git-send-email-jweiner@redhat.com>
	<20110725203705.GA21691@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 08:40:59 +0900
Message-ID: <CAEwNFnARzetfqZqjh_9-d+FOHtrCEwaSxgqBy_D+apxsNqzqkg@mail.gmail.com>
Subject: Re: [patch 4/5] mm: writeback: throttle __GFP_WRITE on per-zone dirty limits
From: Minchan Kim <minchan.kim@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Tue, Jul 26, 2011 at 5:37 AM, Andi Kleen <ak@linux.intel.com> wrote:
>> The global dirty limits are put in proportion to the respective zone's
>> amount of dirtyable memory and the allocation denied when the limit of
>> that zone is reached.
>>
>> Before the allocation fails, the allocator slowpath has a stage before
>> compaction and reclaim, where the flusher threads are kicked and the
>> allocator ultimately has to wait for writeback if still none of the
>> zones has become eligible for allocation again in the meantime.
>>
>
> I don't really like this. It seems wrong to make memory
> placement depend on dirtyness.
>
> Just try to explain it to some system administrator or tuner: her
> head will explode and for good reasons.
>
> On the other hand I like doing round-robin in filemap by default
> (I think that is what your patch essentially does)
> We should have made  this default long ago. It avoids most of the
> "IO fills up local node" problems people run into all the time.
>
> So I would rather just change the default in filemap allocation.
>
> That's also easy to explain.

Just out of curiosity.
Why do you want to consider only filemap allocation, not IO(ie,
filemap + sys_[read/write]) allocation?

-- 
Kind regards,
Minchan Kim
