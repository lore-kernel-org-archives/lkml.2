Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab1BCXuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 18:50:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44485 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab1BCXuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 18:50:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Feb 2011 08:44:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, nishimura@mxp.nes.nec.co.jp,
        balbir@linux.vnet.ibm.com, minchan.kim@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] memcg: simplify the way memory limits are checked
Message-Id: <20110204084433.c479a0af.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110203125611.GC2286@cmpxchg.org>
References: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
	<1296482635-13421-3-git-send-email-hannes@cmpxchg.org>
	<20110131144131.6733aa3a.akpm@linux-foundation.org>
	<20110201000455.GB19534@cmpxchg.org>
	<20110131162448.e791f0ae.akpm@linux-foundation.org>
	<20110203125357.GA2286@cmpxchg.org>
	<20110203125611.GC2286@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011 13:56:11 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> Since transparent huge pages, checking whether memory cgroups are
> below their limits is no longer enough, but the actual amount of
> chargeable space is important.
> 
> To not have more than one limit-checking interface, replace
> memory_cgroup_check_under_limit() and memory_cgroup_check_margin()
> with a single memory_cgroup_margin() that returns the chargeable space
> and leaves the comparison to the callsite.
> 
> Soft limits are now checked the other way round, by using the already
> existing function that returns the amount by which soft limits are
> exceeded: res_counter_soft_limit_excess().
> 
> Also remove all the corresponding functions on the res_counter side
> that are now no longer used.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

