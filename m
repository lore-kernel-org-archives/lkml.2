Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0KIGUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 01:20:41 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60923 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab0KIGUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 01:20:40 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 55 of 66] select CONFIG_COMPACTION if TRANSPARENT_HUGEPAGE enabled
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
In-Reply-To: <89a62752012298bb500c.1288798110@v2.random>
References: <patchbomb.1288798055@v2.random> <89a62752012298bb500c.1288798110@v2.random>
Message-Id: <20101109151756.BC7B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 15:20:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> With transparent hugepage support we need compaction for the "defrag" sysfs
> controls to be effective.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -305,6 +305,7 @@ config NOMMU_INITIAL_TRIM_EXCESS
>  config TRANSPARENT_HUGEPAGE
>  	bool "Transparent Hugepage Support"
>  	depends on X86 && MMU
> +	select COMPACTION
>  	help
>  	  Transparent Hugepages allows the kernel to use huge pages and
>  	  huge tlb transparently to the applications whenever possible.

I dislike this. THP and compaction are completely orthogonal. I think 
you are talking only your performance recommendation. I mean I dislike
Kconfig 'select' hell and I hope every developers try to avoid it as 
far as possible.

Thanks.



