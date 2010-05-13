Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab0EMEo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 00:44:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:33988 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab0EMEoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 00:44:55 -0400
Subject: Re: Rampant ext3/4 corruption on 2.6.34-rc7 with VIVT ARM (Marvell
 88f5182)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: saeed@marvell.com, nico@marvell.com, jamie@shareable.org,
       linux-kernel@vger.kernel.org, jejb@parisc-linux.org,
       santosh.shilimkar@ti.com, akpm@linux-foundation.org,
       linux-ext4@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100513121302Z.fujita.tomonori@lab.ntt.co.jp>
References: <EAF47CD23C76F840A9E7FCE10091EFAB02C545537F@dbde02.ent.ti.com>
	 <20100512222154.GA6841@shareable.org> <1273704431.21352.136.camel@pasglop>
	 <20100513121302Z.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 14:42:31 +1000
Message-ID: <1273725751.21352.176.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 12:12 +0900, FUJITA Tomonori wrote:
> X86 OOSTORE uses a memory barrier dma_sync_single_for_device (seems
> that some mips archs also use it and do cache operations).
> 
> I think that the DMA-API says that
> 
> - dma_sync_single_for_device() makes sure the data ready for DMA.
> 
> - dma_sync_single_for_cpu() makes sure that drivers doesn't get the
>   stale data after DMA.
> 
> I guess, it means if an architecture need a memory barrier (not only
> cache operations) to guarantee the above, the architecture needs to
> take care of it. 

Right, but doing an indirect function pointer call for a memory barrier
in what can be a pretty hot code path doesn't sound like a great idea
if it can be avoided. I'd rather we define some inline that the arch
can stick in there if it wishes so.

Cheers,
Ben.


