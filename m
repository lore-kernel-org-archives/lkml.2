Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab2DXFS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 01:18:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60771 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2DXFS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 01:18:57 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F963742.2030607@jp.fujitsu.com>
Date: Tue, 24 Apr 2012 14:16:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] propagate gfp_t to page table alloc functions
References: <1335171318-4838-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1335171318-4838-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/23 17:55), Minchan Kim wrote:

> As I test some code, I found a problem about deadlock by lockdep.
> The reason I saw the message is __vmalloc calls map_vm_area which calls
> pud/pmd_alloc without gfp_t. so although we call __vmalloc with
> GFP_ATOMIC or GFP_NOIO, it ends up allocating pages with GFP_KERNEL.
> The should be a BUG. This patch fixes it by passing gfp_to to low page
> table allocate functions.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>


Hmm ? vmalloc should support GFP_ATOMIC ?

And, do we need to change all pud_,pgd_,pmd_,pte_alloc() for users pgtables ?

Thanks,
-Kame

