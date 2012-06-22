Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab2FVKzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:55:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39241 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758106Ab2FVKzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:55:42 -0400
MIME-Version: 1.0
In-Reply-To: <87txy3sn20.fsf@lebrac.rtp-net.org>
References: <1340334073-17804-1-git-send-email-chenhc@lemote.com>
	<1340334073-17804-12-git-send-email-chenhc@lemote.com>
	<87txy3sn20.fsf@lebrac.rtp-net.org>
Date: Fri, 22 Jun 2012 18:55:40 +0800
Message-ID: <CAAhV-H5q5G87UMn0ixPUVZNcEV1b_qBHJKVKmCJsmzKdEB--4A@mail.gmail.com>
Subject: Re: [PATCH V3 11/16] drm/radeon: Make radeon card usable for Loongson.
From: Huacai Chen <chenhuacai@gmail.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>, Huacai Chen <chenhc@lemote.com>,
        Hongliang Tao <taohl@lemote.com>, Hua Yan <yanh@lemote.com>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 5:39 PM, Arnaud Patard
<arnaud.patard@rtp-net.org> wrote:
>
> Hi,
>
> Huacai Chen <chenhuacai@gmail.com> writes:
>
>> 1, Handle io prot correctly for MIPS.
>> 2, Define SAREA_MAX as the size of one page.
>> 3, Don't use swiotlb on Loongson machines (Loonson need swioitlb, but
>>    when use swiotlb, GPU reset occurs at resume from suspend).
>>
>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>> Signed-off-by: Hongliang Tao <taohl@lemote.com>
>> Signed-off-by: Hua Yan <yanh@lemote.com>
>> Reviewed-by: Michel Dänzer <michel@daenzer.net>
>> Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
>> Reviewed-by: Lucas Stach <dev@lynxeye.de>
>> Reviewed-by: j.glisse <j.glisse@gmail.com>
>> Cc: dri-devel@lists.freedesktop.org
>> ---
>>  drivers/gpu/drm/drm_vm.c            |    2 +-
>>  drivers/gpu/drm/radeon/radeon_ttm.c |    6 +++---
>>  drivers/gpu/drm/ttm/ttm_bo_util.c   |    2 +-
>>  include/drm/drm_sarea.h             |    2 ++
>>  4 files changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
>> index 961ee08..3f06166 100644
>> --- a/drivers/gpu/drm/drm_vm.c
>> +++ b/drivers/gpu/drm/drm_vm.c
>> @@ -62,7 +62,7 @@ static pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
>>               tmp = pgprot_writecombine(tmp);
>>       else
>>               tmp = pgprot_noncached(tmp);
>> -#elif defined(__sparc__) || defined(__arm__)
>> +#elif defined(__sparc__) || defined(__arm__) || defined(__mips__)
>>       tmp = pgprot_noncached(tmp);
>
> btw, would it be a good idea to use uncached accelerated instead ?
I have tried uncached accelerated, there will be random points in the
monitor, it seems a hw issue...

>
> Arnaud
