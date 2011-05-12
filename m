Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab1ELQFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:05:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757914Ab1ELQFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:05:40 -0400
Message-ID: <4DCC051E.4000206@redhat.com>
Date: Thu, 12 May 2011 12:04:46 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [rfc patch 3/6] mm: memcg-aware global reclaim
References: <1305212038-15445-1-git-send-email-hannes@cmpxchg.org> <1305212038-15445-4-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1305212038-15445-4-git-send-email-hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 10:53 AM, Johannes Weiner wrote:

> I am open to solutions that trade fairness against CPU-time but don't
> want to have an extreme in either direction.  Maybe break out early if
> a number of memcgs has been successfully reclaimed from and remember
> the last one scanned.

The way we used to deal with this when we did per-process
virtual scanning (before rmap), was to scan the process at
the head of the list.

After we were done with that process, it got moved to the
back of the list.  If enough had been scanned, we bailed
out of the scanning code alltogether; if more needed to
be scanned, we moved on to the next process.

Doing a list move after scanning a bunch of pages in the
LRU lists of a cgroup isn't nearly as expensive as having
to scan all the cgroups.
