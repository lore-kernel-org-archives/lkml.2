Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab2IMAeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:34:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50838 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab2IMAeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 20:34:06 -0400
Date: Wed, 12 Sep 2012 17:34:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Cyril Chemparathy <cyril@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, davem@davemloft.net, eric.dumazet@gmail.com,
        hannes@cmpxchg.org, shangw@linux.vnet.ibm.com, vitalya@ti.com
Subject: Re: [PATCH] mm: bootmem: use phys_addr_t for physical addresses
Message-ID: <20120913003400.GA25889@localhost>
References: <1347466008-7231-1-git-send-email-cyril@ti.com>
 <20120912203920.GU7677@google.com>
 <505123FE.2090305@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505123FE.2090305@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 12, 2012 at 08:08:30PM -0400, Cyril Chemparathy wrote:
> >So, a function which takes phys_addr_t for goal and limit but returns
> >void * doesn't make much sense unless the function creates directly
> >addressable mapping somewhere.
> 
> On the 32-bit PAE platform in question, physical memory is located
> outside the 4GB range.  Therefore phys_to_virt takes a 64-bit
> physical address and returns a 32-bit kernel mapped lowmem pointer.

Yes but phys_to_virt() can return the vaddr only if the physical
address is already mapped in the kernel address space; otherwise, you
need one of the kmap*() calls which may not be online early in the
boot and consumes either the vmalloc area or fixmaps.  bootmem
interface can't handle unmapped memory.

Thanks.

-- 
tejun
