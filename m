Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab1HIAGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 20:06:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40532 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab1HIAGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 20:06:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 9 Aug 2011 08:58:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] vmscan: activate executable pages after first usage
Message-Id: <20110809085853.16cedb1b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110808110659.31053.92935.stgit@localhost6>
References: <20110808110658.31053.55013.stgit@localhost6>
	<20110808110659.31053.92935.stgit@localhost6>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Aug 2011 15:07:00 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> Logic added in commit v2.6.30-5507-g8cab475
> (vmscan: make mapped executable pages the first class citizen)
> was noticeably weakened in commit v2.6.33-5448-g6457474
> (vmscan: detect mapped file pages used only once)
> 
> Currently these pages can become "first class citizens" only after second usage.
> 
> After this patch page_check_references() will activate they after first usage,
> and executable code gets yet better chance to stay in memory.
> 
> TODO:
> run some cool tests like in v2.6.30-5507-g8cab475 =)
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>

How effective does this work on your test ?



> ---
>  mm/vmscan.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3cd766d..29b3612 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -727,6 +727,12 @@ static enum page_references page_check_references(struct page *page,
>  		if (referenced_page || referenced_ptes > 1)
>  			return PAGEREF_ACTIVATE;
>  
> +		/*
> +		 * Activate file-backed executable pages after first usage.
> +		 */
> +		if (vm_flags & VM_EXEC)
> +			return PAGEREF_ACTIVATE;
> +
>  		return PAGEREF_KEEP;
>  	}
>  
> 
> 

