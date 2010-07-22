Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab0GVWAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:00:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:65065 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab0GVWAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:00:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,245,1278313200"; 
   d="scan'208";a="537957413"
Message-ID: <4C48BF90.3050100@intel.com>
Date: Thu, 22 Jul 2010 15:00:48 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Chris Li <lkml@chrisli.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>	<1277965264.18854.16.camel@localhost>	<4C2C3B07.7050200@intel.com>	<1277968336.4945.3.camel@localhost>	<4C2C4319.6090906@intel.com>	<1277972137.12558.2.camel@localhost>	<4C2CCE67.6070600@intel.com>	<AANLkTimeNp4mMI-6IEl-zlv1DcFF5SyAD4k5O3ZLuCwM@mail.gmail.com>	<AANLkTimNPP00pJewLtlk0SJQYjGUCyBWoxzGbTYltGsM@mail.gmail.com>	<1278324973.16975.68.camel@localhost>	<AANLkTimToKAxKLyONyk7KP4WXCS_FpjRjr1yWB3GCaQk@mail.gmail.com>	<1278463901.20082.34.camel@dwillia2-linux>	<1278474039.31393.8.camel@localhost>	<4C34BDCD.9080607@intel.com>	<AANLkTild7PCKygpPAJRo2G237CY8wJyveM9_Glx8qmoK@mail.gmail.com>	<4C379462.1020704@intel.com>	<1278720554.9522.18.camel@localhost>	<4C3E9F6E.1030508@intel.com>	<1279318325.27733.21.camel@macbook.infradead.org>	<AANLkTik80zwMaRYglVt2V3AuXiN90mgovIB3i67teVOL@mail.gmail.com>	<4C479BB1.8020102@intel.com> <AANLkTilmz73V7cc2UiGNUgU9cANzX8u5QP232DcbxGxR@mail.gmail.com>
In-Reply-To: <AANLkTilmz73V7cc2UiGNUgU9cANzX8u5QP232DcbxGxR@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/2010 2:39 PM, Chris Li wrote:
> On Wed, Jul 21, 2010 at 6:15 PM, Dan Williams<dan.j.williams@intel.com>  wrote:
>>
>> Here is v5 with the aforementioned change.
>
> One warning.
>
> CC      drivers/pci/intel-iommu.o
> drivers/pci/intel-iommu.c: In function ‘quirk_ioat_snb_local_iommu’:
> drivers/pci/intel-iommu.c:3037: warning: unused variable ‘i’

Oops, I'll clean that up.

> The dmesg looks good.
>
[..]
> dca service started, version 1.12.1
> ioatdma: Intel(R) QuickData Technology Driver 4.00
> ioatdma 0000:00:0f.0: can't derive routing for PCI INT A
> ioatdma 0000:00:0f.0: PCI INT A: no GSI
> ------------[ cut here ]------------
> WARNING: at drivers/pci/intel-iommu.c:3056
> quirk_ioat_snb_local_iommu+0xae/0xc7()
> Hardware name: MacPro3,1
> BIOS assigned incorrect VT-d unit for Intel(R) QuickData Technology device
[..]
> ---[ end trace c7f418b83f8ca665 ]---
> Disabling lock debugging due to kernel taint
> ioatdma 0000:00:0f.0: setting latency timer to 64
>    alloc irq_desc for 57 on node -1
>    alloc kstat_irqs on node -1
> ioatdma 0000:00:0f.0: irq 57 for MSI/MSI-X
>    alloc irq_desc for 58 on node -1
>    alloc kstat_irqs on node -1
> ioatdma 0000:00:0f.0: irq 58 for MSI/MSI-X
>    alloc irq_desc for 59 on node -1
>    alloc kstat_irqs on node -1
> ioatdma 0000:00:0f.0: irq 59 for MSI/MSI-X
>    alloc irq_desc for 60 on node -1
>    alloc kstat_irqs on node -1
> ioatdma 0000:00:0f.0: irq 60 for MSI/MSI-X
>

Nice, and the driver was able to load normally.  Thanks for the all the 
testing!

David, I'll take this through my tree as a regression fix (since 2.6.32) 
if you have no objections.  Now that we are not hitting a driver load 
failure I think I'll add a WARN() to this init-fail path.  I doubt we 
would have flushed out this problem had the driver been discretely 
handling init failures since day one.

Regards,
Dan
