Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab1BDARI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 19:17:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36730 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab1BDARG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 19:17:06 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Feb 2011 09:10:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/5] memcg: condense page_cgroup-to-page lookup points
Message-Id: <20110204091058.2a733a1a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1296743166-9412-5-git-send-email-hannes@cmpxchg.org>
References: <1296743166-9412-1-git-send-email-hannes@cmpxchg.org>
	<1296743166-9412-5-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Feb 2011 15:26:05 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> The per-cgroup LRU lists string up 'struct page_cgroup's.  To get from
> those structures to the page they represent, a lookup is required.
> Currently, the lookup is done through a direct pointer in struct
> page_cgroup, so a lot of functions down the callchain do this lookup
> by themselves instead of receiving the page pointer from their
> callers.
> 
> The next patch removes this pointer, however, and the lookup is no
> longer that straight-forward.  In preparation for that, this patch
> only leaves the non-optional lookups when coming directly from the LRU
> list and passes the page down the stack.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Maybe good.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



