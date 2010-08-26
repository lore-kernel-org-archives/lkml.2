Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab0HZNPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:15:13 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35892 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0HZNPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:15:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Lga4Kgptqq5xIJNa/RTwJAkiC+qBIFUGcMwU4blixHn9lVf63YADaxJqF3x7HtQ6JE
         t5CWog7SSEOhLhozwoa7bgzOqOntNmS8cy1/HJvRZDc8QRnLaixypqZ4Y3w2ijLa/WEv
         shenuGqLlHWYzbbqzRFNRvpUo59RYP2lS68oA=
MIME-Version: 1.0
In-Reply-To: <4C762572.4070509@mvista.com>
References: <linux-kernel@vger.kernel.org>
	<1282794933-20639-1-git-send-email-jiang.adam@gmail.com>
	<4C762572.4070509@mvista.com>
Date: Thu, 26 Aug 2010 22:15:09 +0900
Message-ID: <AANLkTim+RgOZY2PHQa=Ukp+bHSrHrEyF=Nfa4NU_J7K7@mail.gmail.com>
Subject: Re: [PATCH 3/3] mips: irq: add stackoverflow detection
From: Adam Jiang <jiang.adam@gmail.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: ralf@linux-mips.org, dmitri.vorobiev@movial.com, wuzhangjin@gmail.com,
        ddaney@caviumnetworks.com, peterz@infradead.org, fweisbec@gmail.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/26 Sergei Shtylyov <sshtylyov@mvista.com>:
> Hello.
>
> Adam Jiang wrote:
>
>> Add stackoverflow detection to mips arch
>
> [...]
>
>> diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
>> index c6345f5..75c584d 100644
>> --- a/arch/mips/kernel/irq.c
>> +++ b/arch/mips/kernel/irq.c
>> @@ -151,6 +151,25 @@ void __init init_IRQ(void)
>>  #endif
>>  }
>>  +#ifdef CONFIG_DEBUG_STACKOVERFLOW
>> +static inline void check_stack_overflow(void)
>> +{
>> +       long sp;
>> +
>> +       asm volatile("move %0, $sp" : "=r" (sp));
>> +       sp = sp & (THREAD_SIZE-1);
>> +
>> +       /* check for stack overflow: is there less than 2KB free? */
>> +       if (unlikely(sp < (sizeof(struct thread_info) + 2048))) {
>> +               printk("do_IRQ: stack overflow: %ld\n",
>> +                      sp - sizeof(struct thread_info));
>> +               dump_stack();
>> +       }
>> +}
>> +#else
>> +static inline void check_stack_overflow(void)
>
>   You didn't even try to compile with the option disabled -- you've missed
> {}.

Thank your, Sergei.

This is my first patch. I realized I have to learn much to summit a
good patch. And yes, I have to pay more attention on my code. Anyway,
I will try to get a good patch and send it here again.

/Adam

>
>> +#endif
>> +
>>  /*
>>  * do_IRQ handles all normal device IRQ's (the special
>>  * SMP cross-CPU interrupts have their own specific
>
> WBR, Sergei
>
