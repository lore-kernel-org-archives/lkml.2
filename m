Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1AIRni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 12:43:38 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41570 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1AIRnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 12:43:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L3fLx2jPWePWtOevN7nN6aDT7G1Z5DXBhHPg1jIcAn62R8ZxcL847vSYW6XJWFXgsV
         3TppXe1KNotdmA38w6Mf0BieQTNZGVAPXGlErzZut0dmqTtBbLl247DzAl8ilpH6NWf8
         1ZlhD3OZSGiVFff+uYFcMIn7MrGMYqseSEcKI=
MIME-Version: 1.0
In-Reply-To: <4D299F8C.9070700@gmail.com>
References: <AANLkTimb7wj0oP_ctr7Ergf4VmVFTMHU3QCCaLcPE5Q9@mail.gmail.com>
	<20110109093926.GB542@elte.hu>
	<4D299F8C.9070700@gmail.com>
Date: Sun, 9 Jan 2011 23:09:01 +0600
Message-ID: <AANLkTikNGVbYK-VMiLu2xFzzO6ti5kXXB+p-MzcUYx63@mail.gmail.com>
Subject: Re: [PATCH] x86, apic: Do not increment disabled_cpus from generic_processor_info.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 9, 2011 at 5:44 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On 01/09/2011 12:39 PM, Ingo Molnar wrote:
>>
>> * Rakib Mullick <rakib.mullick@gmail.com> wrote:
>>
>>>  disabled_cpus has been incremented from the call path of
>>> generic_processor_info (i.e from  acpi_register_lapic and
>>> MP_processor_info) when a perticular cpu is not enabled. So, we can
>>> remove the redundant increment of disabled_cpus from
>>> generic_processor_info.
>>>
>>>
>>> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ...
>> Hm, what effects does this have in practice? smpboot.c uses disabled_cpus as a value
>> to calculate limits - why has this bug not caused some misbehavior somewhere? (or if
>> it has caused misbehavior, what is that?)
>>
>> Thanks,
>>
>>       Ingo
>
> This disabled cpu may happen if nr_cpus early param specified and it's less than
> nr_cpu_ids, but cpu might still be enabled in mp/acpi so we have to disable it.
> And if we will not increment disabled_cpus this will lead the further report
> about disabled cpu would refer to wrong cpu number. So I don't see why we
> need to remove this disabled_cpus increment here.
>
> Rakib is there something I miss?
>
Lets see what Ingo says. :)

> --
>    Cyrill
>
