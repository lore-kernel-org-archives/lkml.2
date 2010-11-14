Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab0KNFpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 00:45:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50313 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab0KNFpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 00:45:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 2/3] mm,compaction: Add COMPACTION_BUILD
Cc: kosaki.motohiro@jp.fujitsu.com, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <1289502424-12661-3-git-send-email-mel@csn.ul.ie>
References: <1289502424-12661-1-git-send-email-mel@csn.ul.ie> <1289502424-12661-3-git-send-email-mel@csn.ul.ie>
Message-Id: <20101114144413.E022.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 14 Nov 2010 14:45:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To avoid #ifdef COMPACTION in a following patch, this patch adds
> COMPACTION_BUILD that is similar to NUMA_BUILD in operation.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  include/linux/kernel.h |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 450092c..c00c5d1 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -826,6 +826,13 @@ struct sysinfo {
>  #define NUMA_BUILD 0
>  #endif
>  
> +/* This helps us avoid #ifdef CONFIG_COMPACTION */
> +#ifdef CONFIG_COMPACTION
> +#define COMPACTION_BUILD 1
> +#else
> +#define COMPACTION_BUILD 0
> +#endif
> +

Looks good, of cource. but I think this patch can be fold [3/3] beucase 
it doesn't have any change.



