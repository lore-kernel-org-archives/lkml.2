Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab0KPNQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 08:16:50 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56160 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0KPNQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 08:16:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=gYynE2zuoW5f3kEOz0RuqLv77jNlWm00MJfk1Ioq1UEFoYPtsyWqhFNyl9logwr1F7
         i3mKu6oilNtrSPFr+1sQnK+uFAXKkg+YUbFKMio7HSspjvSfKKaT3Y1+NkTULtv+e6rE
         L1HhkkYz7ZAoTZtdco01WEr0Wz74Xv4oPxTBg=
Subject: Re: Corrected data type mismatch
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: bhs <haishan.bai@gmail.com>
In-Reply-To: <4CE27404.7020307@windriver.com>
Date: Tue, 16 Nov 2010 21:16:36 +0800
Cc: Milton Miller <miltonm@bga.com>, Hai Shan <shan.hai@windriver.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Content-Transfer-Encoding: 8BIT
Message-Id: <029A97EE-F051-4E8A-93E9-C259D2A7622E@gmail.com>
References: <1289700419-11072-2-git-send-email-shan.hai@windriver.com> <mdm-kgbd-badfix@mdm.bga.com> <4CE27404.7020307@windriver.com>
To: DDD <dongdong.deng@windriver.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 16, 2010, at 8:07 PM, DDD wrote:

> Milton Miller wrote:
>> [added cc's based on from ff10b88b5a05c8f1646dd15fb9f6093c1384ff6d,
>> which added the patched line ]
>> https://patchwork.kernel.org/patch/323022/
>> On Sun, 14 Nov 2010 around 02:06:59 -0000, Hai Shan wrote:
>>> Corrected data type mismatch
>>> 
>> This merely hides the type mismatch by force casting it.
>> Looking at the context I believe the intent is to copy the the value to
>> or from the register content slot, not take the previous value of the
>> register and use that as an address to copy to or from.
> 
> 
> OOPS! It is wrong here, The right one should be as following:
> 
> -   memcpy(mem, current->thread.evr[regno-32],
> +   memcpy(mem, (void*)&current->thread.evr[regno-32], dbg_reg_def[regno].size);
> 
> Thanks milton & Shan.Hai, I will send out the fix to Jason ASAP.
> 


Sorry for my crude fix :)


> Dongdong
> 
> 
>> milton
>>> Signed-off-by: Hai Shan <shan.hai@windriver.com>
>>> 
>>> ---
>>> arch/powerpc/kernel/kgdb.c |    4 ++--
>>> 1 files changed, 2 insertions(+), 2 deletions(-)
>>> 
>>> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
>>> index 7a9db64..c5ce65f 100644
>>> --- a/arch/powerpc/kernel/kgdb.c
>>> +++ b/arch/powerpc/kernel/kgdb.c
>>> @@ -337,7 +337,7 @@ char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs)
>>> 		/* FP registers 32 -> 63 */
>>> #if defined(CONFIG_FSL_BOOKE) && defined(CONFIG_SPE)
>>> 		if (current)
>>> -			memcpy(mem, current->thread.evr[regno-32],
>>> +			memcpy(mem, (void *)current->thread.evr[regno-32],
>>> 					dbg_reg_def[regno].size);
>>> #else
>>> 		/* fp registers not used by kernel, leave zero */
>>> @@ -362,7 +362,7 @@ int dbg_set_reg(int regno, void *mem, struct pt_regs *regs)
>>> 	if (regno >= 32 && regno < 64) {
>>> 		/* FP registers 32 -> 63 */
>>> #if defined(CONFIG_FSL_BOOKE) && defined(CONFIG_SPE)
>>> -		memcpy(current->thread.evr[regno-32], mem,
>>> +		memcpy((void *)current->thread.evr[regno-32], mem,
>>> 				dbg_reg_def[regno].size);
>>> #else
>>> 		/* fp registers not used by kernel, leave zero */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

