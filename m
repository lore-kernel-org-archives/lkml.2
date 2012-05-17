Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820Ab2EQNLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 09:11:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417Ab2EQNLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 09:11:49 -0400
Message-ID: <4FB4F902.1050708@redhat.com>
Date: Thu, 17 May 2012 09:11:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "nai.xia" <nai.xia@gmail.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] refault distance-based file cache sizing
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org> <4FB33A4E.1010208@gmail.com>
In-Reply-To: <4FB33A4E.1010208@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 01:25 AM, nai.xia wrote:
> Hi Johannes,
>
> Just out of curiosity(since I didn't study deep into the
> reclaiming algorithms), I can recall from here that around 2005,
> there was an(or some?) implementation of the "Clock-pro" algorithm
> which also have the idea of "reuse distance", but it seems that algo
> did not work well enough to get merged?

The main issue with clock-pro was scalability.

Johannes has managed to take the good parts of clock-pro,
and add it on top of our split lru VM, which lets us keep
the scalability, while still being able to deal with file
faults from beyond the inactive list.

-- 
All rights reversed
