Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1GGJjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 05:39:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33657 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab1GGJjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 05:39:45 -0400
Date: Thu, 7 Jul 2011 10:39:28 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Qin Dehua <qindehua@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, neilb@suse.de
Subject: Re: PROBLEM: ARM-dma-mapping-fix-for-speculative-prefetching cause
	OOPS
Message-ID: <20110707093928.GA15325@flint.arm.linux.org.uk>
References: <BANLkTimfF3_R5VS4xOriGp+-3j-r7V0W0w@mail.gmail.com> <20110630074301.GC27959@flint.arm.linux.org.uk> <BANLkTimBTayh_mjOLMZbz3D+wqdtZ10=wA@mail.gmail.com> <20110630112804.GA21481@flint.arm.linux.org.uk> <BANLkTimo18w5yuE4jtATPvbgENCL04LMpA@mail.gmail.com> <BANLkTimupUqpLDdDvMRjB+Js0xW59MTOQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimupUqpLDdDvMRjB+Js0xW59MTOQA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 12:54:09PM +0800, Qin Dehua wrote:
> The followings are messages of the three tests:
> ====== RUN 1 ======
> kernel BUG at drivers/md/raid5.c:3978!

So they are BUG_ON()s after all...

Could you try commenting out:

+       if (dir != DMA_TO_DEVICE)
+               outer_inv_range(paddr, paddr + size);

in ___dma_page_dev_to_cpu and:

+       if (dir != DMA_TO_DEVICE) {
+               unsigned long paddr = __pa(kaddr);
+               outer_inv_range(paddr, paddr + size);
+       }

in ___dma_single_dev_to_cpu please - and put a BUG_ON(dir == DMA_BIDIRECTIONAL)
in their place (because that won't be handled correctly with that change.)

Thanks.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
