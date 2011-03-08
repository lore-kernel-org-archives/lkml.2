Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab1CHDGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 22:06:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59221 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab1CHDGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 22:06:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in all_unreclaimable()
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Andrew Vagin <avagin@gmail.com>,
        Andrey Vagin <avagin@openvz.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110308094438.1ba05ed2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110307135831.9e0d7eaa.akpm@linux-foundation.org> <20110308094438.1ba05ed2.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20110308120615.7EB9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Mar 2011 12:06:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Hmm.. Although it solves the problem, I think it's not a good idea that
> > > depends on false alram and give up the retry.
> > 
> > Any alternative proposals?  We should get the livelock fixed if possible..
> 
> I agree with Minchan and can't think this is a real fix....
> Andrey, I'm now trying your fix and it seems your fix for oom-killer,
> 'skip-zombie-process' works enough good for my environ.
> 
> What is your enviroment ? number of cpus ? architecture ? size of memory ?

me too. 'skip-zombie-process V1' work fine. and I didn't seen this patch
improve oom situation.

And, The test program is purely fork bomb. Our oom-killer is not silver
bullet for fork bomb from very long time ago. That said, oom-killer send 
SIGKILL and start to kill the victim process. But, it doesn't prevent 
to be created new memory hogging tasks. Therefore we have no gurantee 
to win process exiting and creating race.

*IF* we really need to care fork bomb issue, we need to write completely 
new VM feature.


