Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1B1W7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 17:59:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60841 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab1B1W7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 17:59:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AFpK47CJHr83rBkMD1SNeLTE/amL5QcLsDw9IhKA7MPGGo64A12/bvGzbAluzleKlp
         WR2m3l66f3bbMVpgIKYyVvXJsnlU7Ie/HxiswpB9E4gQwId96ck5AkI+YmRTTfVJL3+I
         3KvxMpqWnUmCCjfFDcUSQbCb4X2Wiz7p5Pd60=
MIME-Version: 1.0
In-Reply-To: <4D6BFF46.3050001@sgi.com>
References: <20110225180633.857892225@gulag1.americas.sgi.com>
	<20110225180634.017570095@gulag1.americas.sgi.com>
	<20110227120949.GF16453@elte.hu>
	<20110227121518.GA19165@elte.hu>
	<4D6AFBB0.70401@kernel.org>
	<4D6BF63D.2020404@sgi.com>
	<AANLkTi=Sn6DKAjGHQjtWGiLGh8vpuS-vmXK=TMDrbjdv@mail.gmail.com>
	<4D6BFF46.3050001@sgi.com>
Date: Mon, 28 Feb 2011 14:59:47 -0800
X-Google-Sender-Auth: AAmsToDV1JovVeTdB32AHH_gn6Q
Message-ID: <AANLkTi=Xf5RaF559QsRNijmG0YP7amkG569NZFhpt4QY@mail.gmail.com>
Subject: Re: [PATCH 1/4] printk: Allocate kernel log buffer earlier
From: Yinghai Lu <yinghai@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Rientjes <rientjes@google.com>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 12:02 PM, Mike Travis <travis@sgi.com> wrote:
>
>
> Yinghai Lu wrote:
>>
>> On Mon, Feb 28, 2011 at 11:23 AM, Mike Travis <travis@sgi.com> wrote:
>>>
>>> Yinghai Lu wrote:
>>>>
>>>> On 02/27/2011 04:15 AM, Ingo Molnar wrote:
>>>>>
>>>>> * Ingo Molnar <mingo@elte.hu> wrote:
>>>>>
>>>>>> You could avoid all this ugly workaround of bootmem limitations by
>>>>>> moving the allocation to memblock_alloc() and desupporting the
>>>>>> log_buf_len=
>>>>>> boot parameter on non-memblock architectures.
>>>>>
>>>>> memblock_alloc() could return -ENOSYS on architectures that do not
>>>>> implement it - thus enabling such optional features without ugly #ifdef
>>>>> CONFIG_HAVE_MEMBLOCK conditionals.
>>>>
>>>> Mike,
>>>>
>>>> please check updated patch...
>>>>
>>>> with the memblock change, you don't need to change acpi SRAT handling
>>>> etc
>>>> any more.
>>>
>>> I had to debug a weird ACPI -> Node mapping last week and the
>>> "improved" SRAT messages helped that considerably.  It was
>>> far easier to spot which Node didn't have the correct assignments.
>>> I'd submit that patch even without needing fewer (like 512 lines
>>> max instead of 4096 lines max) bytes in the log buffer.
>>
>> Your current change to ACPI srat is not complete yet.
>>
>> you only handle x2apic entries.
>>
>> According to ACPI 4.0 spec, We should have mixed entries with apic
>> entries and x2apic entries.
>> apic entries are for apic id < 255.
>> x2apic entries are for apic id > 255.
>>
>> Yinghai
>
> Are you sure you can run both "legacy" and "x2" apic modes in
> the same SSI under the Intel or AMD rules?
>
No.

According to ACPI 4.0 Spec:
even the CPUs are with x2apic mode (aka pre-enabled in BIOS),
if their apic id < 255, BIOS still need to use xapic entries for them.

Yinghai
