Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab0FOOi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:38:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757869Ab0FOOi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:38:27 -0400
Message-ID: <4C1787DF.3020102@redhat.com>
Date: Tue, 15 Jun 2010 10:02:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 12/12] vmscan: Do not writeback pages in direct reclaim
References: <1276514273-27693-1-git-send-email-mel@csn.ul.ie> <1276514273-27693-13-git-send-email-mel@csn.ul.ie> <4C16A567.4080000@redhat.com> <20100615114510.GE26788@csn.ul.ie> <4C17815A.8080402@redhat.com> <20100615133727.GA27980@infradead.org>
In-Reply-To: <20100615133727.GA27980@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 09:37 AM, Christoph Hellwig wrote:
> On Tue, Jun 15, 2010 at 09:34:18AM -0400, Rik van Riel wrote:
>> If direct reclaim can overflow the stack, so can direct
>> memcg reclaim.  That means this patch does not solve the
>> stack overflow, while admitting that we do need the
>> ability to get specific pages flushed to disk from the
>> pageout code.
>
> Can you explain what the hell memcg reclaim is and why it needs
> to reclaim from random contexts?

The page fault code will call the cgroup accounting code.

When a cgroup goes over its memory limit, __mem_cgroup_try_charge
will call mem_cgroup_hierarchical_reclaim, which will then go
into the page reclaim code.

> It seems everything that has a cg in it's name that I stumbled over
> lately seems to be some ugly wart..

No argument there.  It took me a few minutes to find the code
path above :)

-- 
All rights reversed
