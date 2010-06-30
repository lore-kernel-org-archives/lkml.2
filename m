Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab0F3Tka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:40:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:54192 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743Ab0F3Tk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:40:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,514,1272870000"; 
   d="scan'208";a="581556033"
Message-ID: <4C2B9DAC.1030806@intel.com>
Date: Wed, 30 Jun 2010 12:40:28 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Woodhouse, David" <david.woodhouse@intel.com>
CC: Chris Li <lkml@chrisli.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>	 <4C29420D.2010406@intel.com>	 <AANLkTikJvUIcx744weazBmOfyZzEu8NgYZ4oaLP2TbZ0@mail.gmail.com>	 <4C2A8879.8010000@intel.com>	 <AANLkTinhbjuyDNYQ_meDpewacApahDoY2z6h956JE2Xj@mail.gmail.com>	 <4C2AC55E.3040303@intel.com>	 <AANLkTimzQHwVYZU73hoV4S3w9Ez43xNUrvdMkEDWCrvF@mail.gmail.com> <1277923422.16256.8.camel@localhost>
In-Reply-To: <1277923422.16256.8.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/2010 11:43 AM, Woodhouse, David wrote:
> On Wed, 2010-06-30 at 19:26 +0100, Chris Li wrote:
>>
>> The delta seems to be this line:
>> ioatdma 0000:00:0f.0: ioat2_set_chainaddr: chainaddr: ffffe000
>
> That's a reasonable address if the IOMMU is enabled. We start at 4GiB
> and work down, so that's the second page given out (or the first 8KiB
> chunk).
>
> It looks like the DMA is going AWOL causing the initialisation to
> fail... but it's interesting that there are no DMA faults reported by
> the IOMMU.
>

It seems the 5400 has a dedicated remapping engine just for the DMA 
device [1], is Linux only setting up the iommus per root port (which the 
DMA bypasses)??

 From the dmesg:
> IOMMU 0: reg_base_addr fe710000 ver 1:0 cap 900000c2f0462 ecap e01
> DMAR: DRHD base: 0x000000fe714000 flags: 0x0
> IOMMU 1: reg_base_addr fe714000 ver 1:0 cap 900000c2f0462 ecap e01
> DMAR: DRHD base: 0x000000fe719000 flags: 0x0
> IOMMU 2: reg_base_addr fe719000 ver 1:0 cap 900000c2f0462 ecap e01
> DMAR: DRHD base: 0x000000fe718000 flags: 0x1
> IOMMU 3: reg_base_addr fe718000 ver 1:0 cap 900000c2f0462 ecap e01

Where we expect bit 54 to be set for the DMA iommu, and it does not 
appear to show up.

--
Dan

[1]: http://www.intel.com/Assets/PDF/datasheet/318610.pdf (Section 
3.11.2 page 256)
