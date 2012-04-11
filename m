Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262Ab2DKUxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:53:43 -0400
Received: from mx2.parallels.com ([64.131.90.16]:56321 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760165Ab2DKUxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:53:41 -0400
Message-ID: <4F85EEED.1090906@parallels.com>
Date: Wed, 11 Apr 2012 17:51:57 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <devel@openvz.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] remove BUG() in possible but rare condition
References: <1334167824-19142-1-git-send-email-glommer@parallels.com> <20120411132635.bfddc6bd.akpm@linux-foundation.org>
In-Reply-To: <20120411132635.bfddc6bd.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 05:26 PM, Andrew Morton wrote:
>>
>> >    failed:
>> >  -	BUG();
>> >    	unlock_page(page);
>> >    	page_cache_release(page);
>> >    	return NULL;
> Cute.
>
> AFAICT what happened was that in my April 2002 rewrite of this code I
> put a non-fatal buffer_error() warning in that case to tell us that
> something bad happened.
>
> Years later we removed the temporary buffer_error() and mistakenly
> replaced that warning with a BUG().  Only it*can*  happen.
>
> We can remove the BUG() and fix up callers, or we can pass retry=1 into
> alloc_page_buffers(), so grow_dev_page() "cannot fail".  Immortal
> functions are a silly fiction, so we should remove the BUG() and fix up
> callers.
>
Any particular caller you are concerned with ?

As I mentioned, this function already returns NULL for other reason - 
that seem even more probable than this specific failure. So whoever is
not checking this return value, is already broken without this patch as 
well.


