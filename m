Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab2BVDgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 22:36:50 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48388 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab2BVDgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 22:36:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ajeet.yadav.77@gmail.com designates 10.220.157.83 as permitted sender) smtp.mail=ajeet.yadav.77@gmail.com; dkim=pass header.i=ajeet.yadav.77@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329580086.2448.12.camel@computer2.home>
References: <1329484170-26329-1-git-send-email-ajeet.yadav.77@gmail.com>
	<1329580086.2448.12.camel@computer2.home>
Date: Wed, 22 Feb 2012 09:06:48 +0530
Message-ID: <CAB4K4y5p14kt2HXfrGTkO8Jezoj1S4ZOrJ+cmz5t3u53jMoSMA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: dma-mapping: its array of pointer
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Tixy <tixy@yxit.co.uk>
Cc: Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, reposted with changes.

Ajeet

On Sat, Feb 18, 2012 at 9:18 PM, Tixy <tixy@yxit.co.uk> wrote:
> On Fri, 2012-02-17 at 18:39 +0530, Ajeet Yadav wrote:
>> To be consistant with declaration and usage of
>        ^^^^^^^^^^
> Spelling mistake, should be 'consistent'
>
>> consistent_pte it need to be an array of (pte *)
>                    ^^^^
> Grammar mistake, should be 'needs'.
>
>>
>> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
>
> The title of this patch is a bit vague, perhaps something like:
> "ARM: dma-mapping: Fix the type used for consistent_pte size
> calculation"
>
> The actual patch looks correct.
>
> --
> Tixy
>
>> ---
>>  arch/arm/mm/dma-mapping.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
>> index 1aa664a..04bfa76 100644
>> --- a/arch/arm/mm/dma-mapping.c
>> +++ b/arch/arm/mm/dma-mapping.c
>> @@ -170,7 +170,7 @@ static int __init consistent_init(void)
>>       unsigned long base = consistent_base;
>>       unsigned long num_ptes = (CONSISTENT_END - base) >> PMD_SHIFT;
>>
>> -     consistent_pte = kmalloc(num_ptes * sizeof(pte_t), GFP_KERNEL);
>> +     consistent_pte = kmalloc(num_ptes * sizeof(pte_t *), GFP_KERNEL);
>>       if (!consistent_pte) {
>>               pr_err("%s: no memory\n", __func__);
>>               return -ENOMEM;
>
>
>
