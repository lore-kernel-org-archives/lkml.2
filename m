Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab0FOO4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:56:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757939Ab0FOO4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:56:02 -0400
Message-ID: <4C17945A.5070500@redhat.com>
Date: Tue, 15 Jun 2010 10:55:22 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC PATCH 0/6] Do not call ->writepage[s] from direct reclaim
 and use a_ops->writepages() where possible
References: <1275987745-21708-1-git-send-email-mel@csn.ul.ie> <20100615140011.GD28052@random.random> <20100615145134.GM26788@csn.ul.ie>
In-Reply-To: <20100615145134.GM26788@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 10:51 AM, Mel Gorman wrote:
> On Tue, Jun 15, 2010 at 04:00:11PM +0200, Andrea Arcangeli wrote:
>> Hi Mel,
>>
>> I know lots of people doesn't like direct reclaim,
>
> It's not direct reclaim that is the problem per-se, it's direct reclaim
> calling writepage and splicing two potentially deep call chains
> together.

I have talked to Mel on IRC, and the above means:

"calling alloc_pages from an already deep stack frame,
  and then going into direct reclaim"

That explanation would have been helpful in email :)

-- 
All rights reversed
