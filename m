Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab0CXTzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:55:55 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:46802 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab0CXTzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:55:52 -0400
Date: Wed, 24 Mar 2010 14:54:32 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 11/11] Do not compact within a preferred zone after a
 compaction failure
In-Reply-To: <20100324103749.GB21147@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1003241453270.14329@router.home>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie> <1269347146-7461-12-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1003231327580.10178@router.home> <20100323183936.GF5870@csn.ul.ie> <alpine.DEB.2.00.1003231422290.10178@router.home>
 <20100324103749.GB21147@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010, Mel Gorman wrote:

> > > What I was thinking at the time was that compact_resume was stored in struct
> > > zone - i.e. that is where it is recorded.
> >
> > Ok adding a dozen or more words here may be useful.
> >
>
> In the event of compaction followed by an allocation failure, this patch
> defers further compaction in the zone for a period of time. The zone that
> is deferred is the first zone in the zonelist - i.e. the preferred zone.
> To defer compaction in the other zones, the information would need to
> be stored in the zonelist or implemented similar to the zonelist_cache.
> This would impact the fast-paths and is not justified at this time.
>
> ?

Ok.

> > There are frequent uses of HZ/10 as well especially in vmscna.c. A longer
> > time may be better? HZ/50 looks like an interval for writeout. But this
> > is related to reclaim?
> >
>
> HZ/10 is somewhat of an arbitrary choice as well and there isn't data on
> which is better and which is worse. If the zone is full of dirty data, then
> HZ/10 makes sense for IO. If it happened to be mainly clean cache but under
> heavy memory pressure, then reclaim would be a relatively fast event and a
> shorter wait makes sense of HZ/50.
>
> Thing is, if we start with a short timer and it's too short, COMPACTFAIL
> will be growing steadily. If we choose a long time and it's too long, there
> is no counter to indicate it was a bad choice. Hence, I'd prefer the short
> timer to start with and ideally resume compaction after some event in the
> future rather than depending on time.
>
> Does that make sense?

Yes.

