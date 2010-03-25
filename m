Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0CYJyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:54:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57863 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab0CYJyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:54:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 25 Mar 2010 18:50:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 10/11] Direct compact when a high-order allocation fails
Message-Id: <20100325185021.63e16884.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100325094826.GM2024@csn.ul.ie>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	<1269347146-7461-11-git-send-email-mel@csn.ul.ie>
	<20100324101927.0d54f4ad.kamezawa.hiroyu@jp.fujitsu.com>
	<20100324114056.GE21147@csn.ul.ie>
	<20100325093006.cd0361e6.kamezawa.hiroyu@jp.fujitsu.com>
	<20100325094826.GM2024@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 09:48:26 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> > In that case, compact_finished() can't
> > find there is a free chunk and do more work.  How about using a function like
> > 	 free_pcppages_bulk(zone, pcp->batch, pcp);
> > to bypass pcp list and freeing pages at once ?
> > 
> 
> I think you mean to drain the PCP lists while compaction is happening
> but is it justified? It's potentially a lot of IPI calls just to check
> if compaction can finish a little earlier. If the pages on the PCP lists
> are making that much of a difference to high-order page availability, it
> implies that the zone is pretty full and it's likely that compaction was
> avoided and we direct reclaimed.
> 
Ah, sorry for my short word again. I mean draining "local" pcp list because
a thread which run direct-compaction freed pages. IPI is not necessary and
overkill.

Thanks,
-Kame

