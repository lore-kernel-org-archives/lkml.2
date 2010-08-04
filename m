Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab0HDLWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 07:22:46 -0400
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:52981 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932201Ab0HDLWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 07:22:44 -0400
X-Greylist: delayed 6969 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 07:22:44 EDT
Message-ID: <4C594D78.6090407@cyconix.com>
Date: Wed, 04 Aug 2010 12:22:32 +0100
From: Evan Lavelle <sa212+lkml@cyconix.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Driver: PCIe: 'pci_map_sg' returning invalid bus address?
References: <4C5002AD.6070206@cyconix.com>	<4C593245.5070303@cyconix.com> <20100804190808D.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100804190808D.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.70.243.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>> Made some progress here. The problem is that this is 32-bit PAE kernel, 
>> so 'dma_addr_t' is 64-bit. However, I have a 32-bit PCIe card, so I need 
>> a 32-bit dma_addr_t. How do I do this? In other words, how do I handle 
>> 32-bit PCI cards on PAE or 64-bit systems? My code sets the DMA mask to 
>> 32 bits but this is *not* sufficient:
>>
>> pci_set_dma_mask(my_dev, DMA_32BIT_MASK)
> 
> It doesn't work on x86_32 kernel if your driver doesn't work with the
> block layer or the network subsystem.

Sorry, not sure that I understand this. Are you saying that I can't set 
a DMA mask on x86_32 unless I have a block or network driver?

> If your driver can't handle 64bit DMA, you need bounce buffer. 

The problem is not that I can't handle 64-bit DMA in the driver, but 
that the PCI card can't do 64-bit DMA. I tell the kernel this by calling 
'pci_set_dma_mask' with a 32-bit mask, but it appears to be ignoring my 
request and then giving me a 64-bit dma_addr_t for the 32-bit PCI card.

Thanks -

Evan
