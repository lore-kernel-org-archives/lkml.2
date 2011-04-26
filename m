Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab1DZKS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:18:58 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55857 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1DZKS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U0fYjeH2zW8FqxufLes25uqZfTCCUecXmpoyPmE2HqYbick0OGDJTtJFJTZTEIvic/
         tfNaCOtaTLLEq7dxpzsCC3W+3JFKZYLp06yxQI69HmHz1xjfb7OzbCnvaPunSsd+MliW
         85XhKkXGHZsm7lM3xqluBbcVVQ2qqlsXXKOvY=
MIME-Version: 1.0
In-Reply-To: <BANLkTiknvQ-dmOB4vEfYeC-wmFJL3A0ekA@mail.gmail.com>
References: <BANLkTin8mE=DLWma=U+CdJaQW03X2M2W1w@mail.gmail.com>
	<20110426055521.GA18473@localhost>
	<BANLkTik8k9A8N8CPk+eXo9c_syxJFRyFCA@mail.gmail.com>
	<BANLkTim0MNgqeh1KTfvpVFuAvebKyQV8Hg@mail.gmail.com>
	<20110426062535.GB19717@localhost>
	<BANLkTinM9DjK9QsGtN0Sh308rr+86UMF0A@mail.gmail.com>
	<20110426063421.GC19717@localhost>
	<BANLkTi=xDozFNBXNdGDLK6EwWrfHyBifQw@mail.gmail.com>
	<20110426092029.GA27053@localhost>
	<BANLkTiknvQ-dmOB4vEfYeC-wmFJL3A0ekA@mail.gmail.com>
Date: Tue, 26 Apr 2011 13:18:55 +0300
X-Google-Sender-Auth: KJDNFwho_KJqJLgavDmtcNXarec
Message-ID: <BANLkTikR0nsGaXgLvGQ_a01JeK0LgLxT_Q@mail.gmail.com>
Subject: Re: readahead and oom
From: Pekka Enberg <penberg@kernel.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 12:28 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Tue, Apr 26, 2011 at 6:20 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
>> Minchan,
>>
>>> > +static inline struct page *page_cache_alloc_cold_noretry(struct address_space *x)
>>> > +{
>>> > +       return __page_cache_alloc(mapping_gfp_mask(x)|__GFP_COLD|__GFP_NORETRY);
>>>
>>> It makes sense to me but it could make a noise about page allocation
>>> failure. I think it's not desirable.
>>> How about adding __GFP_NOWARAN?
>>
>> Yeah it makes sense. Here is the new version.
>>
>> Thanks,
>> Fengguang
>> ---
>> Subject: readahead: readahead page allocations is OK to fail
>> Date: Tue Apr 26 14:29:40 CST 2011
>>
>> Pass __GFP_NORETRY|__GFP_NOWARN for readahead page allocations.
>>
>> readahead page allocations are completely optional. They are OK to
>> fail and in particular shall not trigger OOM on themselves.
>>
>> Reported-by: Dave Young <hidave.darkstar@gmail.com>
>> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
