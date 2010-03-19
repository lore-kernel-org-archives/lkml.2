Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab0CSGV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 02:21:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35396 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab0CSGV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 02:21:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 07/11] Memory compaction core
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100318114302.GM12388@csn.ul.ie>
References: <20100318085741.8729.A69D9226@jp.fujitsu.com> <20100318114302.GM12388@csn.ul.ie>
Message-Id: <20100319152102.876C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 19 Mar 2010 15:21:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > V1 did compaction per pageblock. but current patch doesn't.
> > > > so, Is COMPACTBLOCKS still good name?
> > > 
> > > It's not such a minor nit. I wondered about that myself but it's still a
> > > block - just not a pageblock. Would COMPACTCLUSTER be a better name as it's
> > > related to COMPACT_CLUSTER_MAX?
> > 
> > I've looked at this code again. honestly I'm a abit confusing even though both your
> > suggestions seems reasonable.  
> > 
> > now COMPACTBLOCKS is tracking #-of-called-migrate_pages. but I can't imazine
> > how to use it. can you please explain this ststics purpose? probably this is only useful
> > when conbination other stats, and the name should be consist with such combination one.
> > 
> 
> It is intended to count how many steps compaction took, the fewer the
> better so minimally, the lower this number is the better. Specifically, the
> "goodness" is related to the number of pages that were successfully allocated
> due to compaction. Assuming the only high-order allocation was huge pages,
> one possible calculation for "goodness" is;
> 
> hugepage_clusters = (1 << HUGE HUGETLB_PAGE_ORDER) / COMPACT_CLUSTER_MAX
> goodness = (compactclusters / hugepage_clusters) / compactsuccess
> 
> The value of goodness is undefined if "compactsuccess" is 0.
> 
> Otherwise, the closer the "goodness" is to 1, the better. A value of 1
> implies that compaction is selecting exactly the right blocks for migration
> and the minimum number of pages are being moved around. The greater the value,
> the more "useless" work compaction is doing.
> 
> If there are a mix of high-orders that are resulting in compaction, calculating
> the goodness is a lot harder and compactcluster is just a rule of thumb as
> to how much work compaction is doing.
> 
> Does that make sense?

Sure! then, now I fully agree with COMPACTCLUSTER.

Thanks.


