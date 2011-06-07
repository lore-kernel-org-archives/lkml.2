Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab1FGWTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:19:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29362 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab1FGWTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:19:44 -0400
Message-ID: <4DEEA3CD.30507@kernel.org>
Date: Tue, 07 Jun 2011 15:18:53 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oliver Hartkopp <socketcan@hartkopp.net>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Chris Ball <cjb@laptop.org>,
        "S\, Venkatraman" <svenkatr@ti.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: sdhci-pci fails on 3.0.0-rc1 on Dell E6510
References: <4DEBCA3F.8050205@hartkopp.net>	<BANLkTin_WHuy5MExNBHdeLiDmdmn7SZYkg@mail.gmail.com>	<4DED05C4.7050903@hartkopp.net> <m3hb82wx6m.fsf@pullcord.laptop.org> <4DEE6FC6.9040308@hartkopp.net> <4DEE84AD.6050104@hartkopp.net>
In-Reply-To: <4DEE84AD.6050104@hartkopp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4DEEA3D6.0193,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks.

second report.

can you send out whole boot log.

Yinghai

On 06/07/2011 01:06 PM, Oliver Hartkopp wrote:
> On 07.06.2011 20:36, Oliver Hartkopp wrote:
> Hi all,
> 
> the commit "PCI: update bridge resources to get more big ranges when allocating space (again)"
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=da7822e5ad71ec9b745b412639f1e5e0ba795a20
> 
> kills my SD-Card and the PCMCIA slot on a Dell E6510 with the latest 3.0.0-rc2 ...
> 
> When i revert the commit both the MMC/SD stuff and the PCMCIA re-appears.
> 
> Any idea?
> 
> See my attached boot.diff / kernel config 
> 
> Regards,
> Oliver
> 
> 
> 
> 
>> On 06.06.2011 21:56, Chris Ball wrote:
>>> Hi Oliver,
>>>
>>> On Mon, Jun 06 2011, Oliver Hartkopp wrote:
>>>>>> dmesg is a bit more detailed:
>>>>>> [    6.242510] sdhci-pci 0000:03:00.1: SDHCI controller found [1180:e822] (rev 3)
>>>>>> [    6.244168] sdhci-pci 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>>>>>> [    6.245788] sdhci-pci 0000:03:00.1: BAR 0 is not iomem. Aborting.
>>>>>> [    6.247609] sdhci-pci 0000:03:00.1: PCI INT B disabled
>>>
>>> If you get a chance to do some bisecting, that would be extremely
>>> helpful -- even just building 3.0 from *before* the MMC tree was
>>> merged would help a lot, since if the problem still happens before
>>> the MMC merge we might be looking at some kind of generic PCI bug.
>>>
>>
>>
>> Hi Chris,
>>
>> i just reverted this pull of your merge window patches in my 3.0.0-rc2 tree:
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8c1c77ff9be27137fa7cbbf51efedef1a2ae915b;hp=f3ae1c75203535f65448517e46c8dd70a56b6c71
>>
>> And you were right: The problem still exists. So it might be from the PCI subsystem :-(
>>
>> [    6.167106] sdhci: Secure Digital Host Controller Interface driver
>> [    6.167108] sdhci: Copyright(c) Pierre Ossman
>> [    6.194731] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
>> [    6.195140] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf6970000
>> [    6.196423] sdhci-pci 0000:03:00.1: SDHCI controller found [1180:e822] (rev 3)
>> [    6.196429] sdhci-pci 0000:03:00.1: found 1 slot(s)
>> [    6.196447] sdhci-pci 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>> [    6.196451] sdhci-pci 0000:03:00.1: BAR 0 is not iomem. Aborting.
>> [    6.196459] sdhci-pci 0000:03:00.1: PCI INT B disabled
>>
>> Well then, i'll reset my tree and look for differences in the PCI boot messages.
>>
>> Thanks,
>> Oliver
> 

