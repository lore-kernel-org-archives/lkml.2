Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801Ab0GOQq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:46:59 -0400
Received: from mta-mad.optenet.com ([130.117.93.253]:52252 "EHLO
	mta-mad.optenet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755Ab0GOQq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:46:58 -0400
Date: Thu, 15 Jul 2010 18:46:58 +0200 (CEST)
From: Unai Uribarri <unai.uribarri@optenet.com>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org
Message-ID: <8797187.74161279212418339.JavaMail.root@mail1-md.optenet.com>
In-Reply-To: <201007151309.14915.mitov@issp.bas.bg>
Subject: Re: Workaround hardware bug addressing physical memory
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.3.29]
X-Mailer: Zimbra 5.0.11_GA_2695.UBUNTU8 (ZimbraWebClient - FF3.0 (Linux)/5.0.11_GA_2695.UBUNTU8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Marin Mitov" <mitov@issp.bas.bg> wrote:

| On 15.7.2010, Unai Uribarri wrote:
| > Thanks.
| > ----- "Marin Mitov" <mitov@issp.bas.bg> wrote:
| > 
| > | On Wednesday, July 14, 2010 08:06:49 pm you wrote:
| > | > ----- "Marin Mitov" <mitov@issp.bas.bg> wrote:
| > | > 
| > | > | Hi,
| > | > | 
| > | > | This is pci driver. You can set dma mask:
| > | > | 
| > | > | dma_set_coheren_mask(pdev, DMA_BIT_MASK(31)) 
| > | > | 
| > | > | All further alloc_coherent() should be from the region 0-2GB.
| > | > | 
| > | > 
| > | > But I'm using a 64 bit operating system with 32GB of RAM. It's
| a
| > | > pity to be unable to use 4GB-32GB range because the 2-4GB range
| is
| > | > unusable. So I've written this code to skip invalid areas. Do
| you
| > | > think this code could be useful for other drivers?
| > | 
| > | Let me summarize if I have correctly understood what you do.
| > | 
| > | First, your hardware has problems when the physical (bus) address
| > | is out of the 0-2GB region, so you cannot use buffers that are out
| 
| > | of this range in any case. And the defect is in the peripheral,
| not in
| > | the bridge between it and the memory.
| > 
| > The hardware works correctly for physical address in the ranges 0 to
| 2GB
| > AND 4GB to 32GB. Physical address in the 2-4GB range are read
| correctly
| > by the device. But when the device tries to write to them it issues
| 
| > invalid PCIe transaction headers: it tries to access such addresses
| using
| > a 64-bit transactions when the PCI Express standard mandates to use
| 32-bit
| > transactions for memory addresses below 4GB. Some bridges accept
| such
| > invalid transactions, but Intel 5500 chipset rejects them.
| > 
| > I'm allocating 256MB of RAM for I/O buffers; I'm fear that
| restricting all
| > the allocations to the first 2GB of memory will put too much
| pressure in
| > that zone of memory. But restricting it to 4GB and above will be
| okay. 
| > 
| > Is there any way to restrict to memory address above 4GB?
| 
| Would this work for you?
| From: Documentation/kernel-parameters.txt:
| 
| 	memmap=nn[KMG]$ss[KMG]
| 			[KNL,ACPI] Mark specific memory as reserved.
| 			Region of memory to be used, from ss to ss+nn.
| 			Example: Exclude memory from 0x18690000-0x1869ffff
| 			         memmap=64K$0x18690000
| 			         or
| 			         memmap=0x10000$0x18690000

I think that linking in a list the unusable memory and freeing it after completing all the allocations is a better solution.

Thanks.
