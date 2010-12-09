Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0LIP7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:59:36 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35800 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0LIP7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:59:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r6gSRq5Hl07YabACy1wz2TwrlR6AGYUsjGMDD9C4ewvNXJHZPNZEWXmN7obSk8DB2g
         Iq7b5PJSdIBmep3nqLTT6ifhlQZIXLb056XT/G/kdd/f7VfTIophQWTxMGEIzHMO3AlB
         6wN3WVoBV/TC7bJwCZ50vRPKjV3OvV8OuXeG0=
Date: Fri, 10 Dec 2010 00:59:25 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Simon Kirby <sim@hostway.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Shaohua Li <shaohua.li@intel.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] mm: kswapd: Reset kswapd_max_order and
 classzone_idx after reading
Message-ID: <20101209155925.GD1740@barrios-desktop>
References: <1291893500-12342-1-git-send-email-mel@csn.ul.ie>
 <1291893500-12342-5-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291893500-12342-5-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 11:18:18AM +0000, Mel Gorman wrote:
> When kswapd wakes up, it reads its order and classzone from pgdat and
> calls balance_pgdat. While its awake, it potentially reclaimes at a high
> order and a low classzone index. This might have been a once-off that
> was not required by subsequent callers. However, because the pgdat
> values were not reset, they remain artifically high while
> balance_pgdat() is running and potentially kswapd enters a second
> unnecessary reclaim cycle. Reset the pgdat order and classzone index
> after reading.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
