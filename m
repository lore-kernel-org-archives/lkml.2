Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0JRS64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 14:58:56 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55861 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab0JRS6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 14:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=C4J6kd/AHPgAVEZ+v1iKfqlS3B6ErVFTD5QbVpAAXTEhX138djRMhp2CUAlCXTaXFj
         382mGxoMCyUyOddOBcNr+pP4s3QmP3cZgSNviteDuQZP59P9HrCOMArEwX5BUyonPrSo
         eoYSyLH7loBBP5hivYf+Ze/A7H2Fdy5u9c88o=
MIME-Version: 1.0
In-Reply-To: <4CBB4D4F.8010904@cs.helsinki.fi>
References: <1287242638-20968-1-git-send-email-richard@nod.at>
	<4CBB4D4F.8010904@cs.helsinki.fi>
Date: Mon, 18 Oct 2010 21:58:53 +0300
X-Google-Sender-Auth: t8XMj5QrUZSkr9gseWrZRS9KzGs
Message-ID: <AANLkTinPG1J280HMDkg4bhO-9evW2T86c8FKfhk84ZhR@mail.gmail.com>
Subject: Re: [PATCH 1/1] um: fix global timer issue when using CONFIG_NO_HZ
From: Pekka Enberg <penberg@kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Richard Weinberger <richard@nod.at>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net, arjan@linux.intel.com,
        peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 10:23 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On 16.10.2010 18.23, Richard Weinberger wrote:
>>
>> This fixes a issue which was introduced by fe2cc53e.
>> timeval_to_ns() returns long long and not int.
>> Due to that UML's timer did not work proper and caused timer freezes.
>>
>> LKML-Reference:<AANLkTik5_TCXeGzTWBZzE8F0Cb2bQq-D228xDXk87rhP () mail !
>> gmail ! com>
>> Signed-off-by: Richard Weinberger<richard@nod.at>
>> ---
>>  arch/um/os-Linux/time.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
>> index dec5678..6e3359d 100644
>> --- a/arch/um/os-Linux/time.c
>> +++ b/arch/um/os-Linux/time.c
>> @@ -60,7 +60,7 @@ static inline long long timeval_to_ns(const struct
>> timeval *tv)
>>  long long disable_timer(void)
>>  {
>>        struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 }
>> });
>> -       int remain, max = UM_NSEC_PER_SEC / UM_HZ;
>> +       long long remain, max = UM_NSEC_PER_SEC / UM_HZ;
>>
>>        if (setitimer(ITIMER_VIRTUAL,&time,&time)<  0)
>>                printk(UM_KERN_ERR "disable_timer - setitimer failed, "
>
> Acked-by: Pekka Enberg <penberg@kernel.org>

Andrew, do you mind picking this patch up?
