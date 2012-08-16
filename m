Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab2HPAnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 20:43:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40132 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab2HPAnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 20:43:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120815213126.GC15844@linux-mips.org>
References: <1344677543-22591-1-git-send-email-chenhc@lemote.com>
	<1344677543-22591-14-git-send-email-chenhc@lemote.com>
	<20120815213126.GC15844@linux-mips.org>
Date: Thu, 16 Aug 2012 08:43:06 +0800
Message-ID: <CAAhV-H46joC7baQ44-O0sqWM4iWVFf=DE2DoAVn1+bxro+7pNg@mail.gmail.com>
Subject: Re: [PATCH V5 13/18] drm: Define SAREA_MAX for Loongson (PageSize = 16KB).
From: Huacai Chen <chenhuacai@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Hongliang Tao <taohl@lemote.com>, Hua Yan <yanh@lemote.com>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 5:31 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Sat, Aug 11, 2012 at 05:32:18PM +0800, Huacai Chen wrote:
>
>> Subject: [PATCH V5 13/18] drm: Define SAREA_MAX for Loongson (PageSize = 16KB).
>
> But your code doesn't define it just for Loongsson as the log message claims
> but rather for all MIPS.
>
>> diff --git a/include/drm/drm_sarea.h b/include/drm/drm_sarea.h
>> index ee5389d..1d1a858 100644
>> --- a/include/drm/drm_sarea.h
>> +++ b/include/drm/drm_sarea.h
>> @@ -37,6 +37,8 @@
>>  /* SAREA area needs to be at least a page */
>>  #if defined(__alpha__)
>>  #define SAREA_MAX                       0x2000U
>> +#elif defined(__mips__)
>> +#define SAREA_MAX                       0x4000U
>
> How about replacing this whole #ifdef mess with something like:
>
> #include <linux/kernel.h>
> #include <asm/page.h>
>
> /* Intel 830M driver needs at least 8k SAREA */
> #define SAREA_MAX       max(PAGE_SIZE, 0x2000U)
>
> MIPS also uses 64K page size and your patch as posted would break with 64k
> pages.
Yes, I think this is better. Thank you.
>
>   Ralf
