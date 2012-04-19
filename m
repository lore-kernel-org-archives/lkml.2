Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2DSRcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:32:11 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:37503 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753345Ab2DSRcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:32:10 -0400
Message-ID: <4F904C17.6010705@fold.natur.cuni.cz>
Date: Thu, 19 Apr 2012 19:32:07 +0200
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120319 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-pci@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.11: PCI Express card cannot be re-detected withing cca 60sec
 timeframe
References: <4F6A483D.50702@fold.natur.cuni.cz> <4F6A5A53.305@fold.natur.cuni.cz> <CAE9FiQXP7fO9OGN557jdofFFiFj96wL--ZA8X3UPEJ6o9JLvBw@mail.gmail.com> <4F8BEB1D.9080903@fold.natur.cuni.cz> <CAE9FiQXoX3J6P_9Tun_XbkK3egvSeBZxAtC13HacFDO0fwmZaA@mail.gmail.com> <4F8C6E4E.1000205@fold.natur.cuni.cz> <CAE9FiQXikqikMw_LYGqAUsWqFqL-tLiresPhpkpDhb+AxwundQ@mail.gmail.com> <CAE9FiQUFB=9zbP1yuBDH1RJrCCP=83kV_fH+TEtk80981-uP=w@mail.gmail.com> <CAE9FiQUbzM_TVu+bbXa6LWiUt01QsFiGoyYd0qV=41dXx4J31g@mail.gmail.com> <4F8D1B72.2000105@fold.natur.cuni.cz> <CAE9FiQW2MAW_WT+sq8XVtMOx=uR8FAN8O2wL2AOxkFBfEM285g@mail.gmail.com> <CAE9FiQWSw1h772ijZ6YL4EujwjgvZ84bbDx9VbF_cdE63D-41w@mail.gmail.com> <4F8D390F.9050408@fold.natur.cuni.cz> <CAE9FiQU-_BCCS1OKagVuj8YNrut8-6GH2_i86FsfS8UDWQ1pRA@mail.gmail.com> <CAE9FiQUxoHvUWFXv5LLcBT9vVGnQKp1-Tg7M3XPPULWwtX1iUw@mail.gmail.com> <4F8EFFA3.3050705@fold.natur.cuni.cz> <CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com>
In-Reply-To: <CAE9FiQVcJbPub1O6nwyNsiijHFpHN0jMsGO4MmKugybPL7Wnug@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yinghai Lu wrote:
> On Wed, Apr 18, 2012 at 10:53 AM, Martin Mokrejs
> <mmokrejs@fold.natur.cuni.cz> wrote:
>>> After you remove USB3 expresscard, you need to
>>>
>>> echo 1 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>> then
>>> echo 0 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>
>> So without these two echo commands the is no improvement/fix.
>>
>> [  686.701306] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
>> [  686.701316] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
>> [  686.701319] pciehp 0000:00:1c.7:pcie04: Card present on Slot(7)
>> [  686.701357] pciehp 0000:00:1c.7:pcie04: Surprise Removal
>> [  686.701390] pciehp 0000:00:1c.7:pcie04: check_link_active: lnk_status = 7011
>> [  686.809763] pciehp 0000:00:1c.7:pcie04: pciehp_check_link_status: lnk_status = 7011
> ...
>> [  686.833678] hub 6-0:1.0: 2 ports detected
>>
>> echo 1 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>
>> [  716.999938] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 53
>> [  717.024647] pciehp 0000:00:1c.7:pcie04: pcie_isr: intr_loc 8
>> [  717.024657] pciehp 0000:00:1c.7:pcie04: Presence/Notify input change
>> [  717.024665] pciehp 0000:00:1c.7:pcie04: Card not present on Slot(7)
>> [  717.024723] pciehp 0000:00:1c.7:pcie04: Surprise Removal
>> [  717.024753] pciehp 0000:00:1c.7:pcie04: Disabling domain:bus:device=0000:11:00
>> [  717.024756] pciehp 0000:00:1c.7:pcie04: pciehp_unconfigure_device: domain:bus:dev = 0000:11:00
> ..
>> [  717.045197] pci 0000:11:00.0: freeing pci_dev info
>>
>> echo 0 > /sys/devices/pci0000\:00/0000\:00\:1c.7/pcie_link_disable
>>
>> [  748.456914] pcieport 0000:00:1c.7: pcie_link_disable_set: lnk_ctrl = 40
>>
> 
> so it is chipset problem, it does not detect and report the presence
> of the card after that link is removed.



Hi Yinghai,
  this brought me to and issue with "Intel® 6 Series Express Chipset B2 stepping" chips
having enabled SATA ports 2-5. This is my case:

[    3.037832] ahci 0000:00:1f.2: version 3.0
[    3.037880] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    3.037906] ahci: SSS flag set, parallel bus scan disabled
[    3.048233] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x31 impl SATA mode
[    3.048335] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
[    3.048371] ahci 0000:00:1f.2: setting latency timer to 64
[    3.088902] scsi0 : ahci
[    3.089010] scsi1 : ahci
[    3.089098] scsi2 : ahci
[    3.089185] scsi3 : ahci
[    3.089272] scsi4 : ahci
[    3.089361] scsi5 : ahci
[    3.090528] ata1: SATA max UDMA/133 abar m2048@0xf7f06000 port 0xf7f06100 irq 44
[    3.091400] ata2: DUMMY
[    3.092262] ata3: DUMMY
[    3.093112] ata4: DUMMY
[    3.093952] ata5: SATA max UDMA/133 abar m2048@0xf7f06000 port 0xf7f06300 irq 44
[    3.094803] ata6: SATA max UDMA/133 abar m2048@0xf7f06000 port 0xf7f06380 irq 44


Is this bug anyhow related to this already known chipset issue?

http://support.dell.com/support/topics/global.aspx/support/kcs/document?c=us&cs=04&docid=389728&l=en&s=bsd
http://www.intel.com/support/chipsets/6/sb/CS-032521.htm
http://www.intel.com/support/chipsets/6/sb/CS-032521.htm

> 


So you found two issues, right?

Issue 1:

Yinghai Lu wrote:
> for USB 3.0:
> 		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
> 			Changed: MRL- PresDet- LinkState+
> 
> PresDet+: mean that card is still there. so no interrupt is generated
> by chipset.
> 
> that present bit is decide by by inband link or out of band.
> 
> sometimes when out of band pres is no, present bit could be keep flip
> around because in root port try to retrain to detect ...
> but it is not the case.
> 
> the pin "CPPE#  PCI Express interface presence detect" should get into
> hotplug FPGA in motherboard.
> 
> You may need to check with vendor about if there is any problem with
> that hotplug FPGA.


Issue 2:
>>> Can you try to use acpiphp instead of pciehp?
> 
> looks your BIOS does not support acpiphp.
> 
> Maybe you have to stay with
> 
> echo 1  > .../pcie_link_disable
> echo 0  > .../pcie_link_disable
> 
> after removal every time.
>  
> Yinghai

Does it make sense to report this to Dell (that it does not support ACPI hotplug)?
Can they fix it with BIOS or whatever? Thay will anyways replace my motherboard
in the laptop if my system is really affected.

Can I just return the thing after 2.5 months completely?

Thanks,
Martin
