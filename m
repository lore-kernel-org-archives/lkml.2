Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab0GYWWr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 18:22:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49736 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab0GYWWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 18:22:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f8dQ9Dp/btzFPJP4TNLPxSLhEZn/zp4w6RN9vVQIl+li3cRoprbtkJz1uWwqATd24/
         /szwe6CMel3XcgJOTvzZdvS7dYMPdepOWMyby03fLH8i7f+9RJBCLdiv77cvr6o3hvGe
         EcZl1Vs58BGbysqS4UJKyf5tUCo0vbDRvCmZ4=
MIME-Version: 1.0
In-Reply-To: <AANLkTimtN9PuvwrB2PAUZMajWzg=TbEP1jeseVM3MST3@mail.gmail.com>
References: <1280066561-8543-1-git-send-email-minchan.kim@gmail.com>
	<AANLkTimtN9PuvwrB2PAUZMajWzg=TbEP1jeseVM3MST3@mail.gmail.com>
Date: Mon, 26 Jul 2010 07:22:45 +0900
Message-ID: <AANLkTi=Vy0dUSsLmqV8Hwd9TT_m+CAMaVUV+ATOVFJFg@mail.gmail.com>
Subject: Re: [PATCH] Tight check of pfn_valid on sparsemem - v3
From: Minchan Kim <minchan.kim@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 2:03 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> On Sun, Jul 25, 2010 at 7:32 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>> Changelog since v2
>>  o Change some function names
>>  o Remove mark_memmap_hole in memmap bring up
>>  o Change CONFIG_SPARSEMEM with CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
>>
>> I have a plan following as after this patch is acked.
>>
>> TODO:
>> 1) expand pfn_valid to FALTMEM in ARM
>> I think we can enhance pfn_valid of FLATMEM in ARM.
>> Now it is doing binary search and it's expesive.
>> First of all, After we merge this patch, I expand it to FALTMEM of ARM.
>>
>> 2) remove memmap_valid_within
>> We can remove memmap_valid_within by strict pfn_valid's tight check.
>>
>> 3) Optimize hole check in sparsemem
>> In case of spasemem, we can optimize pfn_valid through defining new flag
>> like SECTION_HAS_HOLE of hole mem_section.
>>
>
> Is there an assumption somewhere that assumes that page->private will
> always have MEMMAP_HOLE set when the pfn is invalid, independent of
> the context in which it is invoked? BTW, I'd also recommend moving

zzzzz.... I needed sleep.
Will fix and resend.

> over to using set_page_private() and page_private() wrappers (makes
> the code easier to search)

Okay.
Thanks for pointing me out, Balbir.

>
> Balbir
>



-- 
Kind regards,
Minchan Kim
