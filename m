Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0JGR6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:58:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11567 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab0JGR6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:58:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=n/DciQnipwjRneF995bbH8ja7E8NuTk8HhPz/J3sbBDrn7iyZVvW/t6RUZwjt5F9Jl
         yDiCIzbyGNT4lh8oyRjQ==
MIME-Version: 1.0
In-Reply-To: <20101007021959.GA7300@suse.de>
References: <1286406919-6236-1-git-send-email-snanda@chromium.org> <20101007021959.GA7300@suse.de>
From: Sameer Nanda <snanda@chromium.org>
Date: Thu, 7 Oct 2010 10:58:10 -0700
X-Google-Sender-Auth: YUvZdnlIl-98YnjdD6_oZsE9lvw
Message-ID: <AANLkTi=mjaojm-O2rbKRTpsqpKiSKjU+P2dGZmENd-jU@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Read TSC upon resume
To: Greg KH <gregkh@suse.de>
Cc: lenb@kernel.org, stefan.bader@canonical.com, brad.figg@canonical.com,
        apw@canonical.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resending as plain text, sorry if you got dupe messages)

On Wed, Oct 6, 2010 at 7:19 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Oct 06, 2010 at 04:15:19PM -0700, Sameer Nanda wrote:
>> Read the TSC upon resuming and print it out. This is useful
>> in helping figure out amount of time spent in the BIOS when
>> resuming from suspend.
>>
>> Change-Id: I1d6a32bd62421becddecd152d561763e5f3e1101
>
> What is this tag for?  I don't think it matches anything the kernel
> community wants, do you?

Yeah, its not needed.  Let me resubmit the patch without this tag.

>
> And are you always going to be printing this out?  Why do we want to
> know this every time?

Yes, every time.  This helps track variance in BIOS resume times
within a single boot.

>
>> Signed-off-by: Sameer Nanda <snanda@chromium.org>
>> ---
>>  drivers/acpi/sleep.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
>> index c0fed2e..f0588fa 100644
>> --- a/drivers/acpi/sleep.c
>> +++ b/drivers/acpi/sleep.c
>> @@ -214,6 +214,7 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
>>       acpi_status status = AE_OK;
>>       unsigned long flags = 0;
>>       u32 acpi_state = acpi_target_sleep_state;
>> +     u64 tsc;
>>
>>       ACPI_FLUSH_CPU_CACHE();
>>
>> @@ -235,6 +236,9 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
>>
>>       case ACPI_STATE_S3:
>>               do_suspend_lowlevel();
>> +             rdtscll(tsc);
>> +             printk(KERN_INFO "TSC at resume: %llu\n",
>> +                             (unsigned long long)tsc);
>
> How long does this take, will it slow down resume?

The impact is ~10us (as measured on an Intel Atom N455 @ 1.66Ghz).
Given that resume time is currently of the order of 1sec, its in the
noise range.

Thanks for the feedback!

>
> thanks,
>
> greg k-h
>



-- 
Sameer
