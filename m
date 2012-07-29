Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab2G2BT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 21:19:56 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58647 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2G2BTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 21:19:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAJFZqHxBE6wc2hJd=mKfx9D59S73qxJZFvbfqgmLkWZvtR7f_A@mail.gmail.com>
References: <1341203670-17544-1-git-send-email-roy.qing.li@gmail.com>
	<CAJFZqHxBE6wc2hJd=mKfx9D59S73qxJZFvbfqgmLkWZvtR7f_A@mail.gmail.com>
Date: Sun, 29 Jul 2012 09:19:23 +0800
Message-ID: <CAJd=RBD0Pd2Rx8qijj7GK8hWQBvEBXRzXFQAbtKu5X1wb9EhEQ@mail.gmail.com>
Subject: Re: [PATCH] MIPS: fix tc_id calculation
From: Hillf Danton <dhillf@gmail.com>
To: RongQing Li <roy.qing.li@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2012 at 5:08 PM, RongQing Li <roy.qing.li@gmail.com> wrote:
> Any advice
>
> 2012/7/2  <roy.qing.li@gmail.com>:
>> From: RongQing.Li <roy.qing.li@gmail.com>
>>
>> Now the tc_id is:
>>   (read_c0_tcbind() >> TCBIND_CURTC_SHIFT) & TCBIND_CURTC;
>> After substitute macro:
>>   (read_c0_tcbind() >> 21) & ((0xff) << 21)
>> It should be:
>>   (read_c0_tcbind() & ((0xff)<< 21)) >>21
>>
>> Signed-off-by: RongQing.Li <roy.qing.li@gmail.com>
>> ---

Good catch ;)

Thanks,
               Hillf


>>  arch/mips/kernel/smp-cmp.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
>> index e7e03ec..afc379c 100644
>> --- a/arch/mips/kernel/smp-cmp.c
>> +++ b/arch/mips/kernel/smp-cmp.c
>> @@ -102,7 +102,7 @@ static void cmp_init_secondary(void)
>>         c->vpe_id = (read_c0_tcbind() >> TCBIND_CURVPE_SHIFT) & TCBIND_CURVPE;
>>  #endif
>>  #ifdef CONFIG_MIPS_MT_SMTC
>> -       c->tc_id  = (read_c0_tcbind() >> TCBIND_CURTC_SHIFT) & TCBIND_CURTC;
>> +       c->tc_id  = (read_c0_tcbind() & TCBIND_CURTC) >> TCBIND_CURTC_SHIFT;
>>  #endif
>>  }
>>
>> --
>> 1.7.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
