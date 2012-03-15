Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030603Ab2COOut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:50:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61663 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761634Ab2COOun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:50:43 -0400
Date: Thu, 15 Mar 2012 15:50:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Arun Sharma <asharma@fb.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
Message-ID: <20120315145033.GB550@somewhere.redhat.com>
References: <1331160079-13821-1-git-send-email-asharma@fb.com>
 <4F5DA91F.7060908@lge.com>
 <4F5E3E8C.1020005@fb.com>
 <4F5E554C.4060209@fb.com>
 <4F5EA49F.7020706@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5EA49F.7020706@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 10:36:31AM +0900, Namhyung Kim wrote:
> Hi,
> 
> 2012-03-13 4:58 AM, Arun Sharma wrote:
> >On 3/12/12 11:21 AM, Arun Sharma wrote:
> >>>BTW, I don't like the name 'inclusive' as a sort key. If it cares about
> >>>time, IMHO, the name should contain 'time' - something like 'itime' or
> >>>'inctime'?
> >>
> >>The existing sort orders: pid, comm, dso, symbol, parent -- all care
> >>about time, but none of them have time in their name?
> >
> >I'll take that back. What they sort on depends on the event.
> >
> >perf record -ge cache-misses
> >perf report -s inclusive
> >
> >will sort by the number of cache-misses and not time.
> >
> >-Arun
> 
> AFAIK, "sort" here means how perf identifies a sample event from
> others: "comm" will collect samples have same pid/comm, then "dso"
> will group samples belong to same library, and "symbol" will group
> again samples have same symbol name. This is what default sort order
> (comm,dso,symbol) does.

Right this is about how we group the events into histograms.
If you sort by dso, you'll have one histogram per dso and events
will be added to the histogram matching their dso.

Multiple sorting does the same with an "AND" between sort entries.
If you sort by dso,pid, you'll have one histogram per possible couple
of (dso,pid).

Say you have dso1, dso2 and pid1 and pid2, then you get 4 possible histograms:
(dso1,pid1), (dso1,pid2), (dso2,pid1), (dso2,pid2)
...assuming that over your events you have all these combinations.

So this is how we group samples into histograms.
