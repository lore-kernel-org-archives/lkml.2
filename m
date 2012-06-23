Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2FWPxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 11:53:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab2FWPxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 11:53:37 -0400
Message-ID: <4FE5E66C.6080309@redhat.com>
Date: Sat, 23 Jun 2012 11:53:16 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Minchan Kim <minchan@kernel.org>, John Stultz <john.stultz@linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Pekka Enberg <penberg@kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Hugh Dickins <hughd@google.com>
Subject: Re: RFC:  Easy-Reclaimable LRU list
References: <4FE012CD.6010605@kernel.org> <4FE37434.808@linaro.org> <4FE41752.8050305@kernel.org> <4FE549E8.2050905@jp.fujitsu.com>
In-Reply-To: <4FE549E8.2050905@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2012 12:45 AM, Kamezawa Hiroyuki wrote:

> I think this is interesting approach. Major concern is how to guarantee
> EReclaimable
> pages are really EReclaimable...Do you have any idea ? madviced pages
> are really EReclaimable ?

I suspect the EReclaimable pages can only be clean page
cache pages that are not mapped by any processes.

Once somebody tries to use the page, mark_page_accessed
will move it to another list.

> A (very) small concern is will you use one more page-flags for this ? ;)

This could be an issue on a 32 bit system, true.

-- 
All rights reversed
