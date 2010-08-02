Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0HBUSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:18:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44010 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab0HBUSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=xSd4D4Rl8EanBqu7pP/baCEkTSDY1oh1qjEt7hBAovFm1v7j9818fffhc7dAFLO87L
         nKPDPWXXyVw6Kp51mfropxzicXth3ZDBLUSV7yYnGWsxH/w01feW6xHBfLfsLhvymZwb
         kRqnxu2o+JyP9a0Q4u3HQtbZUROFrvFFSeedA=
MIME-Version: 1.0
In-Reply-To: <1280776014.2703.9.camel@sbsiddha-MOBL3.sc.intel.com>
References: <4C53C7E7.4040204@kernel.org>
	<1280776014.2703.9.camel@sbsiddha-MOBL3.sc.intel.com>
Date: Mon, 2 Aug 2010 13:18:49 -0700
X-Google-Sender-Auth: Ojex5qH7bGS_YRrGZI3oXAIdEr0
Message-ID: <AANLkTi=HUTRqkj=zYV=5Z9fZAZa_sNmRanibaMLGrX0R@mail.gmail.com>
Subject: Re: [PATCH] acpi: x2apic entry with uid < 255 could use processor 
	statement
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 12:06 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Sat, 2010-07-31 at 07:51 +0100, Yinghai Lu wrote:
>> According to Intel x2apic spec page 46
>>
>> " The hand-off to
>> OSPM will have processor IDs in the range of 0 to 254 for xAPIC/x2APIC and 0 to 255
>> for SAPIC declared as either Processor() or Device() objects, but not both. Processor
>> IDs outside these ranges must be declared as Device() objects."
>>
>> So only check if Device is used when acpi_id >=255.
>>
>> that will help system with less 255 cpus, but some cpus apic id > 255,
>> still can use Processor statement instead of Device() objects.
>
> But the entries with apic_id < 255 are supposed to use local APIC
> structure and not local x2apic structure. So entries with apic id < 255
> must be processed using map_lapic_id() which doesn't have any
> device_declaration checks.
>
> Only for apic ids > 255, we use map_x2apic_id() which needs device
> declaration. So this patch is not needed. or Am I missing something?

it is acpi_id aka  Processor id.

the system has less than 255 cpus, but some cpus apic_id > 255.
BIOS have apic entries for apic_id < 255, and some x2apic entries for
apic_id > 255.

but BIOS still use Processor statement for all cpus.

Thanks

Yinghai
