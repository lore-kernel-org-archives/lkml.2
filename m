Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab2A0Qfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:35:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036Ab2A0Qfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:35:36 -0500
Message-ID: <4F22D236.4@redhat.com>
Date: Fri, 27 Jan 2012 11:35:02 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: linux-mm@kvack.org, lkml <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH v3 -mm 1/3] mm: reclaim at order 0 when compaction is
 enabled
References: <20120126145450.2d3d2f4c@cuia.bos.redhat.com> <20120126145914.58619765@cuia.bos.redhat.com> <CAJd=RBB=MDiYLVSYJj8d8NfBZp+OU0Lf3-W5+xZUqj0J1JA4cQ@mail.gmail.com>
In-Reply-To: <CAJd=RBB=MDiYLVSYJj8d8NfBZp+OU0Lf3-W5+xZUqj0J1JA4cQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 04:13 AM, Hillf Danton wrote:

>> @@ -1195,7 +1195,7 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
>>                         BUG();
>>                 }
>>
>> -               if (!order)
>> +               if (!sc->order || !(sc->reclaim_mode&  RECLAIM_MODE_LUMPYRECLAIM))
>>                         continue;
>>
> Just a tiny advice 8-)
>
> mind to move checking lumpy reclaim out of the loop,
> something like

Hehe, I made the change the way it is on request
of Mel Gorman :)

I don't particularly care either way and will be
happy to make the code whichever way people prefer.

Just let me know.

-- 
All rights reversed
