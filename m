Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1DZJ24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:28:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37202 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab1DZJ2z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OLBPJcF1U7cACyrIomHSlLF0DS0tRk6lE5bizjd+3QchkJ6fETbzezed69a3t0OZjn
         4psoHwjdUbeWt71sgb2OG12HzGWxkaLUENUYj/2nEyWRtzc8SRs6v26JGjbanuEykUWc
         WNys1EFvR/siMdyZvXDwCEXrF3sdzEFOts6pU=
MIME-Version: 1.0
In-Reply-To: <20110426092029.GA27053@localhost>
References: <BANLkTin8mE=DLWma=U+CdJaQW03X2M2W1w@mail.gmail.com>
	<20110426055521.GA18473@localhost>
	<BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
	<BANLkTim0MNgqeh1KTfvpVFuAvebKyQV8Hg@mail.gmail.com>
	<20110426062535.GB19717@localhost>
	<BANLkTinM9DjK9QsGtN0Sh308rr+86UMF0A@mail.gmail.com>
	<20110426063421.GC19717@localhost>
	<BANLkTi=xDozFNBXNdGDLK6EwWrfHyBifQw@mail.gmail.com>
	<20110426092029.GA27053@localhost>
Date: Tue, 26 Apr 2011 18:28:53 +0900
Message-ID: <BANLkTiknvQ-dmOB4vEfYeC-wmFJL3A0ekA@mail.gmail.com>
Subject: Re: readahead and oom
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 6:20 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> Minchan,
>
>> > +static inline struct page *page_cache_alloc_cold_noretry(struct address_space *x)
>> > +{
>> > +       return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD|__GFP_NORETRY);
>>
>> It makes sense to me but it could make a noise about page allocation
>> failure. I think it's not desirable.
>> How about adding __GFP_NOWARAN?
>
> Yeah it makes sense. Here is the new version.
>
> Thanks,
> Fengguang
> ---
> Subject: readahead: readahead page allocations is OK to fail
> Date: Tue Apr 26 14:29:40 CST 2011
>
> Pass __GFP_NORETRY|__GFP_NOWARN for readahead page allocations.
>
> readahead page allocations are completely optional. They are OK to
> fail and in particular shall not trigger OOM on themselves.
>
> Reported-by: Dave Young <hidave.darkstar@gmail.com>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
