Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030521Ab2CPGqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 02:46:22 -0400
Received: from cpanel23.proisp.no ([88.87.44.74]:56987 "EHLO
	cpanel23.proisp.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758935Ab2CPGqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 02:46:01 -0400
Message-ID: <4F62E195.6020405@numascale.com>
Date: Fri, 16 Mar 2012 07:45:41 +0100
From: Steffen Persvold <sp@numascale.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] Added separate apic_id_valid() functions for selected
 apic drivers
References: <1331852692.16101.30.camel@sbsiddha-desk.sc.intel.com>  <1331856461-5804-1-git-send-email-sp@numascale.com> <1331856827.16101.33.camel@sbsiddha-desk.sc.intel.com>
In-Reply-To: <1331856827.16101.33.camel@sbsiddha-desk.sc.intel.com>
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

On 3/16/2012 01:13, Suresh Siddha wrote:
> On Fri, 2012-03-16 at 01:07 +0100, Steffen Persvold wrote:
>> diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
>> index 1c1c4f4..7efd0c6 100644
>> --- a/arch/x86/mm/srat.c
>> +++ b/arch/x86/mm/srat.c
>> @@ -69,12 +69,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
>>   	if ((pa->flags&  ACPI_SRAT_CPU_ENABLED) == 0)
>>   		return;
>>   	pxm = pa->proximity_domain;
>> -	apic_id = pa->apic_id;
>> -	if (!cpu_has_x2apic&&  (apic_id>= 0xff)) {
>
> not sure why you removed this. Shouldn't this be replaced with
> apic->apic_id_valid() check?
>

Well I removed it in both my patches because Yinghai stated :

 >>>the checking in SRAT could be removed.
 >>>
 >>>Yinghai

a couple of emails ago. I could of course use apic->apic_id_valid() here 
too to avoid parsing the PXM.

Cheers,
-- 
Steffen Persvold, Chief Architect NumaChip
Numascale AS - www.numascale.com
Tel: +47 92 49 25 54 Skype: spersvold
