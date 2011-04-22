Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1DVIf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 04:35:58 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:33132 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab1DVIf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 04:35:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j1Z9ml5FOMuqF99UR7gXIFXMZsHya/InYrYx0/HXHZMiimAo1uRlBJDYd0FimN22fv
         2lL0xP7H2s1wlUvvaF8c5BZgqTVANpSmLtPkgWXMougm4St30ZiMFJ8Af32UummMWfGB
         IXb2pdt0Vh5aaB7abZRwMwaKaQyd4V9BGTYaM=
MIME-Version: 1.0
In-Reply-To: <20110422082048.GB24011@elte.hu>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
	<1303398203-2918-2-git-send-email-dzickus@redhat.com>
	<20110422082048.GB24011@elte.hu>
Date: Fri, 22 Apr 2011 12:35:55 +0400
Message-ID: <BANLkTin2R9vO08xzYFc7ctLzY-MhbUtm8Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] perf, x86: P4 PMU -- Use perf_sample_data_init helper
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yeah, it can wait

On Friday, April 22, 2011, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Don Zickus <dzickus@redhat.com> wrote:
>
>> From: Cyrill Gorcunov <gorcunov@gmail.com>
>>
>> Instead of opencoded assignments better to use
>> perf_sample_data_init helper.
>>
>> Tested-by: Lin Ming <ming.m.lin@intel.com>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>> Signed-off-by: Don Zickus <dzickus@redhat.com>
>> ---
>>  arch/x86/kernel/cpu/perf_event_p4.c |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
>> index c2520e1..6f2bd89 100644
>> --- a/arch/x86/kernel/cpu/perf_event_p4.c
>> +++ b/arch/x86/kernel/cpu/perf_event_p4.c
>> @@ -912,8 +912,7 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
>>       int idx, handled = 0;
>>       u64 val;
>>
>> -     data.addr = 0;
>> -     data.raw = NULL;
>> +     perf_sample_data_init(&data, 0);
>
> This one sure can wait for v2.6.40, right?
>
> Thanks,
>
>         Ingo
>
