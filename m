Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab0HWQEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:04:47 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:24814 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753308Ab0HWQEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:04:45 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: G_209aYVM1lHxsdfXG4fuMqcHbaKyneeruVV0_hrg4WomId
 vuuk2KVHYT6VTGQwxt5GcvOvZhVuOuJvHaVrP545JAxw8b6.Bio6iqnZe7oy
 6mP58GyN0pm4tP6Q0QAJSZvlj_Yr5Fqrvzj4.fflFtWoAzH02NlY9Shd8nZT
 WU8vWGQdK7SK6tdoKXpMj_arhqs0ozq.wpoMYN77I0vblXAPOBNyxNp.AX_l
 L
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 23 Aug 2010 11:04:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] mm: page allocator: Calculate a better estimate of
 NR_FREE_PAGES when memory is low and kswapd is awake
In-Reply-To: <20100823135559.GS19797@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1008231059580.8601@router.home>
References: <1282550442-15193-1-git-send-email-mel@csn.ul.ie> <1282550442-15193-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1008230750380.4094@router.home> <20100823130315.GQ19797@csn.ul.ie> <alpine.DEB.2.00.1008230838320.5750@router.home>
 <20100823135559.GS19797@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Mel Gorman wrote:

> > When the vm gets into a state where continual reclaim is necessary then
> > the counters are not that frequently updated. If the machine is already
> > slowing down due to reclaim then the vm can likely affort more frequent
> > counter updates.
> >
>
> Ok, but is that better than this patch? Decreasing the size of the window by
> reducing the threshold still leaves a window. There is still a small amount
> of drift by summing up all the deltas but you get a much more accurate count
> at the point of time it was important to know.

In order to make that decision we would need to know what deltas make a
significant difference. Would be also important to know if there are any
other counters that have issues. If so then the reduction of the
thresholds is addressing these problems in a number of counters.

I have no objection against this approach here but it may just be bandaid
on a larger issue that could be approached in a cleaner way.

