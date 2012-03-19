Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161150Ab2CSR6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:58:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34756 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823Ab2CSR6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:58:46 -0400
Message-ID: <4F6773CC.2010705@openvz.org>
Date: Mon, 19 Mar 2012 21:58:36 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: forbid lumpy-reclaim in shrink_active_list()
References: <20120319091821.17716.54031.stgit@zurg> <4F676FA4.50905@redhat.com>
In-Reply-To: <4F676FA4.50905@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On 03/19/2012 05:18 AM, Konstantin Khlebnikov wrote:
>> This patch reset reclaim mode in shrink_active_list() to RECLAIM_MODE_SINGLE | RECLAIM_MODE_ASYNC.
>> (sync/async sign is used only in shrink_page_list and does not affect shrink_active_list)
>>
>> Currenly shrink_active_list() sometimes works in lumpy-reclaim mode,
>> if RECLAIM_MODE_LUMPYRECLAIM left over from earlier shrink_inactive_list().
>> Meanwhile, in age_active_anon() sc->reclaim_mode is totally zero.
>> So, current behavior is too complex and confusing, all this looks like bug.
>>
>> In general, shrink_active_list() populate inactive list for next shrink_inactive_list().
>> Lumpy shring_inactive_list() isolate pages around choosen one from both active and
>> inactive lists. So, there no reasons for lumpy-isolation in shrink_active_list()
>>
>> Proposed-by: Hugh Dickins<hughd@google.com>
>> Link: https://lkml.org/lkml/2012/3/15/583
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>
> Confirmed, this is already done by commit
> 26f5f2f1aea7687565f55c20d69f0f91aa644fb8 in the
> linux-next tree.
>

No, your patch fix this problem only if CONFIG_COMPACTION=y
