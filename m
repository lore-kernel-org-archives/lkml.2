Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2FNCWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:22:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51914 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2FNCWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:22:34 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD94A6E.3050906@jp.fujitsu.com>
Date: Thu, 14 Jun 2012 11:20:30 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH v2 1/2][BUGFIX] mm: do not use page_count without a page
 pin
References: <1339636334-9238-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1339636334-9238-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/14 10:12), Minchan Kim wrote:
> d179e84ba fixed the problem[1] in vmscan.c but same problem is here.
> Let's fix it.
> 
> [1] http://comments.gmane.org/gmane.linux.kernel.mm/65844
> 
> I copy and paste d179e84ba's contents for description.
> 
> "It is unsafe to run page_count during the physical pfn scan because
> compound_head could trip on a dangling pointer when reading
> page->first_page if the compound page is being freed by another CPU."
> 
> * changelog from v1
>    - Add comment about skip tail page of THP - Andrea
>    - fix typo - Wanpeng Li
>    - based on next-20120613
> 
> Cc: Andrea Arcangeli<aarcange@redhat.com>
> Cc: Mel Gorman<mgorman@suse.de>
> Cc: Michal Hocko<mhocko@suse.cz>
> Cc: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Wanpeng Li<liwp.linux@gmail.com>
> Signed-off-by: Minchan Kim<minchan@kernel.org>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

