Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1DANVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:21:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42472 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1DANVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 09:21:31 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        akpm@linux-foundation.org, npiggin@kernel.dk, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cl@linux.com,
        kamezawa.hiroyu@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <20110401131214.GS2879@balbir.in.ibm.com>
References: <20110401165752.A889.A69D9226@jp.fujitsu.com> <20110401131214.GS2879@balbir.in.ibm.com>
Message-Id: <20110401222250.A894.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri,  1 Apr 2011 22:21:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2011-04-01 16:56:57]:
> 
> > Hi
> > 
> > > > 1) zone reclaim doesn't work if the system has multiple node and the
> > > >    workload is file cache oriented (eg file server, web server, mail server, et al). 
> > > >    because zone recliam make some much free pages than zone->pages_min and
> > > >    then new page cache request consume nearest node memory and then it
> > > >    bring next zone reclaim. Then, memory utilization is reduced and
> > > >    unnecessary LRU discard is increased dramatically.
> > > > 
> > > >    SGI folks added CPUSET specific solution in past. (cpuset.memory_spread_page)
> > > >    But global recliam still have its issue. zone recliam is HPC workload specific 
> > > >    feature and HPC folks has no motivation to don't use CPUSET.
> > > 
> > > I am afraid you misread the patches and the intent. The intent to
> > > explictly enable control of unmapped pages and has nothing
> > > specifically to do with multiple nodes at this point. The control is
> > > system wide and carefully enabled by the administrator.
> > 
> > Hm. OK, I may misread.
> > Can you please explain the reason why de-duplication feature need to selectable and
> > disabled by defaut. "explicity enable" mean this feature want to spot corner case issue??
> 
> Yes, because given a selection of choices (including what you
> mentioned in the review), it would be nice to have
> this selectable.

It's no good answer. :-/
Who need the feature and who shouldn't use it? It this enough valuable for enough large
people? That's my question point.



