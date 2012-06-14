Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2FNBtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 21:49:50 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45875 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755045Ab2FNBts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 21:49:48 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-6b-4fd9433a627d
Message-ID: <4FD9433C.4060503@kernel.org>
Date: Thu, 14 Jun 2012 10:49:48 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: do not use page_count without a page pin
References: <1339373872-31969-1-git-send-email-minchan@kernel.org> <4FD59C31.6000606@jp.fujitsu.com> <20120611074440.GI3094@redhat.com> <20120611133043.GA2340@barrios> <20120611144132.GT3094@redhat.com> <4FD675FE.1060202@kernel.org> <20120614012103.GY3094@redhat.com>
In-Reply-To: <20120614012103.GY3094@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 10:21 AM, Andrea Arcangeli wrote:

> On Tue, Jun 12, 2012 at 07:49:34AM +0900, Minchan Kim wrote:
>> If THP page isn't LRU and it's still PageTransHuge, I think it's rather rare and
>> although it happens, it means migration/reclaimer is about to split or isolate/putback
>> so it ends up making THP page movable pages.
>>
>> IMHO, it would be better to account it by movable pages.
>> What do you think about it?
> 
> Agreed. Besides THP don't fragment pageblocks. It was just about
> speeding up the scanning the same way it happens with the pagebuddy
> check, but probably not worth it because we're in a racy area here not
> holding locks. pagebuddy is safe because the zone lock is hold, or
> it'd run in the same problem.


Yeb. zone lock is already hold so pagebuddy check is safe but THP still in a racy so let's leave it as it is.
If you don't have concern about this patch any more, could you add Acked-by in my latest patch for Andrew
to pick up? Although you have a concern, let's make it as separate patch because it's optimization patch and 
other patch is pending by this.

Thanks, Andrea.

-- 
Kind regards,
Minchan Kim
