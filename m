Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619Ab0KQBew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:34:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:43658 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996Ab0KQBev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:34:51 -0500
Message-ID: <4CE33256.3030308@windriver.com>
Date: Wed, 17 Nov 2010 09:39:34 +0800
From: haishan <shan.hai@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: Hai Shan <haishan.bai@gmail.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Fix float to unsigned conversion failure with SPE enabled
References: <1289707863-1768-1-git-send-email-shan.hai@windriver.com>	<1289707863-1768-2-git-send-email-shan.hai@windriver.com> <AANLkTi=SDjsDgzP=oLduB_Mo6BJCwEPe0q_VZva2VB1a@mail.gmail.com>
In-Reply-To: <AANLkTi=SDjsDgzP=oLduB_Mo6BJCwEPe0q_VZva2VB1a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2010 01:34:46.0360 (UTC) FILETIME=[9DF3AD80:01CB85F7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer wrote:
> On Sat, Nov 13, 2010 at 11:11 PM, Hai Shan <haishan.bai@gmail.com> wrote:
>   
>> Fixed the failure on converting minus float to unsigned int with SPE enabled
>>
>> Signed-off-by: Hai Shan <shan.hai@windriver.com>
>>     
>
> You should make sure to send PowerPC patches to linuxppc-dev.
>
>   

Thanks for your suggestion, I will send it to linuxppc-dev.

Regards
Shan Hai

> josh
>
>   
>> ---
>>  arch/powerpc/math-emu/math_efp.c |   17 +++++++++++++----
>>  1 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/powerpc/math-emu/math_efp.c b/arch/powerpc/math-emu/math_efp.c
>> index 41f4ef3..338a128 100644
>> --- a/arch/powerpc/math-emu/math_efp.c
>> +++ b/arch/powerpc/math-emu/math_efp.c
>> @@ -320,7 +320,9 @@ int do_spe_mathemu(struct pt_regs *regs)
>>                        } else {
>>                                _FP_ROUND_ZERO(1, SB);
>>                        }
>> -                       FP_TO_INT_S(vc.wp[1], SB, 32, ((func & 0x3) != 0));
>> +                       /* SB_s: convert from minus float to unsigned int */
>> +                       FP_TO_INT_S(vc.wp[1], SB, 32,
>> +                                       ((func & 0x3) != 0) || SB_s);
>>                        goto update_regs;
>>
>>                default:
>> @@ -458,7 +460,11 @@ cmp_s:
>>                        } else {
>>                                _FP_ROUND_ZERO(2, DB);
>>                        }
>> -                       FP_TO_INT_D(vc.wp[1], DB, 32, ((func & 0x3) != 0));
>> +                       /* DB_s: convert from minus long double to
>> +                        * unsigned long long
>> +                        */
>> +                       FP_TO_INT_D(vc.wp[1], DB, 32,
>> +                                       ((func & 0x3) != 0) || DB_s);
>>                        goto update_regs;
>>
>>                default:
>> @@ -589,8 +595,11 @@ cmp_d:
>>                                _FP_ROUND_ZERO(1, SB0);
>>                                _FP_ROUND_ZERO(1, SB1);
>>                        }
>> -                       FP_TO_INT_S(vc.wp[0], SB0, 32, ((func & 0x3) != 0));
>> -                       FP_TO_INT_S(vc.wp[1], SB1, 32, ((func & 0x3) != 0));
>> +                       /* SB*_s: convert from minus float to unsigned int */
>> +                       FP_TO_INT_S(vc.wp[0], SB0, 32,
>> +                                       ((func & 0x3) != 0) || SB0_s);
>> +                       FP_TO_INT_S(vc.wp[1], SB1, 32,
>> +                                       ((func & 0x3) != 0) || SB1_s);
>>                        goto update_regs;
>>
>>                default:
>> --
>> 1.7.0.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>     

