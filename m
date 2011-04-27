Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275Ab1D0Xr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:47:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760230Ab1D0XrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:47:25 -0400
Message-ID: <4DB8AAE3.20806@redhat.com>
Date: Wed, 27 Apr 2011 19:46:43 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.38.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC 6/8] In order putback lru core
References: <cover.1303833415.git.minchan.kim@gmail.com> <51e7412097fa62f86656c77c1934e3eb96d5eef6.1303833417.git.minchan.kim@gmail.com>
In-Reply-To: <51e7412097fa62f86656c77c1934e3eb96d5eef6.1303833417.git.minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2011 12:25 PM, Minchan Kim wrote:

> But this approach has a problem on contiguous pages.
> In this case, my idea can not work since friend pages are isolated, too.
> It means prev_page->next == next_page always is false and both pages are not
> LRU any more at that time. It's pointed out by Rik at LSF/MM summit.
> So for solving the problem, I can change the idea.
> I think we don't need both friend(prev, next) pages relation but
> just consider either prev or next page that it is still same LRU.

> Any comment?

If the friend pages are isolated too, then your condition
"either prev or next page that it is still same LRU" is
likely to be false, no?


-- 
All rights reversed
