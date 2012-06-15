Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab2FOPwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:52:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38473 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab2FOPwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:52:40 -0400
Message-ID: <4FDB5A42.9020707@gmail.com>
Date: Fri, 15 Jun 2012 11:52:34 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: clear pages_scanned only if draining a pcp adds pages
 to the buddy allocator again
References: <1339690570-7471-1-git-send-email-kosaki.motohiro@gmail.com> <4FDAE1F0.4030708@kernel.org>
In-Reply-To: <4FDAE1F0.4030708@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/15/12 3:19 AM), Minchan Kim wrote:
> On 06/15/2012 01:16 AM, kosaki.motohiro@gmail.com wrote:
>
>> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>>
>> commit 2ff754fa8f (mm: clear pages_scanned only if draining a pcp adds pages
>> to the buddy allocator again) fixed one free_pcppages_bulk() misuse. But two
>> another miuse still exist.
>>
>> This patch fixes it.
>>
>> Cc: David Rientjes<rientjes@google.com>
>> Cc: Mel Gorman<mel@csn.ul.ie>
>> Cc: Johannes Weiner<hannes@cmpxchg.org>
>> Cc: Minchan Kim<minchan.kim@gmail.com>
>> Cc: Wu Fengguang<fengguang.wu@intel.com>
>> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: Rik van Riel<riel@redhat.com>
>> Cc: Andrew Morton<akpm@linux-foundation.org>
>> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>
> Reviewed-by: Minchan Kim<minchan@kernel.org>
>
> Just nitpick.
> Personally, I want to fix it follwing as
> It's more simple and reduce vulnerable error in future.
>
> If you mind, go ahead with your version. I am not against with it, either.

I don't like your version because free_pcppages_bulk() can be called from
free_pages() hotpath. then, i wouldn't like to put a branch if we can avoid it.
