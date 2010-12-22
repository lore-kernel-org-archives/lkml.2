Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab0LVOX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 09:23:58 -0500
Received: from smtp-out.google.com ([216.239.44.51]:40613 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0LVOX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 09:23:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qjW3GlgS5pHYTFL1lfWjSG9Kooq5DZol3POtjeOqDDaRuaMNFzUz4ma3kZIEK5pRKg
         sBBMF5mUad018LEL6GJA==
MIME-Version: 1.0
In-Reply-To: <20101222093032.0320c9bf@mschwide.boeblingen.de.ibm.com>
References: <1292980144-28796-1-git-send-email-venki@google.com>
	<1292980144-28796-3-git-send-email-venki@google.com>
	<20101222093032.0320c9bf@mschwide.boeblingen.de.ibm.com>
Date: Wed, 22 Dec 2010 06:23:55 -0800
Message-ID: <AANLkTi=Jensy79OAu10LWvmFC7kMHGUpeJUFRX-soGTw@mail.gmail.com>
Subject: Re: [PATCH 2/5] Add nsecs_to_cputime64 interface for asm-generic -v2
From: Venkatesh Pallipadi <venki@google.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 12:30 AM, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:
> On Tue, 21 Dec 2010 17:09:01 -0800
> Venkatesh Pallipadi <venki@google.com> wrote:
>
>> Add nsecs_to_cputime64 interface. This is used in following patches that
>> updates cpu irq stat based on ns granularity info in IRQ_TIME_ACCOUNTING.
>>
>> Tested-by: Shaun Ruffell <sruffell@digium.com>
>> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
>> ---
>>  include/asm-generic/cputime.h |    3 +++
>>  include/linux/jiffies.h       |    1 +
>>  kernel/time.c                 |   23 +++++++++++++++++++++--
>>  3 files changed, 25 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
>> index 2bcc5c7..61e03dd 100644
>> --- a/include/asm-generic/cputime.h
>> +++ b/include/asm-generic/cputime.h
>> @@ -30,6 +30,9 @@ typedef u64 cputime64_t;
>>  #define cputime64_to_jiffies64(__ct) (__ct)
>>  #define jiffies64_to_cputime64(__jif)        (__jif)
>>  #define cputime_to_cputime64(__ct)   ((u64) __ct)
>> +#define cputime64_gt(__a, __b)               ((__a) >  (__b))
>> +
>> +#define nsecs_to_cputime64(__ct)     nsecs_to_jiffies64(__ct)
>>
>>
>>  /*
>
> If you define a new cputime primitive it is not enough to add it to the
> generic cputime header. You have to add it to the arch-specific cputime
> header for ia64, powerpc and s390 as well. Otherwise the build will
> break with CONFIG_VIRT_CPU_ACCOUNTING=y on these architectures once the
> new primitive is used.
>

But, those archs have arch specific cputime as well and so need a
different macro for nsecs_to_cputime64, instead of nsec_to_jiffies64.
Right? As of now this new primitive should not be used in those archs.
I guess this is something needed when using the primitive in future?

Thanks,
Venki
