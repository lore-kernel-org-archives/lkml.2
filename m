Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab0DOL0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 07:26:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34035 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab0DOL0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 07:26:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/4] vmscan: delegate pageout io to flusher thread if current is kswapd
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100415103109.GC10966@csn.ul.ie>
References: <20100415131106.D174.A69D9226@jp.fujitsu.com> <20100415103109.GC10966@csn.ul.ie>
Message-Id: <20100415195227.D1B0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 20:26:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 15, 2010 at 01:11:37PM +0900, KOSAKI Motohiro wrote:
> > Now, vmscan pageout() is one of IO throuput degression source.
> > Some IO workload makes very much order-0 allocation and reclaim
> > and pageout's 4K IOs are making annoying lots seeks.
> > 
> > At least, kswapd can avoid such pageout() because kswapd don't
> > need to consider OOM-Killer situation. that's no risk.
> > 
> 
> Well, there is some risk here. Direct reclaimers may not be cleaning
> more pages than it had to previously except it splices subsystems
> together increasing stack usage and causing further problems.
> 
> It might not cause OOM-killer issues but it could increase the time
> dirty pages spend on the LRU.
> 
> Am I missing something?

No. you are right. I fully agree your previous mail. so, I need to cool down a bit ;)







