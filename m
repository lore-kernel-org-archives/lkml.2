Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0H2Pt1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:49:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753821Ab0H2PtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:49:25 -0400
Message-ID: <4C7A8173.5060306@redhat.com>
Date: Sun, 29 Aug 2010 11:49:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>, Ying Han <yinghan@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap
 system
References: <1283096628-4450-1-git-send-email-minchan.kim@gmail.com>
In-Reply-To: <1283096628-4450-1-git-send-email-minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2010 11:43 AM, Minchan Kim wrote:

> This patch prevents unnecessary anon pages demotion in not-swapon and
> non-configured swap system. Of course, it could make side effect that
> hot anon pages could swap out when admin does swap on.
> But I think sooner or later it would be steady state.
> So it's not a big problem.
> We could lose someting but gain more thing(TLB flush and unnecessary
> function call to demote anon pages).

A agree that is not a big worry.  I expect virtually all the
systems with swap space will do swapon at boot time.

> I used total_swap_pages because we want to age anon pages
> even though swap full happens.
>
> Cc: Rik van Riel<riel@redhat.com>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner<hannes@cmpxchg.org>
> Reported-by: Ying Han<yinghan@google.com>
> Signed-off-by: Minchan Kim<minchan.kim@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
