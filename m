Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1DRVDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 17:03:19 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50425 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab1DRVDP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 17:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=K20ig/7Vlpl9rUHU+YgVt/HVsPPb48g0ka/JHdohmNCXrr2ZQQD+UiReaLe4qlNyLd
         W81qe8AFESt+vuUBXLmg==
MIME-Version: 1.0
In-Reply-To: <1303148544.13157.1.camel@e102144-lin.cambridge.arm.com>
References: <1302924445-18557-1-git-send-email-sonnyrao@chromium.org> <1303148544.13157.1.camel@e102144-lin.cambridge.arm.com>
From: Sonny Rao <sonnyrao@chromium.org>
Date: Mon, 18 Apr 2011 14:02:52 -0700
X-Google-Sender-Auth: n_8zCnLaGwtAaNk5thnN6sRGOoo
Message-ID: <BANLkTi=ifFfe-TO1PLf4aXYn0SJTxQ=0Nw@mail.gmail.com>
Subject: Re: [PATCH] Fix infinite loop in ARM user perf_event backtrace code
To: Will Deacon <will.deacon@arm.com>
Cc: Jamie Iles <jamie@jamieiles.com>, olofj@chromium.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:42 AM, Will Deacon <will.deacon@arm.com> wrote:
> Hi Sonny,
>
> On Sat, 2011-04-16 at 04:27 +0100, Sonny Rao wrote:
>> The ARM user backtrace code can get into an infinite loop if it
>> runs into an invalid stack frame which points back to itself.
>> This situation has been observed in practice.  Fix it by capping
>> the number of entries in the backtrace.  This is also what other
>> architectures do in their backtrace code.
>>
>> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
>> ---
>>  arch/arm/kernel/perf_event.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
>> index 69cfee0..1e61d60 100644
>> --- a/arch/arm/kernel/perf_event.c
>> +++ b/arch/arm/kernel/perf_event.c
>> @@ -746,7 +746,8 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
>>
>>         tail = (struct frame_tail __user *)regs->ARM_fp - 1;
>>
>> -       while (tail && !((unsigned long)tail & 0x3))
>> +       while ((entry->nr < PERF_MAX_STACK_DEPTH) &&
>> +              tail && !((unsigned long)tail & 0x3))
>>                 tail = user_backtrace(tail, entry);
>>  }
>
> Ok. Please can you put this into Russell's patch system?
>
> Will
>

Ok, sent it to patches@arm.linux.org.uk
hope that'll be sufficient
