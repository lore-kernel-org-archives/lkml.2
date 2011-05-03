Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab1ECVT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:19:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:53895 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab1ECVT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:19:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,310,1301900400"; 
   d="scan'208";a="917358059"
Message-ID: <4DC027CA.5000606@intel.com>
Date: Tue, 03 May 2011 09:05:30 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?UTF-8?B?5bq35YmR5paM?= <kjbmail@gmail.com>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Can I/OAT DMA engineer access PCI MMIO space
References: <4DBA8F30.2060206@gmail.com> <1304316260.1589.2.camel@vkoul-udesk3> <4DBF66C0.9020600@gmail.com>
In-Reply-To: <4DBF66C0.9020600@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/2011 7:21 PM, 康剑斌 wrote:
>
>>> I try to use ioatdam to copy data from system memory to pci MMIO space:
>>> If dst points to a memory space, the operation would pass.
>>> But if dst points to a pci MMIO space, it failed with kernel oops.
>>> It seems the code:
>>> BUG_ON(is_ioat_bug(chanerr));
>>> in drivers/dma/ioat/dma_v3.c, line 365 cause the oops.
>>> Is there anyway to access pci MMIO space using ioat?
>>> The datasheet says that ioat supports MMIO access.
>> Did you map the IO memory in kernel using ioremap and friends first?
>>
> yes, I had used 'ioremap_nocache' to map the IO memory and I can use
> memcpy to copy data to this region. The async_tx should have been
> correctly configured as
> I can use aync_memcpy to copy data between different system memory address.
>

ioremap maps mmio space for the cpu not bus mastering devices.  You need 
to program the physical address into the descriptor.

--
Dan
