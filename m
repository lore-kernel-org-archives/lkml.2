Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab2B0QOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:14:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab2B0QOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:14:24 -0500
Message-ID: <4F4BABBA.9050207@redhat.com>
Date: Mon, 27 Feb 2012 11:13:46 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, hughd@google.com
Subject: Re: [PATCH -mm 2/2] mm: do not reset mm->free_area_cache on every
 single munmap
References: <20120223145417.261225fd@cuia.bos.redhat.com> <20120223150034.2c757b3a@cuia.bos.redhat.com> <m2vcmxp609.fsf@firstfloor.org>
In-Reply-To: <m2vcmxp609.fsf@firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 04:57 PM, Andi Kleen wrote:
> Rik van Riel<riel@redhat.com>  writes:
>
>> Some programs have a large number of VMAs, and make frequent calls
>> to mmap and munmap. Having munmap constantly cause the search
>> pointer for get_unmapped_area to get reset can cause a significant
>> slowdown for such programs.
>
> This would be a much nicer patch if you split it into one that merges
> all the copy'n'paste code and another one that actually implements
> the new algorithm.

The copy'n'pasted functions are not quite the same, though.

All the ones that could be unified already have been, leaving
a few functions with actual differences around.

-- 
All rights reversed
