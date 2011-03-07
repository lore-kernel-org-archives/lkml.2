Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1CGI2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:28:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37881 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1CGI2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:28:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 8/8] Add VM counters for transparent hugepages
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1299182391-6061-9-git-send-email-andi@firstfloor.org>
References: <1299182391-6061-1-git-send-email-andi@firstfloor.org> <1299182391-6061-9-git-send-email-andi@firstfloor.org>
Message-Id: <20110307172609.8A01.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  7 Mar 2011 17:28:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen <ak@linux.intel.com>
> 
> I found it difficult to make sense of transparent huge pages without
> having any counters for its actions. Add some counters to vmstat
> for allocation of transparent hugepages and fallback to smaller
> pages.
> 
> Optional patch, but useful for development and understanding the system.
> 
> Contains improvements from Andrea Arcangeli and Johannes Weiner
> 
> Acked-by: Andrea Arcangeli <aarcange@redhat.com>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/vmstat.h |    7 +++++++
>  mm/huge_memory.c       |   25 +++++++++++++++++++++----
>  mm/vmstat.c            |    8 ++++++++
>  3 files changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 9b5c63d..074e8fd 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -58,6 +58,13 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>  		UNEVICTABLE_PGCLEARED,	/* on COW, page truncate */
>  		UNEVICTABLE_PGSTRANDED,	/* unable to isolate on unlock */
>  		UNEVICTABLE_MLOCKFREED,
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	        THP_FAULT_ALLOC,
> +		THP_FAULT_FALLBACK,
> +		THP_COLLAPSE_ALLOC,
> +		THP_COLLAPSE_ALLOC_FAILED,
> +		THP_SPLIT,
> +#endif
>  		NR_VM_EVENT_ITEMS
>  };

Hmm...
Don't we need to make per zone stastics? I'm afraid small dma zone 
makes much thp-splitting and screw up this stastics.

only nit.


