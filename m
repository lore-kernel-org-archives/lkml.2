Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab0CYJBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 05:01:06 -0400
Received: from mailout5.samsung.com ([203.254.224.35]:33953 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab0CYJBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 05:01:03 -0400
Date: Thu, 25 Mar 2010 18:01:00 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
In-reply-to: <20100325054430.165311fa@taxman.wild-wind.fr.eu.org>
To: Marc Zyngier <maz@misterjones.org>
Cc: dan.j.williams@intel.com, linus.ml.walleij@gmail.com,
       kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Message-id: <4BAB264C.2090502@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
References: <4BAAD5BB.7050101@samsung.com>
 <20100325054430.165311fa@taxman.wild-wind.fr.eu.org>
X-OriginalArrivalTime: 25 Mar 2010 09:01:01.0010 (UTC)
 FILETIME=[B0FC4B20:01CACBF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2010 2:44 PM, Marc Zyngier wrote:
> On Thu, 25 Mar 2010 12:17:15 +0900
> Joonyoung Shim <jy0922.shim@samsung.com> wrote:
> 
>> +/* instruction set functions */
>> +static inline int pl330_dmaaddh(u8 *desc_pool_virt, u16 imm, bool ra)
>> +{
>> +	u8 opcode = DMAADDH | (ra << 1);
>> +
>> +	writeb(opcode, desc_pool_virt++);
> 
> desc_pool_virt is a virtual address (from dma_alloc_coherent). In such
> case, write[bwl] seems to be the wrong interface. I suggest the
> following code:
> 
> 	*desc_pool_virt++ = opcode;
> 
>> +	writew(imm, desc_pool_virt);
> 

Right. The write[bwl] is api for address ioremapped of io device. I will
change these.

> Does anything ensure that this won't generate an unaligned access?
> 

PL330 DMA controller fetches variable length instructions that consist of
one to six bytes, so i think unaligned access is no problem.

>> +	return 3;
>> +}
> 
> 	M.

