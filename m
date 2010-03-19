Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab0CSGbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 02:31:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40110 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab0CSGb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 02:31:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 10/11] Direct compact when a high-order allocation fails
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100319152105.8772.A69D9226@jp.fujitsu.com>
References: <1268412087-13536-11-git-send-email-mel@csn.ul.ie> <20100319152105.8772.A69D9226@jp.fujitsu.com>
Message-Id: <20100319152516.8778.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 19 Mar 2010 15:31:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Viewpoint 1. Unnecessary IO
> 
> isolate_pages() for lumpy reclaim frequently grab very young page. it is often
> still dirty. then, pageout() is called much.
> 
> Unfortunately, page size grained io is _very_ inefficient. it can makes lots disk
> seek and kill disk io bandwidth.
> 
> 
> Viewpoint 2. Unevictable pages 
> 
> isolate_pages() for lumpy reclaim can pick up unevictable page. it is obviously
> undroppable. so if the zone have plenty mlocked pages (it is not rare case on
> server use case), lumpy reclaim can become very useless.
> 
> 
> Viewpoint 3. GFP_ATOMIC allocation failure
> 
> Obviously lumpy reclaim can't help GFP_ATOMIC issue.
> 
> 
> Viewpoint 4. reclaim latency
> 
> reclaim latency directly affect page allocation latency. so if lumpy reclaim with
> much pageout io is slow (often it is), it affect page allocation latency and can
> reduce end user experience.

Viewpoint 5. end user surprising

lumpy reclaim can makes swap-out even though the system have lots free
memory. end users very surprised it and they can think it is bug.

Also, this swap activity easyly confuse that an administrator decide when
install more memory into the system.



