Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1CQRjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 13:39:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41324 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab1CQRjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 13:39:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HMZr5AGffda2SK5jJ/y7Y4/F72kDLJihaqhNfFBYzbtewLZI0YqYyVGTjjBnPoDE4N
         eGb/P67IliKvbEwoBE2kZC68z2mcXTiI6F/bAYXYxMN9Dq97+5/WxQhsSUAiADh0WClj
         gAbkAR/GVpUGRBGeluhyV8p/yScdvOBvq4D/Q=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103171301030.26889@xanadu.home>
References: <1300098516-1601-1-git-send-email-ratbert.chuang@gmail.com>
	<1300169637-1628-1-git-send-email-ratbert.chuang@gmail.com>
	<alpine.LFD.2.00.1103171301030.26889@xanadu.home>
Date: Thu, 17 Mar 2011 13:37:49 -0400
Message-ID: <AANLkTik1oEkLX3R-adK9-_2W+ku4j9YDikr+Z4vzfGtb@mail.gmail.com>
Subject: Re: [PATCH v2] arm: cmpxchg syscall should data abort if page not write
From: Ashwin Chaugule <ashbertslists@gmail.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Po-Yu Chuang <ratbert.chuang@gmail.com>, linux@arm.linux.org.uk,
        Po-Yu Chuang <ratbert@faraday-tech.com>, tony@atomide.com,
        linux-kernel@vger.kernel.org, joe@perches.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 1:01 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Tue, 15 Mar 2011, Po-Yu Chuang wrote:
>
>> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>>
>> If the page to cmpxchg is user mode read only (not write),
>> we should simulate a data abort first.
>>
>> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
>
> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
>
>> ---
>> v2:
>> remove !pte_young() check
>>
>>  arch/arm/kernel/traps.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
>> index 446aee9..eac7c05 100644
>> --- a/arch/arm/kernel/traps.c
>> +++ b/arch/arm/kernel/traps.c
>> @@ -563,7 +563,7 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
>>               if (!pmd_present(*pmd))
>>                       goto bad_access;
>>               pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
>> -             if (!pte_present(*pte) || !pte_dirty(*pte)) {
>> +             if (!pte_present(*pte) || !pte_write(*pte) || !pte_dirty(*pte)) {
>>                       pte_unmap_unlock(pte, ptl);
>>                       goto bad_access;
>>               }
>> --
>> 1.6.3.3
>>


Just beginning to understand the subtleties involved, so please
correct me if I'm wrong.
Wont this patch also fix the problem that was brought up with futexes
on ARM SMP ?

http://lists.infradead.org/pipermail/linux-arm-kernel/2010-June/017374.html

Cheers,
Ashwin
