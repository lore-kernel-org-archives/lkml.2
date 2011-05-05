Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1EERjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 13:39:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25901 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1EERjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 13:39:01 -0400
Message-ID: <4DC2E097.6040800@kernel.org>
Date: Thu, 05 May 2011 10:38:31 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH -v2 RESENDING] x86, acpi: Handle xapic/x2apic entries
 in MADT at same time
References: <4DA41476.8040700@jp.fujitsu.com> <1304379923.19493.284.camel@sbsiddha-MOBL3.sc.intel.com> <4DC0514F.9070901@kernel.org> <20110505162136.GA21673@sgi.com>
In-Reply-To: <20110505162136.GA21673@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DC2E0A3.000C,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2011 09:21 AM, Jack Steiner wrote:
> FYI
> 
> We also hit the same problem. Our BIOS folks tried to make the BIOS
> ACPI compliant but we hit the same problem & broke cpu numbering.
> 
> For now, we've reverted the BIOS change but are concerned that another OS
> may require the change.
> 
> 
>>From the boot log:
>      891.184006 (    0.001022)| [    0.000000] Setting APIC routing to UV large system.
>      891.197920 (    0.013914)| [    0.000000] ACPI: X2APIC (apic_id[0x100] uid[0x20] enabled)
>      891.218507 (    0.020587)| [    0.000000] ACPI: X2APIC (apic_id[0x102] uid[0x21] enabled)
>     ...
>      904.009046 (    0.006237)| [    0.000000] ACPI: X2APIC (apic_id[0x3ff0] uid[0x7fe] enabled)
>      904.020501 (    0.011455)| [    0.000000] ACPI: X2APIC (apic_id[0x3ff2] uid[0x7ff] enabled)
>      904.024500 (    0.003999)| [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
>      904.024684 (    0.000184)| [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
> 
>     ...
> 
>     1089.050351 (    0.008981)| [   30.960025] Booting Node   4, Processors  #1  #2 #3 #4 #5 #6 #7 #8 Ok.
>     1089.847951 (    0.669131)| [   31.473073] Booting Node   5, Processors  #9 #10 #11 #12 #13 #14 #15 #16 Ok.
>     ....
>     1283.195893 (    0.772824)| [  224.864248] Booting Node 255, Processors  #2009 #2010 #2011 #2012 #2013 #2014 #2015 #2016 Ok.
>     1283.970697 (    0.774804)| [  225.637077] Booting Node   0, Processors  #2017 #2018 #2019 #2020 #2021 #2022 #2023 Ok.
>     1284.652065 (    0.681368)| [  226.316121] Booting Node   1, Processors  #2024 #2025 #2026 #2027 #2028 #2029 #2030 #2031 Ok.
>     1285.422635 (    0.770570)| [  227.088808] Booting Node   2, Processors  #2032 #2033 #2034 #2035 #2036 #2037 #2038 #2039 Ok.
>     1286.205456 (    0.782821)| [  227.864175] Booting Node   3, Processors  #2040 #2041 #2042 #2043 #2044 #2045 #2046 #2047 Ok.
> 

Yes, your new BIOS need this patch to make cpu number not out of order.

Thanks

Yinghai
