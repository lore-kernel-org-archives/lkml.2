Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030965Ab2CSRlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:41:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab2CSRlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:41:05 -0400
Message-ID: <4F676FA4.50905@redhat.com>
Date: Mon, 19 Mar 2012 13:40:52 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: forbid lumpy-reclaim in shrink_active_list()
References: <20120319091821.17716.54031.stgit@zurg>
In-Reply-To: <20120319091821.17716.54031.stgit@zurg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 05:18 AM, Konstantin Khlebnikov wrote:
> This patch reset reclaim mode in shrink_active_list() to RECLAIM_MODE_SINGLE | RECLAIM_MODE_ASYNC.
> (sync/async sign is used only in shrink_page_list and does not affect shrink_active_list)
>
> Currenly shrink_active_list() sometimes works in lumpy-reclaim mode,
> if RECLAIM_MODE_LUMPYRECLAIM left over from earlier shrink_inactive_list().
> Meanwhile, in age_active_anon() sc->reclaim_mode is totally zero.
> So, current behavior is too complex and confusing, all this looks like bug.
>
> In general, shrink_active_list() populate inactive list for next shrink_inactive_list().
> Lumpy shring_inactive_list() isolate pages around choosen one from both active and
> inactive lists. So, there no reasons for lumpy-isolation in shrink_active_list()
>
> Proposed-by: Hugh Dickins<hughd@google.com>
> Link: https://lkml.org/lkml/2012/3/15/583
> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>

Confirmed, this is already done by commit
26f5f2f1aea7687565f55c20d69f0f91aa644fb8 in the
linux-next tree.

-- 
All rights reversed
