Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2LQQ2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:28:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276Ab2LQQ2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:28:01 -0500
Message-ID: <50CF480F.4060804@redhat.com>
Date: Mon, 17 Dec 2012 11:27:59 -0500
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Jason Gao <pkill.2012@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        kvm <kvm@vger.kernel.org>
Subject: Re: DMAR and DRHD errors[DMAR:[fault reason 06] PTE Read access is
 not set] Vt-d & intel_iommu
References: <CANmqhJAuLoi_Y2Hsz+UnddHXYd9TCW-7qxp3fybDayfh33Y3Zg@mail.gmail.com> <50CB9ADC.2020103@redhat.com> <50CCF6DB.7080204@gmail.com>
In-Reply-To: <50CCF6DB.7080204@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2012 05:16 PM, Robert Hancock wrote:
> On 12/14/2012 03:32 PM, Don Dutile wrote:
>> On 12/13/2012 04:50 AM, Jason Gao wrote:
>>> Dear List:
>>>
>>> Description of problem:
>>> After installed Centos 6.3(RHEL6.3) on my Dell R710(lastest
>>> bios:Version: 6.3.0,Release Date: 07/24/2012) server,and updated
>>> lastest kernel "2.6.32-279.14.1.el6.x86_64",I want to use the Intel
>>> 82576 ET Dual Port nic's SR-IOV feature,assigning VFs to kvm guest
>>>
>>> appended kernel boot parameter: intel_iommu=on,after boot with the
>>> following messages:
>>>
>>> Dec 13 16:58:15 2 kernel: DRHD: handling fault status reg 2
>>> Dec 13 16:58:15 2 kernel: DMAR:[DMA Read] Request device [03:00.0]
>>> fault addr ffe65000
>>> Dec 13 16:58:15 2 kernel: DMAR:[fault reason 06] PTE Read access is
>>> not set
>>> Dec 13 16:58:15 2 kernel: DRHD: handling fault status reg 102
>>> Dec 13 16:58:15 2 kernel: DMAR:[DMA Read] Request device [03:00.0]
>>> fault addr ffe8a000
>>> Dec 13 16:58:15 2 kernel: DMAR:[fault reason 06] PTE Read access is
>>> not set
>>> Dec 13 16:58:15 2 kernel: scsi 0:0:32:0: Enclosure DP
>>> BACKPLANE 1.07 PQ: 0 ANSI: 5
>>> Dec 13 16:58:15 2 kernel: DRHD: handling fault status reg 202
>>> Dec 13 16:58:15 2 kernel: DMAR:[DMA Read] Request device [03:00.0]
>>> fault addr ffe89000
>>> Dec 13 16:58:15 2 kernel: DMAR:[fault reason 06] PTE Read access is
>>> not set
>>>
>>> full dmesg detail:
>>> http://pastebin.com/BzFQV0jU
>>> lspci -vvv full detail:
>>> http://pastebin.com/9rP2d1br
>>>
>>>
>>> it's a production server,and I'm not sure if this is a critical
>>> problem,how to fix it,any help would be greatly appreciated.
>>
>> DMAR table does not have an entry for this device to this region.
>> Once the driver reconfigs/resets the device to stop polling bios-boot
>> cmd rings and use (new) OS (dma-mapped) rings, there's a period of time
>> during this transition that the hw is babbling away to an area that is no
>> longer mapped.
>
> Maybe some kind of boot PCI quirk is needed to stop the device DMA activity before enabling the IOMMU?
>
No, lack of a *proper* RMRR for this device is the source of the problem;
that's why the RMRR's exist -- so this transition state does not cause these
types of problems.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

