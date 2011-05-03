Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1ECP61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:58:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:62950 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab1ECP60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:58:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,310,1301900400"; 
   d="scan'208";a="917355963"
Message-ID: <4DC02622.90000@intel.com>
Date: Tue, 03 May 2011 08:58:26 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: =?UTF-8?B?5bq35YmR5paM?= <kjbmail@gmail.com>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Can I/OAT DMA engineer access PCI MMIO space
References: <4DBA8F30.2060206@gmail.com>	 <1304316260.1589.2.camel@vkoul-udesk3>  <4DBF66C0.9020600@gmail.com> <1304395926.1589.27.camel@vkoul-udesk3> <4DBFA152.8000709@gmail.com>
In-Reply-To: <4DBFA152.8000709@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/2011 11:31 PM, 康剑斌 wrote:
>
>>> yes, I had used 'ioremap_nocache' to map the IO memory and I can use
>>> memcpy to copy data to this region. The async_tx should have been
>>> correctly configured as
>>> I can use aync_memcpy to copy data between different system memory address.
>> Then you should be using memcpy_toio() and friends
>>
> Do you mean that if I have mapped the mmio, I can' use I/OAT dma
> transfer to this region any more?
> I can use memcpy to copy data, but it consumes lots of cpu as PCI access
> is too slow.
> If I can use i/oat dma and asyc_tx api to do the job, the performance
> should be imporved.
> Thanks

The async_tx api only supports memory-to-memory transfers.  To write to 
mmio space with ioatdma you would need a custom method, like the 
dma-slave support in other drivers, to program the descriptors with the 
physical mmio bus address.

--
Dan
