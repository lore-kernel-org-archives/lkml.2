Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab0DOIRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 04:17:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57286 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab0DOIRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 04:17:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Suleiman Souhlal <ssouhlal@freebsd.org>
Subject: Re: [PATCH 1/4] vmscan: delegate pageout io to flusher thread if current is kswapd
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Chinner <david@fromorbit.com>,
       Mel Gorman <mel@csn.ul.ie>, Chris Mason <chris.mason@oracle.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, suleiman@google.com
In-Reply-To: <64BE60A8-EEF9-4AC6-AF0A-0ED3CB544726@freebsd.org>
References: <20100415131106.D174.A69D9226@jp.fujitsu.com> <64BE60A8-EEF9-4AC6-AF0A-0ED3CB544726@freebsd.org>
Message-Id: <20100415171142.D192.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 17:17:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Apr 14, 2010, at 9:11 PM, KOSAKI Motohiro wrote:
> 
> > Now, vmscan pageout() is one of IO throuput degression source.
> > Some IO workload makes very much order-0 allocation and reclaim
> > and pageout's 4K IOs are making annoying lots seeks.
> >
> > At least, kswapd can avoid such pageout() because kswapd don't
> > need to consider OOM-Killer situation. that's no risk.
> >
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> What's your opinion on trying to cluster the writes done by pageout,  
> instead of not doing any paging out in kswapd?
> Something along these lines:

Interesting. 
So, I'd like to review your patch carefully. can you please give me one
day? :)


> 
>      Cluster writes to disk due to memory pressure.
> 
>      Write out logically adjacent pages to the one we're paging out
>      so that we may get better IOs in these situations:
>      These pages are likely to be contiguous on disk to the one we're
>      writing out, so they should get merged into a single disk IO.
> 
>      Signed-off-by: Suleiman Souhlal <suleiman@google.com>




