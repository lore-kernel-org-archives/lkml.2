Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761587Ab2FVHxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 03:53:20 -0400
Received: from outgoing.email.vodafone.de ([139.7.28.128]:43824 "EHLO
	outgoing.email.vodafone.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761574Ab2FVHxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 03:53:17 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jun 2012 03:53:16 EDT
X-Authentication-Info: Sender authenticated as deathsimple@vodafone.de (using CRAM-MD5)
Message-ID: <4FE42278.1070702@vodafone.de>
Date: Fri, 22 Jun 2012 09:44:56 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Huacai Chen <chenhuacai@gmail.com>
CC: Lucas Stach <dev@lynxeye.de>, linux-mips@linux-mips.org,
        Zhangjin Wu <wuzhangjin@gmail.com>, Hua Yan <yanh@lemote.com>,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        dri-devel@lists.freedesktop.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhc@lemote.com>, Hongliang Tao <taohl@lemote.com>
Subject: Re: [PATCH V3 11/16] drm/radeon: Make radeon card usable for Loongson.
References: <1340334073-17804-1-git-send-email-chenhc@lemote.com> <1340334073-17804-12-git-send-email-chenhc@lemote.com> <1340342704.1381.9.camel@tellur> <CAAhV-H5pkm6en7oVjTdDmm2SSy1DyF7kDczPady+c+aB8eAXyA@mail.gmail.com>
In-Reply-To: <CAAhV-H5pkm6en7oVjTdDmm2SSy1DyF7kDczPady+c+aB8eAXyA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Huacai,


On 22.06.2012 07:59, Huacai Chen wrote:
> On Fri, Jun 22, 2012 at 1:25 PM, Lucas Stach<dev@lynxeye.de>  wrote:
>> Hello Huacai,
>>
>> Am Freitag, den 22.06.2012, 11:01 +0800 schrieb Huacai Chen:
[SNIP]
>>> Signed-off-by: Huacai Chen<chenhc@lemote.com>
>>> Signed-off-by: Hongliang Tao<taohl@lemote.com>
>>> Signed-off-by: Hua Yan<yanh@lemote.com>
>>> Reviewed-by: Michel Dänzer<michel@daenzer.net>
>>> Reviewed-by: Alex Deucher<alexdeucher@gmail.com>
>>> Reviewed-by: Lucas Stach<dev@lynxeye.de>
>>> Reviewed-by: j.glisse<j.glisse@gmail.com>
>> You should probably only stick this tag on your patches after the people
>> you are naming explicitly gave their r-b for a specific version of a
>> patch.
Yes indeed, a "Reviewed-by" line usually means that the person giving 
you that line has read your code and has none or very few negative 
comments about it, e.g. something like "change this and that and then 
its "Reviewed-by: ....".

>>
>> Thanks,
>> Lucas
>>> Cc: dri-devel@lists.freedesktop.org
>>> ---
>>>   drivers/gpu/drm/drm_vm.c            |    2 +-
>>>   drivers/gpu/drm/radeon/radeon_ttm.c |    6 +++---
>>>   drivers/gpu/drm/ttm/ttm_bo_util.c   |    2 +-
>>>   include/drm/drm_sarea.h             |    2 ++
>>>   4 files changed, 7 insertions(+), 5 deletions(-)

>>> diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c

I would suggest to either split the patches into seperate ones for drm, 
ttm & radeon or change the subject line, cause a subject line starting 
with "drm/radeon..." usually means that you have only changed something 
in the radeon driver.

In the unlikely case that you broke someones else code it would be quite 
surprising that a patch with a subject line indicating only drm/radeon 
changes breaks common drm code.

Otherwise it is nice to know that only a few define changes gets the 
driver going on a complete different CPU platform, keep up with the good 
work.

Regards,
Christian.

>>> index 961ee08..3f06166 100644
>>> --- a/drivers/gpu/drm/drm_vm.c
>>> +++ b/drivers/gpu/drm/drm_vm.c
>>> @@ -62,7 +62,7 @@ static pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
>>>                tmp = pgprot_writecombine(tmp);
>>>        else
>>>                tmp = pgprot_noncached(tmp);
>>> -#elif defined(__sparc__) || defined(__arm__)
>>> +#elif defined(__sparc__) || defined(__arm__) || defined(__mips__)
>>>        tmp = pgprot_noncached(tmp);
>>>   #endif
>>>        return tmp;
>>> diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
>>> index c94a225..f49bdd1 100644
>>> --- a/drivers/gpu/drm/radeon/radeon_ttm.c
>>> +++ b/drivers/gpu/drm/radeon/radeon_ttm.c
>>> @@ -630,7 +630,7 @@ static int radeon_ttm_tt_populate(struct ttm_tt *ttm)
>>>        }
>>>   #endif
>>>
>>> -#ifdef CONFIG_SWIOTLB
>>> +#if defined(CONFIG_SWIOTLB)&&  !defined(CONFIG_CPU_LOONGSON3)
>>>        if (swiotlb_nr_tbl()) {
>>>                return ttm_dma_populate(&gtt->ttm, rdev->dev);
>>>        }
>>> @@ -676,7 +676,7 @@ static void radeon_ttm_tt_unpopulate(struct ttm_tt *ttm)
>>>        }
>>>   #endif
>>>
>>> -#ifdef CONFIG_SWIOTLB
>>> +#if defined(CONFIG_SWIOTLB)&&  !defined(CONFIG_CPU_LOONGSON3)
>>>        if (swiotlb_nr_tbl()) {
>>>                ttm_dma_unpopulate(&gtt->ttm, rdev->dev);
>>>                return;
>>> @@ -906,7 +906,7 @@ static int radeon_ttm_debugfs_init(struct radeon_device *rdev)
>>>        radeon_mem_types_list[i].show =&ttm_page_alloc_debugfs;
>>>        radeon_mem_types_list[i].driver_features = 0;
>>>        radeon_mem_types_list[i++].data = NULL;
>>> -#ifdef CONFIG_SWIOTLB
>>> +#if defined(CONFIG_SWIOTLB)&&  !defined(CONFIG_CPU_LOONGSON3)
>>>        if (swiotlb_nr_tbl()) {
>>>                sprintf(radeon_mem_types_names[i], "ttm_dma_page_pool");
>>>                radeon_mem_types_list[i].name = radeon_mem_types_names[i];
>>> diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
>>> index f8187ea..0df71ea 100644
>>> --- a/drivers/gpu/drm/ttm/ttm_bo_util.c
>>> +++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
>>> @@ -472,7 +472,7 @@ pgprot_t ttm_io_prot(uint32_t caching_flags, pgprot_t tmp)
>>>        else
>>>                tmp = pgprot_noncached(tmp);
>>>   #endif
>>> -#if defined(__sparc__)
>>> +#if defined(__sparc__) || defined(__mips__)
>>>        if (!(caching_flags&  TTM_PL_FLAG_CACHED))
>>>                tmp = pgprot_noncached(tmp);
>>>   #endif
>>> diff --git a/include/drm/drm_sarea.h b/include/drm/drm_sarea.h
>>> index ee5389d..1d1a858 100644
>>> --- a/include/drm/drm_sarea.h
>>> +++ b/include/drm/drm_sarea.h
>>> @@ -37,6 +37,8 @@
>>>   /* SAREA area needs to be at least a page */
>>>   #if defined(__alpha__)
>>>   #define SAREA_MAX                       0x2000U
>>> +#elif defined(__mips__)
>>> +#define SAREA_MAX                       0x4000U
>>>   #elif defined(__ia64__)
>>>   #define SAREA_MAX                       0x10000U     /* 64kB */
>>>   #else
>>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>

