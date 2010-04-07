Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab0DGAfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 20:35:47 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60279 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab0DGAfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 20:35:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 7 Apr 2010 09:31:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 10/14] Add /sys trigger for per-node memory compaction
Message-Id: <20100407093148.d5d1c42f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100406170559.52093bd5.akpm@linux-foundation.org>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
	<1270224168-14775-11-git-send-email-mel@csn.ul.ie>
	<20100406170559.52093bd5.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Apr 2010 17:05:59 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

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

memcg doesn't have any relationship with placement of memory (now).
It's just controls the amount of memory.
So, memcg has no relationship with compaction.

A cgroup which controls placement of memory is cpuset.
One idea is per cpuset. But per-node seems ok.

Thanks,
-Kame

