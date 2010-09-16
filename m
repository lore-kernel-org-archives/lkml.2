Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab0IPH76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:59:58 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36351 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab0IPH75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HrdaUazCU+TSJeWT6HLpxPBkDZ4UeRmPbrY10usVN4h+HvqhtvEO3F0GGLcLCeiRch
         k1kpwowqXg5kbh2EvZadVMM2v3vC7vwrDuy6QYF9W/6Tn0LL1e7iDoEJMC1Hs61KfzVN
         5e0f5KINT8Xl+pu6h9Zg1OVZAO/F0ZVO85ruk=
Date: Thu, 16 Sep 2010 16:59:49 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 7/8] writeback: Do not sleep on the congestion queue if
 there are no congested BDIs
Message-ID: <20100916075949.GA16115@barrios-desktop>
References: <1284553671-31574-1-git-send-email-mel@csn.ul.ie>
 <1284553671-31574-8-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284553671-31574-8-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 01:27:50PM +0100, Mel Gorman wrote:
> If congestion_wait() is called with no BDI congested, the caller will sleep
> for the full timeout and this may be an unnecessary sleep. This patch adds
> a wait_iff_congested() that checks congestion and only sleeps if a BDI is
> congested else, it calls cond_resched() to ensure the caller is not hogging
> the CPU longer than its quota but otherwise will not sleep.
> 
> This is aimed at reducing some of the major desktop stalls reported during
> IO. For example, while kswapd is operating, it calls congestion_wait()
> but it could just have been reclaiming clean page cache pages with no
> congestion. Without this patch, it would sleep for a full timeout but after
> this patch, it'll just call schedule() if it has been on the CPU too long.
> Similar logic applies to direct reclaimers that are not making enough
> progress.

I confused due to kswapd you mentioned.
This patch affects only direct reclaim.
Please, complete the description. 

"This patch affects direct reclaimer to reduce stall"
Otherwise, looks good to me. 

> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
