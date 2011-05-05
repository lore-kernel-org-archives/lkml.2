Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab1EEPLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:11:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:39171 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab1EEPLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:11:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,319,1301900400"; 
   d="scan'208";a="638512024"
Message-ID: <4DC2BE12.7030308@intel.com>
Date: Thu, 05 May 2011 08:11:14 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?UTF-8?B?5bq35YmR5paM?= <kjbmail@gmail.com>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>
Subject: Re: Can I/OAT DMA engineer access PCI MMIO space
References: <4DBA8F30.2060206@gmail.com>	 <1304316260.1589.2.camel@vkoul-udesk3>  <4DBF66C0.9020600@gmail.com> <1304395926.1589.27.camel@vkoul-udesk3> <4DBFA152.8000709@gmail.com> <4DC02622.90000@intel.com> <4DC263C6.1040805@gmail.com>
In-Reply-To: <4DC263C6.1040805@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding Dave ]

On 5/5/2011 1:45 AM, 康剑斌 wrote:
> Thanks.
> I directly read pci bar address and program it into descriptors, ioatdma
> works.
> Some problem is, when PCI transfer failed (Using a NTB connect to
> another system, and the system power down),
> ioatdma will cause kernel oops.
>
> BUG_ON(is_ioat_bug(chanerr));
> in drivers/dma/ioat/dma_v3.c, line 365
>
> It seems that HW reports a 'IOAT_CHANERR_DEST_ADDR_ERR', and drivers
> can't recover from this situation.

Ah ok, this is expected with the current upstream ioatdma driver.  The 
driver assumes that all transfers are mem-to-mem (ASYNC_TX_DMA or 
NET_DMA) and that a destination address error is a fatal error (similar 
to a kernel page fault).

With NTB, where failures are expected, the driver would need to be 
modified to expect the error, recover from it, and report it to the 
application.

> What does dma-slave mean? Just like DMA_SLAVE flag existing in other DMA
> drivers?

Yes, DMA_SLAVE is the generic framework to associate a dma offload 
device with an mmio peripheral.

--
Dan
