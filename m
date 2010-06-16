Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab0FPRAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 13:00:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab0FPRAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 13:00:44 -0400
Message-ID: <4C19030A.4070406@redhat.com>
Date: Wed, 16 Jun 2010 12:59:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Christoph Hellwig <hch@infradead.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
References: <20100615141122.GA27893@infradead.org> <20100615142219.GE28052@random.random> <20100615144342.GA3339@infradead.org> <20100615150850.GF28052@random.random> <20100615152526.GA3468@infradead.org> <20100615154516.GG28052@random.random> <20100615162600.GA9910@infradead.org> <4C17AF2D.2060904@redhat.com> <20100615165423.GA16868@infradead.org> <4C17D0C5.9030203@redhat.com> <20100616075723.GT6138@laptop>
In-Reply-To: <20100616075723.GT6138@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 03:57 AM, Nick Piggin wrote:
> On Tue, Jun 15, 2010 at 03:13:09PM -0400, Rik van Riel wrote:
>> On 06/15/2010 12:54 PM, Christoph Hellwig wrote:
>>> On Tue, Jun 15, 2010 at 12:49:49PM -0400, Rik van Riel wrote:
>>>> This is already in a filesystem.  Why does ->writepage get
>>>> called a second time?  Shouldn't this have a gfp_mask
>>>> without __GFP_FS set?
>>>
>>> Why would it?  GFP_NOFS is not for all filesystem code, but only for
>>> code where we can't re-enter the filesystem due to deadlock potential.
>>
>> Why?   How about because you know the stack is not big enough
>> to have the XFS call path on it twice? :)
>>
>> Isn't the whole purpose of this patch series to prevent writepage
>> from being called by the VM, when invoked from a deep callstack
>> like xfs writepage?
>>
>> That sounds a lot like simply wanting to not have GFP_FS...
>
> buffered write path uses __GFP_FS by design because huge amounts
> of (dirty) memory can be allocated in doing pagecache writes. If
> would be nasty if that was not allowed to wait for filesystem
> activity.

__GFP_IO can wait for filesystem activity

__GFP_FS can kick off new filesystem activity

At least, that's how I remember it from when I last looked
at that code in detail.  Things may have changed subtly.

-- 
All rights reversed
