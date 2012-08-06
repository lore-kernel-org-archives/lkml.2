Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab2HFTHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:07:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932380Ab2HFTHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:07:06 -0400
Message-ID: <502015C9.2@redhat.com>
Date: Mon, 06 Aug 2012 15:06:49 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rafael Aquini <aquini@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v5 1/3] mm: introduce compaction and migration for virtio
 ballooned pages
References: <cover.1344259054.git.aquini@redhat.com> <212b5297df32cb4e3f60d5b76a8cb0629d328a4e.1344259054.git.aquini@redhat.com> <50200F1F.7060605@redhat.com> <20120806190053.GA3968@t510.redhat.com>
In-Reply-To: <20120806190053.GA3968@t510.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 03:00 PM, Rafael Aquini wrote:
> On Mon, Aug 06, 2012 at 02:38:23PM -0400, Rik van Riel wrote:
>> On 08/06/2012 09:56 AM, Rafael Aquini wrote:
>>
>>> @@ -846,6 +861,21 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>>>   			goto out;
>>>
>>>   	rc = __unmap_and_move(page, newpage, force, offlining, mode);
>>> +
>>> +	if (unlikely(is_balloon_page(newpage)&&
>>> +		     balloon_compaction_enabled())) {
>>
>> Could that be collapsed into one movable_balloon_page(newpage) function
>> call?
>>
> Keeping is_balloon_page() as is, and itroducing this new movable_balloon_page()
> function call, or just doing a plain rename, as Andrew has first suggested?

Just a plain rename would work.

> +static inline bool is_balloon_page(struct page *page)
> +{
> +	return (page->mapping && page->mapping == balloon_mapping);
> +}

As an aside, since you are only comparing page->mapping and
not dereferencing it, it can be simplified to just:

	return (page->mapping == balloon_mapping);



-- 
All rights reversed
