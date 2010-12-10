Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab0LJBXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 20:23:47 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45528 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246Ab0LJBXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 20:23:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 10 Dec 2010 10:18:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] mm: kswapd: Use the order that kswapd was
 reclaiming at for sleeping_prematurely()
Message-Id: <20101210101802.81b04765.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1291893500-12342-4-git-send-email-mel@csn.ul.ie>
References: <1291893500-12342-1-git-send-email-mel@csn.ul.ie>
	<1291893500-12342-4-git-send-email-mel@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Dec 2010 11:18:17 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> Before kswapd goes to sleep, it uses sleeping_prematurely() to check if
> there was a race pushing a zone below its watermark. If the race
> happened, it stays awake. However, balance_pgdat() can decide to reclaim
> at a lower order if it decides that high-order reclaim is not working as
> expected. This information is not passed back to sleeping_prematurely().
> The impact is that kswapd remains awake reclaiming pages long after it
> should have gone to sleep. This patch passes the adjusted order to
> sleeping_prematurely and uses the same logic as balance_pgdat to decide
> if it's ok to go to sleep.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

