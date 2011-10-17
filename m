Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab1JQQBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:01:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:48782 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab1JQQBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:01:21 -0400
Subject: Re: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20111014183144.GD28556@local>
Date: Mon, 17 Oct 2011 11:00:55 -0500
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
        Kai Jiang <Kai.Jiang@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4D73F261-3795-4F71-9921-568C1B9F06E0@kernel.crashing.org>
References: <1318521058-15662-1-git-send-email-galak@kernel.crashing.org> <20111014183144.GD28556@local>
To: "Hans J. Koch" <hjk@hansjkoch.de>
X-Mailer: Apple Mail (2.1251.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 14, 2011, at 1:31 PM, Hans J. Koch wrote:

> On Thu, Oct 13, 2011 at 10:50:58AM -0500, Kumar Gala wrote:
>> From: Kai Jiang <Kai.Jiang@freescale.com>
>> 
>> To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
>> extend the width of 'addr' in struct uio_mem.  Numerous platforms like
>> embedded PPC, ARM, and X86 have support for systems with larger physical
>> address than logical.
>> 
>> Since 'addr' may contain a physical, logical, or virtual address the
>> easiest solution is to just change the type to 'phys_addr_t' which
>> should always be greater than or equal to the sizeof(void *) such that
>> it can properly hold any of the address types.
>> 
>> For physical address we can support up to a 44-bit physical address on a
>> typical 32-bit system as we utilize remap_pfn_range() for the mapping of
>> the memory region and pfn's are represnted by shifting the address by
>> the page size (typically 4k).
>> 
>> Signed-off-by: Kai Jiang <Kai.Jiang@freescale.com>
>> Signed-off-by: Minghuan Lian <Minghuan.Lian@freescale.com>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> 
> Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>
> 
> That looks good to me. There's an unnecessary cast (see below), but I fixed that
> on the way.
> 
> Greg, please pull this from branch uio-for-gregkh from
> 
> git://hansjkoch.de/git/linux-hjk
> 
> Thanks,
> Hans

I think removing that cast is wrong:

drivers/uio/uio.c: In function 'uio_vma_fault':
drivers/uio/uio.c:637:26: warning: cast to pointer from integer of different size

- k


