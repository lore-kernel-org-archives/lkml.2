Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1CGIeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:34:18 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49890 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1CGIeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:34:17 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/8] Add __GFP_OTHER_NODE flag
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, aarcange@redhat.com
In-Reply-To: <1299182391-6061-7-git-send-email-andi@firstfloor.org>
References: <1299182391-6061-1-git-send-email-andi@firstfloor.org> <1299182391-6061-7-git-send-email-andi@firstfloor.org>
Message-Id: <20110307173042.8A04.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  7 Mar 2011 17:34:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a new __GFP_OTHER_NODE flag to tell the low level numa statistics
> in zone_statistics() that an allocation is on behalf of another thread.
> This way the local and remote counters can be still correct, even
> when background daemons like khugepaged are changing memory
> mappings.
> 
> This only affects the accounting, but I think it's worth doing that
> right to avoid confusing users.
> 
> I first tried to just pass down the right node, but this required
> a lot of changes to pass down this parameter and at least one
> addition of a 10th argument to a 9 argument function. Using
> the flag is a lot less intrusive.

Yes, less intrusive. But are you using current NUMA stastics on
practical system?
I didn't numa stat recent 5 years at all. So, I'm curious your usecase.
IOW, I haven't convinced this is worthful to consume new GFP_ flags bit.

_now_, I can say I don't found any bug in this patch.

> 
> Open: should be also used for migration?
> 
> Cc: aarcange@redhat.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/gfp.h    |    2 ++
>  include/linux/vmstat.h |    4 ++--
>  mm/page_alloc.c        |    2 +-
>  mm/vmstat.c            |    9 +++++++--
>  4 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 814d50e..a064724 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -35,6 +35,7 @@ struct vm_area_struct;
>  #define ___GFP_NOTRACK		0
>  #endif
>  #define ___GFP_NO_KSWAPD	0x400000u
> +#define ___GFP_OTHER_NODE	0x800000u



