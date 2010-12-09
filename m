Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0LIQDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 11:03:04 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:58524 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0LIQDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 11:03:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AmOWgwF4HHjCSHTh5A0zsaY+U2SlGAAc5b0Dm9M2JtBV/5Du37mrNe6YaJe2BglBZs
         jtKzMUv8QRRZQuV1W8Lu/GpcCacFLuoQXwyZT9U9Wf1lLQaRb9L9PCDCZu1fAixRugIc
         Ls+YX69aWlQCx0oQWrsFch4iy4KYOznLRQaBk=
MIME-Version: 1.0
In-Reply-To: <20101209155925.GD1740@barrios-desktop>
References: <1291893500-12342-1-git-send-email-mel@csn.ul.ie>
	<1291893500-12342-5-git-send-email-mel@csn.ul.ie>
	<20101209155925.GD1740@barrios-desktop>
Date: Fri, 10 Dec 2010 01:03:01 +0900
Message-ID: <AANLkTimKVZjfVtZ_Rz0p0xKbE76Uoa1rDrYmN9EC4wLU@mail.gmail.com>
Subject: Re: [PATCH 4/6] mm: kswapd: Reset kswapd_max_order and classzone_idx
 after reading
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

On Fri, Dec 10, 2010 at 12:59 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Thu, Dec 09, 2010 at 11:18:18AM +0000, Mel Gorman wrote:
>> When kswapd wakes up, it reads its order and classzone from pgdat and
>> calls balance_pgdat. While its awake, it potentially reclaimes at a high
>> order and a low classzone index. This might have been a once-off that
>> was not required by subsequent callers. However, because the pgdat
>> values were not reset, they remain artifically high while
>> balance_pgdat() is running and potentially kswapd enters a second
>> unnecessary reclaim cycle. Reset the pgdat order and classzone index
>> after reading.
>>
>> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Nitpick.
Shouldn't this patch be merged with 1/6?

>
> --
> Kind regards,
> Minchan Kim
>



-- 
Kind regards,
Minchan Kim
