Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab1CJOIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:08:46 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57599 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab1CJOIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:08:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in all_unreclaimable()
Cc: kosaki.motohiro@jp.fujitsu.com, avagin@gmail.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Andrey Vagin <avagin@openvz.org>,
        Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110309145457.0400.A69D9226@jp.fujitsu.com>
References: <4D767D43.5020802@gmail.com> <20110309145457.0400.A69D9226@jp.fujitsu.com>
Message-Id: <20110310224939.F926.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 10 Mar 2011 23:08:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi, 
> 
> Hmmm...
> If I could observed your patch, I did support your opinion. but I didn't. so, now I'm 
> curious why we got the different conclusion. tommorow, I'll try to construct a test 
> environment to reproduce your system.

Hm, 

following two patches seems to have bad interaction. former makes
SCHED_FIFO when OOM, latter makes CPU 100% occupied busy loop if
LRU is really tight.
Of cource, I need to run more much test. I'll digg it more at this 
weekend (maybe).


commit 93b43fa55088fe977503a156d1097cc2055449a2
Author: Luis Claudio R. Goncalves <lclaudio@uudg.org>
Date:   Mon Aug 9 17:19:41 2010 -0700

    oom: give the dying task a higher priority


commit 0e093d99763eb4cea09f8ca4f1d01f34e121d10b
Author: Mel Gorman <mel@csn.ul.ie>
Date:   Tue Oct 26 14:21:45 2010 -0700

    writeback: do not sleep on the congestion queue if there are no congested BDIs or if significant conge



