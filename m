Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161902Ab2CPA5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:57:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44522 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161704Ab2CPA5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:57:17 -0400
MIME-Version: 1.0
In-Reply-To: <1331856827.16101.33.camel@sbsiddha-desk.sc.intel.com>
References: <1331852692.16101.30.camel@sbsiddha-desk.sc.intel.com>
	<1331856461-5804-1-git-send-email-sp@numascale.com>
	<1331856827.16101.33.camel@sbsiddha-desk.sc.intel.com>
Date: Thu, 15 Mar 2012 17:57:16 -0700
X-Google-Sender-Auth: 489fjJirZ_9WT-mmcY9B_Frexb0
Message-ID: <CAE9FiQX7P_Nxe6DVWaJ_4MFtwoNY00xykOeFDesDOK1CjtuFTQ@mail.gmail.com>
Subject: Re: [PATCH] Added separate apic_id_valid() functions for selected
 apic drivers
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Steffen Persvold <sp@numascale.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 5:13 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Fri, 2012-03-16 at 01:07 +0100, Steffen Persvold wrote:
>> diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
>> index 1c1c4f4..7efd0c6 100644
>> --- a/arch/x86/mm/srat.c
>> +++ b/arch/x86/mm/srat.c
>> @@ -69,12 +69,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
>>       if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
>>               return;
>>       pxm = pa->proximity_domain;
>> -     apic_id = pa->apic_id;
>> -     if (!cpu_has_x2apic && (apic_id >= 0xff)) {
>
> not sure why you removed this. Shouldn't this be replaced with
> apic->apic_id_valid() check?
>

yes,  it should change to apic->apic_id_valid().

in arch/x86/kernel/setup.c,  early_acpi_boot_init() calling will probe
and install right apic.

Yinghai
