Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0LJCi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 21:38:26 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:38159 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab0LJCiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 21:38:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VTdaUnkBmH+C+Jw0TwBXfqWQDjNRIUnirBihvNc2lEaqgOyqrK3L6SNM9SxMr83ljP
         bw96QQIF5HFA+K3WXltSbDdCDyXckt12YeYcFUVeIVfIYid8ZO8NBZPbpaMUDjKo7W0D
         kM+go3Pu39YS+C4kWAbnP5HiDXyrnoynhgcCc=
MIME-Version: 1.0
In-Reply-To: <1291893500-12342-7-git-send-email-mel@csn.ul.ie>
References: <1291893500-12342-1-git-send-email-mel@csn.ul.ie>
	<1291893500-12342-7-git-send-email-mel@csn.ul.ie>
Date: Fri, 10 Dec 2010 11:38:23 +0900
Message-ID: <AANLkTi=4sGZjUqWm4RKs6mgQVma26FeAGUK2zOPVL2oV@mail.gmail.com>
Subject: Re: [PATCH 6/6] mm: kswapd: Use the classzone idx that kswapd was
 using for sleeping_prematurely()
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 8:18 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> When kswapd is woken up for a high-order allocation, it takes account of
> the highest usable zone by the caller (the classzone idx). During
> allocation, this index is used to select the lowmem_reserve[] that
> should be applied to the watermark calculation in zone_watermark_ok().
>
> When balancing a node, kswapd considers the highest unbalanced zone to be the
> classzone index. This will always be at least be the callers classzone_idx
> and can be higher. However, sleeping_prematurely() always considers the
> lowest zone (e.g. ZONE_DMA) to be the classzone index. This means that
> sleeping_prematurely() can consider a zone to be balanced that is unusable
> by the allocation request that originally woke kswapd. This patch changes
> sleeping_prematurely() to use a classzone_idx matching the value it used
> in balance_pgdat().
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Nice catch! and it does make sense to me.

-- 
Kind regards,
Minchan Kim
