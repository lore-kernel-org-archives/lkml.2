Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1GHMwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 08:52:42 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38541 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1GHMwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 08:52:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110708093542.GA4812@n2100.arm.linux.org.uk>
References: <20110707143019.GA16819@heechul-desktop>
	<20110708093542.GA4812@n2100.arm.linux.org.uk>
Date: Fri, 8 Jul 2011 05:52:41 -0700
X-Google-Sender-Auth: JgEQk_HRgOPQ5npHpe-P6Hmwu-w
Message-ID: <CAN_5kQDu6UTEiU2QY05mQxQ31mQp=dXz+-ubDdu9EG3UJVA+xw@mail.gmail.com>
Subject: Re: [PATCHv2] remove unnecessary cache flush on v6 copypage
From: heechul Yun <heechul@illinois.edu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        saeed.bishara@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just resubmitted the patch to the patch system (6995/2).

Thank you for your patience.

On Fri, Jul 8, 2011 at 2:35 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Jul 07, 2011 at 09:30:19AM -0500, Heechul Yun wrote:
>>
>> ARM: mm: remove unnecessary cache flush on v6 copypage
>>
>> Originally introduced to maintain coherency between icache and dcache
>> in v6 nonaliasing mode. This is now handled by __sync_icache_dcache since
>> c0177800, therefore unneceary in this function.
>>
>> Signed-off-by: Heechul Yun <heechul@illinois.edu>
>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>> --
>> arch/arm/mm/copypage-v6.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mm/copypage-v6.c b/arch/arm/mm/copypage-v6.c
>> index bdba6c6..63cca00 100644
>> --- a/arch/arm/mm/copypage-v6.c
>> +++ b/arch/arm/mm/copypage-v6.c
>> @@ -41,7 +41,6 @@ static void v6_copy_user_highpage_nonaliasing(struct page *to,
>>       kfrom = kmap_atomic(from, KM_USER0);
>>       kto = kmap_atomic(to, KM_USER1);
>>       copy_page(kto, kfrom);
>> -     __cpuc_flush_dcache_area(kto, PAGE_SIZE);
>>       kunmap_atomic(kto, KM_USER1);
>>       kunmap_atomic(kfrom, KM_USER0);
>>  }
>
> The above patch is fine (it has tabs preserved) but the version in the
> patch system has spaces instead (each space character has been replaced
> with a '.') and so doesn't apply:
>
> $ pdb getpatch 6995/1 |tr ' ' '.'
> Patch:.6995/1:.mm:.remove.unnecessary.cache.flush.on.v6.copypage
> From:.Heechul.Yun
> -------------------------------------------------------------------------------
> .arch/arm/mm/copypage-v6.c.|....1.-
> .1.file.changed,.1.deletion(-)
> -------------------------------------------------------------------------------
> diff.--git.a/arch/arm/mm/copypage-v6.c.b/arch/arm/mm/copypage-v6.c
> index.bdba6c6..63cca00.100644
> ---.a/arch/arm/mm/copypage-v6.c
> +++.b/arch/arm/mm/copypage-v6.c
> @@.-41,7.+41,6.@@.static.void.v6_copy_user_highpage_nonaliasing(struct.page.*to,........kfrom.=.kmap_atomic(from,.KM_USER0);
> ........kto.=.kmap_atomic(to,.KM_USER1);
> ........copy_page(kto,.kfrom);
> -.......__cpuc_flush_dcache_area(kto,.PAGE_SIZE);
> ........kunmap_atomic(kto,.KM_USER1);
> ........kunmap_atomic(kfrom,.KM_USER0);
> .}
>
>
