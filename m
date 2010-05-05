Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760531Ab0EEPdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 11:33:11 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47668 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760281Ab0EEPdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 11:33:09 -0400
Date: Wed, 5 May 2010 16:32:49 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] fix count_vm_event preempt in memory compaction direct
	reclaim
Message-ID: <20100505153249.GR20979@csn.ul.ie>
References: <1271797276-31358-1-git-send-email-mel@csn.ul.ie> <1271797276-31358-13-git-send-email-mel@csn.ul.ie> <20100505121908.GA5835@random.random> <20100505125156.GM20979@csn.ul.ie> <20100505131112.GB5835@random.random> <20100505135537.GO20979@csn.ul.ie> <20100505144813.GI5835@random.random> <20100505151439.GQ20979@csn.ul.ie> <20100505152531.GK5835@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100505152531.GK5835@random.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 05:25:31PM +0200, Andrea Arcangeli wrote:
> On Wed, May 05, 2010 at 04:14:39PM +0100, Mel Gorman wrote:
> > How about the following as an alternative to dropp migrate_prep?
> 
> Yep this is what I'd like too... btw in the comments you also mention
> IPI but I guess that's ok.

It was an oversight. I've corrected it now.

> About the cost I'm not sure but I would
> expect the cost of this to be even higher because it also has to run
> the scheduler unlike a real IPI.
> 

Fair point. I wouldn't be too sure what the relative costs are but either
way it's bad and unnecessary in the case of compaction.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
