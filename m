Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0DJCsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 22:48:13 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:17411 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab0DJCsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 22:48:07 -0400
Message-ID: <4BBFE66C.2040603@oracle.com>
Date: Fri, 09 Apr 2010 19:46:04 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: guenter.roeck@ericsson.com, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well
 as x86_32
References: <1270839357.1477.758.camel@groeck-laptop> <4BBF863B.1060806@oracle.com> <20100409222103.GA11130@hexapodia.org> <4BBFA9BF.60608@oracle.com> <20100409223532.GC11130@hexapodia.org> <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org> <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org> <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org>
In-Reply-To: <20100410015711.GH11130@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BBFE6C1.0080:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 06:57 PM, Andy Isaacson wrote:
> On Fri, Apr 09, 2010 at 06:48:31PM -0700, Yinghai wrote:
>> On 04/09/2010 06:43 PM, Andy Isaacson wrote:
>>> On Fri, Apr 09, 2010 at 06:10:49PM -0700, Yinghai wrote:
>>>> in addition to -v2 patch
>>>>
>>>> please apply this patch too
>>>>
>>>> also please boot with "debug" in boot command line.
>>>>
>>>> Thanks
>>>>
>>>> Yinghai
>>>>
>>>> [PATCH] x86,acpi: use request_resource instead of instead of insert_resource
>>>>
>>>> So make pci root resouce from _CRS honor the one We reserve in e820 below 1M
>>>>
>>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>>
>>>> ---
>>>>  arch/x86/pci/acpi.c |    2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> Index: linux-2.6/arch/x86/pci/acpi.c
>>>> ===================================================================
>>>> --- linux-2.6.orig/arch/x86/pci/acpi.c
>>>> +++ linux-2.6/arch/x86/pci/acpi.c
>>>> @@ -168,7 +168,7 @@ setup_resource(struct acpi_resource *acp
>>>>  		return AE_OK;
>>>>  	}
>>>>  
>>>> -	conflict = insert_resource_conflict(root, res);
>>>> +	conflict = request_resource_conflict(root, res);
>>>>  	if (conflict) {
>>>>  		dev_err(&info->bridge->dev,
>>>>  			"address space collision: host bridge window %pR "
>>>
>>> That works.  dmesg.gz attached (I'm pretty sure I'm skating close to
>>> vger's size limit without gz).  "debug" didn't seem to make much
>>> difference?
>>
>> [    0.636805] ACPI: PCI Root Bridge [PCI0] (0000:00)
>> [    0.654025] pci_root PNP0A03:00: address space collision: host bridge window [io  0x0000-0x0cf7] conflicts with dma1 [io  0x0000-0x001f]
>> [    0.654370] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
>> [    0.654586] pci_root PNP0A03:00: address space collision: host bridge window [mem 0x000a0000-0x000bffff] conflicts with reserved [mem 0x000a0000-0x000fffff]
>> [    0.654933] pci_root PNP0A03:00: address space collision: host bridge window [mem 0x000c0000-0x000effff] conflicts with reserved [mem 0x000a0000-0x000fffff]
>> [    0.655002] pci_root PNP0A03:00: address space collision: host bridge window [mem 0x000f0000-0x000fffff] conflicts with reserved [mem 0x000a0000-0x000fffff]
>> [    0.655367] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
>> [    0.655706] pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
>> [    0.656003] pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
>> [    0.656360] pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
>> [    0.657002] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
>>
>> still not optimal.
> 
> Well, thanks for looking at it; if there are any more patches I can try,
> let me know (but I may not get to it until Monday morning, since I can't
> reliably reboot this machine remotely).
> 
> Is this a BIOS error?  I am currently running A04; there's an A10
> available, but I didn't want to perturb the situation during the
> debugging cycle without guidance.

thanks.

please use this one replace second patch
[PATCH] x86,pci, acpi: Inherent BUSY flag when setup_resource for root bus

So make pci root resource from _CRS honor the range We reserve in e820 below 1M

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/acpi.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -175,6 +175,10 @@ setup_resource(struct acpi_resource *acp
 			"conflicts with %s %pR\n",
 			res, conflict->name, conflict);
 	} else {
+		/* In case it falls in big reserved region */
+		if (res->parent->flags & IORESOURCE_BUSY)
+			res->flags |= IORESOURCE_BUSY;
+
 		pci_bus_add_resource(info->bus, res, 0);
 		info->res_num++;
 		if (addr.translation_offset)
