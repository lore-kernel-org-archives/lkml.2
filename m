Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab1JXFAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 01:00:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52970 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1JXFAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 01:00:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4EA4F0D2.3070301@jp.fujitsu.com>
Date: Mon, 24 Oct 2011 14:00:02 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Abdelghani Ouchabane <abdelghani@ezono.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: PCIe can not rescan for new PCIe device ( FPGA board )
References: <4E8EA746.6030103@ezono.com> <CAErSpo6YEp2v9xzVJHsu5WSJDqb+sWZUfS-e7UmGEXENRiWmnQ@mail.gmail.com> <4E8F2758.3040408@ezono.com> <CAErSpo6Lo2bXw=yjscQ6zzRMnpMZ-cUzbBxN3dDS1D3M67sQ8g@mail.gmail.com> <4E939E5D.3010208@jp.fujitsu.com> <4E93FA3D.2030400@ezono.com> <4E953579.6050807@jp.fujitsu.com> <4E95516F.60300@ezono.com> <4E96DE8A.6050404@jp.fujitsu.com> <4E98037C.4000403@ezono.com>
In-Reply-To: <4E98037C.4000403@ezono.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm sorry for the long delay.

(2011/10/14 18:40), Abdelghani Ouchabane wrote:
> On 13/10/11 14:50, Kenji Kaneshige wrote:
>> Thank you for the information. Though I don't have any good news for you,
>> I think as follows based on the info.
>>
>> - There are two hot-plug capable PCIe slots on your machine.
>>
>> - But, it seems you are using fakephp driver, not pciehp (is that
>>    correct?). The fakephp cannot handle hot-plug event such as presence
>>    change event on the slot. This is why the bus is not scanned automatically.
>>
>> - Unfortunately, the bus would not be scanned automatically even if you
>>    use pciehp. As I told you in the previous email, current pciehp don't
>>    scan the bus automatically only if the slot is hot-plug surprise
>>    capable. According to the lspci output, your hotplug controller is not
>>    hot-plug surprise capable.
>>
>> - I don't think pciehp solve invalid register read problem. According to
>>    the lspci output, power controller capability isn't present on your
>>    hotplug controller. On such environment, pciehp driver does almost the
>>    same thing as fakephp does (just scan the bus/remove the pci device data
>>    structure) except hot-plug event handling.
>>
>> But it's worth whole trying pciehp.
>> By the way, have you tried acpiphp? It might help you.
>>
>> Regards,
>> Kenji Kaneshige
>>
> 
> Hallo Kenji,
> 
> many thanks for your great supports. The new BIOS from Congatec solves
> the problem.
> 
> I using both fakephp&  pciehp drivers, Can I use both drivers at the
> same time?

I think, "no".

> I am using fakephp because I need "/sys/bus/pci/slots/0000\:02\:00.0/power".
> 
> Other thing: my Kernel has "CONFIG_ACPI_PROC_EVENT is not set", does
> this explain why the scan is not performed automatically?

Fakephp driver doesn't have any corresponding hotplug controller (hardware).
So I don't think there is no way to detect presence change event on the slot.

> 
> [root@localhost ~]# modprobe acpiphp
> FATAL: Error inserting acpiphp
> (/lib/modules/2.6.40.3-0.119.delos.i686/kernel/drivers/pci/hotplug/acpiphp.ko):
> No such device
> 
> What is the advantage to use acpiphp ?

Some platform only allows acpiphp, but doesn't allow PCIe native hotplug driver
(like pciehp). The 'pciehp_force' specified your environment is to load pciehp
forcibly on such platform. So I thought acpiphp might solve your problem.

Regards,
Kenji Kaneshige



> 
> 
> Cheers,
> Ghani
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

