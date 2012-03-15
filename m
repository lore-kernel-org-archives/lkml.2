Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032342Ab2COXRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 19:17:49 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:47902 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031284Ab2COXRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 19:17:48 -0400
Message-ID: <4F62788C.9020401@numascale.com>
Date: Fri, 16 Mar 2012 00:17:32 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] Use x2apic_supported() in the default_apic_id_valid()
 function.
References: <CAE9FiQXC7T7JQRfiry8nHaRYN3ggy9vfzc2jDUzar80hv6pEvw@mail.gmail.com>   <1331834583-16070-1-git-send-email-sp@numascale.com>   <CAE9FiQUh-kEcLLAZYiy90UJY8-WmXTKhYrjS7HQ40U+Ah2dwNg@mail.gmail.com>  <1331846504.16101.12.camel@sbsiddha-desk.sc.intel.com>  <4F626E6C.5010809@numascale.com> <1331852692.16101.30.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1331852692.16101.30.camel@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel23.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/2012 00:04, Suresh Siddha wrote:
> On Thu, 2012-03-15 at 23:34 +0100, Steffen Persvold wrote:
>> Is my understanding of your suggestion correct that in
>> x2apic_phys/cluster.c we add the following apic_id_valid() function :
>>
>> static int x2apic_apic_id_valid(int apicid)
>> {
>>    	return x2apic_mode || (apicid<  255);
>> }
>
> Steffen, We can have something like:
>
> static int x2apic_apic_id_valid(int apicid)
> {
>     	return 1;
> }
>
> and
>
> static int xapic_apic_id_valid(int apicid)
> {
>     	return apicid<  255;
> }
>
> If we have selected x2apic driver, then we know we are already in x2apic
> mode. And also x2apic_uv_x need to use the x2apic version above.
>
>> Considering that this function (apic->apic_id_valid()) is called already
>> in the acpi/boot.c::acpi_parse_x2apic() function is it sufficient enough
>> to test for x2apic_mode ? Yinghai indicated that x2apic_mode was not set
>> at this point, thus it was testing cpu_has_x2apic instead ?
>
> If the bios has handed over to us in x2apic mode (or if it is a numachip
> platform), then by this point apic driver is already set to the
> corresponding x2apic/numachip driver etc. so we should be fine.
>
> When we are in xapic mode, typically there should be no x2apic MADT
> entries. And even if there are any (bios not following x2apic spec), the
> above xapic_apic_id_valid() check will consider only those x2apic MADT
> entries whose id's are less than 255. xapic mode can go into x2apic mode
> later but that flow is not supposed to bring up any cpu with apic id>
> 255. So parsing only entries with apic id<  255 here should be fine.
>
> Hope this clarifies.
>

Yes, this is now my understanding aswell. Thank you.

I will resend a reviced patch shortly.

Kind regards,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
