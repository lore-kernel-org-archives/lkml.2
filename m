Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab2DIHzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:55:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41502 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab2DIHzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:55:12 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F829575.4020704@jp.fujitsu.com>
Date: Mon, 09 Apr 2012 16:53:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, tim.c.chen@linux.intel.com,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>,
        aarcange@redhat.com
Subject: Re: [PATCH 2/2] huge-memory: Use fast mm counters for transparent
 huge pages
References: <1333202997-19550-1-git-send-email-andi@firstfloor.org> <1333202997-19550-3-git-send-email-andi@firstfloor.org>
In-Reply-To: <1333202997-19550-3-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/31 23:09), Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> We found that the mm struct anon page counter cache line is much hotter
> with transparent huge pages compared to small pages.
> 
> Small pages use a special fast counter mechanism in task_struct, but huge pages
> didn't.  The huge pages are larger than the normal 64 entry threshold for the
> fast counter, so it cannot be directly used. Use a new special counter for huge
> pages to handle them efficiently.
> 
> Any users just calculate the correct total.
> 
> The only special case is transferring the large page count to small pages
> when splitting. I put it somewhat arbitarily into the tricky split
> sequence. Some review on this part is appreciated.
> 
> [An alternative would be to not do that, but that could lead to
> negative counters. These should still give the correct result]
> 
> Contains a fix for a problem found by Andrea in review.
> 
> Cc: aarcange@redhat.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>


Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


