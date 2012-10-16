Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab2JPWy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:54:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45474 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696Ab2JPWy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:54:26 -0400
References: <CAAQKjZMYFNMEnb2ue2aR+6AEbOixnQFyggbXrThBCW5VOznePg@mail.gmail.com> <20121016090434.7d5e088152a3e0b0606903c8@nvidia.com> <CAAQKjZNQFfxpr-7dFb4cgNB2Gkrxxrswds_fSrYgssxXaqRF7g@mail.gmail.com> <20121016.171338.1300372057637804407.hdoyu@nvidia.com>
In-Reply-To: <20121016.171338.1300372057637804407.hdoyu@nvidia.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=euc-kr
Message-Id: <A52B7C89-16F2-44A0-A9FF-2EB599F4F074@gmail.com>
Cc: "inki.dae@samsung.com" <inki.dae@samsung.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
X-Mailer: iPad Mail (9B206)
From: Inki Dae <daeinki@gmail.com>
Subject: Re: [Linaro-mm-sig] [RFC 0/2] DMA-mapping & IOMMU - physically contiguous allocations
Date: Wed, 17 Oct 2012 07:54:17 +0900
To: Hiroshi Doyu <hdoyu@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hiroshi,



2012. 10. 16. 오후 11:13 Hiroshi Doyu <hdoyu@nvidia.com> 작성:

> Hi Inki,
> 
> Inki Dae <inki.dae@samsung.com> wrote @ Tue, 16 Oct 2012 12:12:49 +0200:
> 
>> Hi Hiroshi,
>> 
>> 2012/10/16 Hiroshi Doyu <hdoyu@nvidia.com>:
>>> Hi Inki/Marek,
>>> 
>>> On Tue, 16 Oct 2012 02:50:16 +0200
>>> Inki Dae <inki.dae@samsung.com> wrote:
>>> 
>>>> 2012/10/15 Marek Szyprowski <m.szyprowski@samsung.com>:
>>>>> Hello,
>>>>> 
>>>>> Some devices, which have IOMMU, for some use cases might require to
>>>>> allocate a buffers for DMA which is contiguous in physical memory. Such
>>>>> use cases appears for example in DRM subsystem when one wants to improve
>>>>> performance or use secure buffer protection.
>>>>> 
>>>>> I would like to ask if adding a new attribute, as proposed in this RFC
>>>>> is a good idea? I feel that it might be an attribute just for a single
>>>>> driver, but I would like to know your opinion. Should we look for other
>>>>> solution?
>>>>> 
>>>> 
>>>> In addition, currently we have worked dma-mapping-based iommu support
>>>> for exynos drm driver with this patch set so this patch set has been
>>>> tested with iommu enabled exynos drm driver and worked fine. actually,
>>>> this feature is needed for secure mode such as TrustZone. in case of
>>>> Exynos SoC, memory region for secure mode should be physically
>>>> contiguous and also maybe OMAP but now dma-mapping framework doesn't
>>>> guarantee physically continuous memory allocation so this patch set
>>>> would make it possible.
>>> 
>>> Agree that the contigous memory allocation is necessary for us too.
>>> 
>>> In addition to those contiguous/discontiguous page allocation, is
>>> there any way to _import_ anonymous pages allocated by a process to be
>>> used in dma-mapping API later?
>>> 
>>> I'm considering the following scenario, an user process allocates a
>>> buffer by malloc() in advance, and then it asks some driver to convert
>>> that buffer into IOMMU'able/DMA'able ones later. In this case, pages
>>> are discouguous and even they may not be yet allocated at
>>> malloc()/mmap().
>>> 
>> 
>> I'm not sure I understand what you mean but we had already tried this
>> way and for this, you can refer to below link,
>>               http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg22555.html
> 
> The above patch doesn't seem to have so much platform/SoC specific
> code but rather it could common over other SoC as well. Is there any
> plan to make it more generic, which can be used by other DRM drivers?
> 

Right, the above patch has no any platform/SoC specific code but doesn't use dma-mapping API . Anyway we should refrain from using such thing because gem object could still be used and shared with other processes even if user process freed user region allocated by malloc()

And our new patch in progress would resolve this issue and this way is similar to drm-based via driver of mainline kernel. And this patch isn't considered for common use and is specific to platform/SoC so much. The pages backed can be used only by 2d gpu's dma.

Thanks,
Inki Dae

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
