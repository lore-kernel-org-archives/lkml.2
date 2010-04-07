Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab0DGPm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 11:42:27 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40677 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932662Ab0DGPm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 11:42:26 -0400
Date: Wed, 7 Apr 2010 16:42:06 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 10/14] Add /sys trigger for per-node memory compaction
Message-ID: <20100407154206.GS17882@csn.ul.ie>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie> <1270224168-14775-11-git-send-email-mel@csn.ul.ie> <20100406170559.52093bd5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100406170559.52093bd5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 05:05:59PM -0700, Andrew Morton wrote:
> On Fri,  2 Apr 2010 17:02:44 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > This patch adds a per-node sysfs file called compact. When the file is
> > written to, each zone in that node is compacted. The intention that this
> > would be used by something like a job scheduler in a batch system before
> > a job starts so that the job can allocate the maximum number of
> > hugepages without significant start-up cost.
> 
> Would it make more sense if this was a per-memcg thing rather than a
> per-node thing?
> 

Kamezawa Hiroyuki covered this perfectly. memcg doesn't care and while
cpuset might, there are a lot more people working with nodes than there
are with cpuset.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
