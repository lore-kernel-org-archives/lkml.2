Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0CRXja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 19:39:30 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:58627 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab0CRXj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 19:39:27 -0400
Message-ID: <4BA2B94E.4070309@oracle.com>
Date: Thu, 18 Mar 2010 16:37:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] drivers/pci/pci.c Section mismatch
References: <4BA2A46E.5090008@googlemail.com> <4BA2B028.8060705@oracle.com> <4BA2B87E.8050404@googlemail.com>
In-Reply-To: <4BA2B87E.8050404@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BA2B9AA.0096:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/10 16:34, René Bolldorf wrote:
> On 03/18/10 23:58, Randy Dunlap wrote:
>> On 03/18/10 15:08, Ren� Bolldorf wrote:
>>> Signed-off-by: Rene Bolldorf<xsecute@googlemail.com>
>>>
>>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>>> index ddd55dc..a1f7d93 100644
>>> --- a/drivers/pci/pci.c
>>> +++ b/drivers/pci/pci.c
>>> @@ -2773,7 +2773,7 @@ int pci_resource_bar(struct pci_dev *dev, int
>>> resno, enum pci_bar_type *type)
>>>   /* Some architectures require additional programming to enable VGA */
>>>   static arch_set_vga_state_t arch_set_vga_state;
>>>
>>> -void __init pci_register_set_vga_state(arch_set_vga_state_t func)
>>> +void pci_register_set_vga_state(arch_set_vga_state_t func)
>>>   {
>>>       arch_set_vga_state = func;    /* NULL disables */
>>>   }
>>> -- 
>>
>> Hi,
>>
>> Please put the offending/warning messages in the patch description.
>> Include your analysis if it isn't obvious.
>>
>> thanks,
> 
> Hi,
> 
> the warning message was:
> WARNING: drivers/pci/built-in.o(__ksymtab+0x190): Section mismatch in
> reference from the variable __ksymtab_pci_register_set_vga_state to the
> function .init.text:pci_register_set_vga_state()
> The symbol pci_register_set_vga_state is exported and annotated __init
> Fix this by removing the __init annotation of pci_register_set_vga_state
> or drop the export.
> 
> $fgrep "pci_register_set_vga_state" `find .`
> 
> $./arch/x86/kernel/apic/x2apic_uv_x.c:
> pci_register_set_vga_state(uv_set_vga_state);
> $./include/linux/pci.h:extern void
> pci_register_set_vga_state(arch_set_vga_state_t func);
> $./drivers/pci/pci.c:void
> pci_register_set_vga_state(arch_set_vga_state_t func)
> $./drivers/pci/pci.c:EXPORT_SYMBOL(pci_register_set_vga_state);
> 
> this is a volatile function that set's a spec. state and is only used
> from uv_system_init(arch/x86/kernel/apic/x2apic_uv_x.c), the macro can
> also be removed.

Thanks.  Yes, we shouldn't export __init functions, so the patch makes
sense.

BTW, you need to cc: one or more maintainers so that someone will merge
your patches.  They don't scan the mailing lists looking for patches to merge.


-- 
~Randy
