Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab1EaHOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:14:49 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38020 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab1EaHOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:14:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE4955E.5010503@jp.fujitsu.com>
Date: Tue, 31 May 2011 16:14:38 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: mel@csn.ul.ie
CC: akpm@linux-foundation.org, urykhy@gmail.com, aarcange@redhat.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [PATCH] mm: compaction: Abort compaction if too many pages are
 isolated and caller is asynchronous
References: <20110530131300.GQ5044@csn.ul.ie>
In-Reply-To: <20110530131300.GQ5044@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/30 22:13), Mel Gorman wrote:
> Asynchronous compaction is used when promoting to huge pages. This is
> all very nice but if there are a number of processes in compacting
> memory, a large number of pages can be isolated. An "asynchronous"
> process can stall for long periods of time as a result with a user
> reporting that firefox can stall for 10s of seconds. This patch aborts
> asynchronous compaction if too many pages are isolated as it's better to
> fail a hugepage promotion than stall a process.
> 
> If accepted, this should also be considered for 2.6.39-stable. It should
> also be considered for 2.6.38-stable but ideally [11bc82d6: mm:
> compaction: Use async migration for __GFP_NO_KSWAPD and enforce no
> writeback] would be applied to 2.6.38 before consideration.
> 
> Reported-and-Tested-by: Ury Stankevich <urykhy@gmail.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



