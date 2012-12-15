Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab2LOWRF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 17:17:05 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:45984 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2LOWRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 17:17:02 -0500
Message-ID: <50CCF6DB.7080204@gmail.com>
Date: Sat, 15 Dec 2012 16:16:59 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Don Dutile <ddutile@redhat.com>
CC: Jason Gao <pkill.2012@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Subject: Re: DMAR and DRHD errors[DMAR:[fault reason 06] PTE Read access is
 not set] Vt-d & intel_iommu
References: <CANmqhJAuLoi_Y2Hsz+UnddHXYd9TCW-7qxp3fybDayfh33Y3Zg@mail.gmail.com> <50CB9ADC.2020103@redhat.com>
In-Reply-To: <50CB9ADC.2020103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 03:32 PM, Don Dutile wrote:
> On 12/13/2012 04:50 AM, Jason Gao wrote:
>> Dear List:
>>
>> Description of problem:
>> After installed Centos 6.3(RHEL6.3) on my Dell R710(lastest
>> bios:Version: 6.3.0,Release Date: 07/24/2012) server,and updated
>> lastest kernel "2.6.32-279.14.1.el6.x86_64",I want to use the Intel
>> 82576 ET Dual Port nic's SR-IOV feature,assigning VFs to kvm guest
>>
>> appended kernel boot parameter: intel_iommu=on,after boot with the
>> following messages:
>>
>> Dec 13 16:58:15 2 kernel: DRHD: handling fault status reg 2
>> Dec 13 16:58:15 2 kernel: DMAR:[DMA Read] Request device [03:00.0]
>> fault addr ffe65000
>> Dec 13 16:58:15 2 kernel: DMAR:[fault reason 06] PTE Read access is
>> not set
>> Dec 13 16:58:15 2 kernel: DRHD: handling fault status reg 102
>> Dec 13 16:58:15 2 kernel: DMAR:[DMA Read] Request device [03:00.0]
>> fault addr ffe8a000
>> Dec 13 16:58:15 2 kernel: DMAR:[fault reason 06] PTE Read access is
>> not set
>> Dec 13 16:58:15 2 kernel: scsi 0:0:32:0: Enclosure         DP
>> BACKPLANE        1.07 PQ: 0 ANSI: 5
>> Dec 13 16:58:15 2 kernel: DRHD: handling fault status reg 202
>> Dec 13 16:58:15 2 kernel: DMAR:[DMA Read] Request device [03:00.0]
>> fault addr ffe89000
>> Dec 13 16:58:15 2 kernel: DMAR:[fault reason 06] PTE Read access is
>> not set
>>
>> full dmesg detail:
>>     http://pastebin.com/BzFQV0jU
>> lspci -vvv full detail:
>>     http://pastebin.com/9rP2d1br
>>
>>
>> it's a production server,and I'm not sure if this is a critical
>> problem,how to fix it,any help would be greatly appreciated.
>
> DMAR table does not have an entry for this device to this region.
> Once the driver reconfigs/resets the device to stop polling bios-boot
> cmd rings and use (new) OS (dma-mapped) rings, there's a period of time
> during this transition that the hw is babbling away to an area that is no
> longer mapped.

Maybe some kind of boot PCI quirk is needed to stop the device DMA 
activity before enabling the IOMMU?

