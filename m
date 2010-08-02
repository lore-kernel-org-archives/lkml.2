Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab0HBVfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:35:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18393 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab0HBVfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:35:47 -0400
Message-ID: <4C5739D6.1070507@kernel.org>
Date: Mon, 02 Aug 2010 14:34:14 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] acpi: x2apic entry with uid < 255 could use processor
 statement
References: <4C53C7E7.4040204@kernel.org>	 <1280776014.2703.9.camel@sbsiddha-MOBL3.sc.intel.com>	 <AANLkTi=HUTRqkj=zYV=5Z9fZAZa_sNmRanibaMLGrX0R@mail.gmail.com> <1280782411.2703.21.camel@sbsiddha-MOBL3.sc.intel.com>
In-Reply-To: <1280782411.2703.21.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C573A04.0077,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 01:53 PM, Suresh Siddha wrote:
> On Mon, 2010-08-02 at 13:18 -0700, Yinghai Lu wrote:
>> On Mon, Aug 2, 2010 at 12:06 PM, Suresh Siddha
>> <suresh.b.siddha@intel.com> wrote:
>>> On Sat, 2010-07-31 at 07:51 +0100, Yinghai Lu wrote:
>>>> According to Intel x2apic spec page 46
>>>>
>>>> " The hand-off to
>>>> OSPM will have processor IDs in the range of 0 to 254 for xAPIC/x2APIC and 0 to 255
>>>> for SAPIC declared as either Processor() or Device() objects, but not both. Processor
>>>> IDs outside these ranges must be declared as Device() objects."
>>>>
>>>> So only check if Device is used when acpi_id >=255.
>>>>
>>>> that will help system with less 255 cpus, but some cpus apic id > 255,
>>>> still can use Processor statement instead of Device() objects.
>>>
>>> But the entries with apic_id < 255 are supposed to use local APIC
>>> structure and not local x2apic structure. So entries with apic id < 255
>>> must be processed using map_lapic_id() which doesn't have any
>>> device_declaration checks.
>>>
>>> Only for apic ids > 255, we use map_x2apic_id() which needs device
>>> declaration. So this patch is not needed. or Am I missing something?
>>
>> it is acpi_id aka  Processor id.
>>
>> the system has less than 255 cpus, but some cpus apic_id > 255.
>> BIOS have apic entries for apic_id < 255, and some x2apic entries for
>> apic_id > 255.
>>
>> but BIOS still use Processor statement for all cpus.
> 
> Ok. I think there might be some confusion or mis-interpretation of the
> words here. You referred to x2apic spec page 46, perhaps this is an
> older version. Newer x2apic version leaves all the ACPI definitions to
> the ACPI 4.0 spec.
> 
> And here is what ACPI 4.0 spec says:
> 
> In Table5-33 for processor local x2apic structure:
> 
> ACPI Processor UID
> 4
> 12
> OSPM associates the X2APIC Structure with a processor object declared in
> the namespace using the Device statement, when the _UID child object of
> the processor device evaluates to a numeric value, by matching the
> numeric value with this field
> 
> And in page 312:
> 
> <snip>
> The platform may declare processors with IDs in the range of 0-254 for
> APIC/x2APIC implementations and 0-255 for SAPIC implementations using
> either the ASL Processor statement or the ASL Device statement but not
> both. Processors with IDs outside these ranges must be declared using
> the ASL Device statement.
> </snip>
> 
> And in the above paragraph "processors with IDs" are APIC id's and not
> ACPI Id's.
> 
> So I think your bios need to implement ACPI device objects for the
> x2apic entries.

that is confusing.

thanks. I will ask BIOS to fix that.

Yinghai
