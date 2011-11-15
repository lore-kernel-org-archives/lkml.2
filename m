Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab1KOGfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 01:35:01 -0500
Received: from mail2.unitix.de ([176.9.2.175]:48789 "EHLO mail2.unitix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab1KOGfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 01:35:00 -0500
Message-ID: <4EC20805.5070403@arndnet.de>
Date: Tue, 15 Nov 2011 07:34:45 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org
Subject: Re: 3.2rc1: bootup fails: DRHD: handling fault status reg 2
References: <4EC19738.8050007@arndnet.de> <4EC1B80D.5000102@arndnet.de> <20111115043634.GA30247@sequoia.sous-sol.org>
In-Reply-To: <20111115043634.GA30247@sequoia.sous-sol.org>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.11.2011 05:36, schrieb Chris Wright:
> * Arnd Hannemann (arnd@arndnet.de) wrote:
>> Am 14.11.2011 23:33, schrieb Arnd Hannemann:
>>> when trying to boot kernel 3.2rc1 on my thinkpad t510 I get an endless loop of errors:
>>>
>>>  DRHD: handling fault status reg 2
>>>  DMAR: [DMA Read] Request device [0d:00.0] fault addr fffff000
>>>  DMAR: [fault reason 02] Present bit in context entry is clear
>>>
>>> screenshot can be found here:
>>> http://arndnet.de/lkml/screenshot3.2rc1.jpg
>>>
>>> kernel 3.1.1 is booting up flawlessly.
>>
>> I must have inadvertently enabled CONFIG_INTEL_IOMMU_DEFAULT_ON in my config
>> for 3.2-rc1.
>>
>> With disabled CONFIG_INTEL_IOMMU_DEFAULT_ON my thinkpad boots up again.
>> Not sure if this is expected?
> 
> With CONFIG_INTEL_IOMMU_DEFAULT_ON=n, you have to manually enabled the
> IOMMU on the kernel commandline.  So, yes, disabling that and having
> your laptop boot is not surprising.  The Kconfig item changed names,
> and the default is yes, so you may have had CONFIG_DMAR_DEFAULT_ON=n,
> but this would not have propagated forward.
> 
> As for the endless loop of DMAR faults...sounds like the Ricoh
> cardbus/firewire issue where the firewire fucntion does DMA from
> function 0.  I thought this was quirked and fixed though.

In this case it seems to be
0d:00.0 SD Host controller: Ricoh Co Ltd MMC/SD Host Controller (rev 01)
(using sdhci-pci)
The Fireware function seems to be at a different address:
0d:00.3 FireWire (IEEE 1394): Ricoh Co Ltd FireWire Host Controller (rev 01) (prog-if 10 [OHCI])

Maybe another quirk is needed? Where does this need to be fixed?
I suppose sdhci-pci.ko is loaded much later on bootup.

Best regards
Arnd
