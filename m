Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab1AILoR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 06:44:17 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59538 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1AILoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 06:44:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=d7i5q4n5Swaf0C3kB7eoTxpHdTdjxUYA6h+NVxShulf3kPOUUSu/UqSmbb3/lJFTVZ
         FTkqoi9RDTB5L1Sk7ePvQs4F5XUKoC8HAXJ7O0/e6MqAhIoypMQMh5KUlWJqZ/E/wOoS
         78YrlRr03Pf9XITX/vjgAKV24Q66S7IVlcPCY=
Message-ID: <4D299F8C.9070700@gmail.com>
Date: Sun, 09 Jan 2011 14:44:12 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rakib Mullick <rakib.mullick@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] x86, apic: Do not increment disabled_cpus from generic_processor_info.
References: <AANLkTimb7wj0oP_ctr7Ergf4VmVFTMHU3QCCaLcPE5Q9@mail.gmail.com> <20110109093926.GB542@elte.hu>
In-Reply-To: <20110109093926.GB542@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2011 12:39 PM, Ingo Molnar wrote:
> 
> * Rakib Mullick <rakib.mullick@gmail.com> wrote:
> 
>>  disabled_cpus has been incremented from the call path of
>> generic_processor_info (i.e from  acpi_register_lapic and
>> MP_processor_info) when a perticular cpu is not enabled. So, we can
>> remove the redundant increment of disabled_cpus from
>> generic_processor_info.
>>
>>
>> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
...
> Hm, what effects does this have in practice? smpboot.c uses disabled_cpus as a value 
> to calculate limits - why has this bug not caused some misbehavior somewhere? (or if 
> it has caused misbehavior, what is that?)
>  
> Thanks,
> 
> 	Ingo

This disabled cpu may happen if nr_cpus early param specified and it's less than
nr_cpu_ids, but cpu might still be enabled in mp/acpi so we have to disable it.
And if we will not increment disabled_cpus this will lead the further report
about disabled cpu would refer to wrong cpu number. So I don't see why we
need to remove this disabled_cpus increment here.

Rakib is there something I miss?

-- 
    Cyrill
