Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728Ab0GOUoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 16:44:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29499 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934699Ab0GOUom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 16:44:42 -0400
Message-ID: <4C3F7222.5040404@kernel.org>
Date: Thu, 15 Jul 2010 13:40:02 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@kernel.org>
Subject: Re: [PATCH] x86: fix x2apic preenabled system with kexec
References: <4C3BD6AA.3070908@kernel.org> <4C3CE210.2030902@zytor.com>	 <4C3CF650.30905@kernel.org> <4C3E1FA0.9000107@kernel.org>	 <4C3E2AE6.30406@kernel.org>  <4C3E40EC.5060607@kernel.org>	 <1279152189.2849.260.camel@sbs-t61.sc.intel.com>	 <4C3EB22B.3000701@kernel.org> <1279217784.2751.7.camel@sbs-t61.sc.intel.com> <4C3F6B3D.7030303@kernel.org>
In-Reply-To: <4C3F6B3D.7030303@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C3F72FD.00E4,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 01:10 PM, Yinghai Lu wrote:
> On 07/15/2010 11:16 AM, Suresh Siddha wrote:
>> On Thu, 2010-07-15 at 00:00 -0700, Yinghai Lu wrote:
>>
>>> BTW: is there any x2apic preenabled system with apicid of boot cpu > 255?
>>
>> I am not sure. There might be one. Is there any bug which can't handle
>> this condition?
> 
> We merged apic_ops into struct apic a while ago.
> 
> so even for system with x2apic preenabled by BIOS, x2apic_cluster/phys is set to apic until smp_pare_cpus()::default_setup_apic_routing() after enable_IR_x2apic.
> 
> that means the boot cpu x2apic is accessed via memmap instead msr based way at that point.
> 
> not sure if the Boot apic id is bigger than 255. read_apic() for apic id could be wrong. ( in early_acpi_boot_init, acpi_boot_init, init_apic_mappings)
> 
> looks like we need to re-read boot_cpu_physical_apicid
> or we could assign x2apic_cluster/phys in check_x2apic(), and later if intr_remapping can not be enabed, we can revert back to phys_flat or flat?
> 

never mind,

early_acpi_boot_init::acpi_parse_madt::default_acpi_madt_oem_check() will handle the case.
it will set the apic to apic_x2apic_... accordingly if x2apic is preenabled.

Thanks

Yinghai
