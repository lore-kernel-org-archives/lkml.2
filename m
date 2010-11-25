Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0KYJTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:19:05 -0500
Received: from smtp.nokia.com ([147.243.1.48]:61642 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab0KYJTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:19:01 -0500
Subject: Re: [PATCH] memblock: fix memblock_is_region_memory()
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Andrew Morton <akpm@linux-foundation.org>
Cc: benh@kernel.crashing.org, yinghai@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101124153154.a0e68722.akpm@linux-foundation.org>
References: <1289214013-13449-1-git-send-email-tomi.valkeinen@nokia.com>
	 <20101124153154.a0e68722.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Thu, 25 Nov 2010 11:17:17 +0200
Message-ID: <1290676637.24703.31.camel@tubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 15:31 -0800, ext Andrew Morton wrote:
> On Mon,  8 Nov 2010 13:00:13 +0200
> Tomi Valkeinen <tomi.valkeinen@nokia.com> wrote:
> 
> > To: benh@kernel.crashing.org, yinghai@kernel.org
> 
> wakey wakey!
> 
> > memblock_is_region_memory() uses reserved memblocks to search for the
> > given region, while it should use the memory memblocks.
> > 
> > Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
> > ---
> >  mm/memblock.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index 400dc62..bdba245 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -683,13 +683,13 @@ int __init_memblock memblock_is_memory(phys_addr_t addr)
> >  
> >  int __init_memblock memblock_is_region_memory(phys_addr_t base, phys_addr_t size)
> >  {
> > -	int idx = memblock_search(&memblock.reserved, base);
> > +	int idx = memblock_search(&memblock.memory, base);
> >  
> >  	if (idx == -1)
> >  		return 0;
> > -	return memblock.reserved.regions[idx].base <= base &&
> > -		(memblock.reserved.regions[idx].base +
> > -		 memblock.reserved.regions[idx].size) >= (base + size);
> > +	return memblock.memory.regions[idx].base <= base &&
> > +		(memblock.memory.regions[idx].base +
> > +		 memblock.memory.regions[idx].size) >= (base + size);
> >  }
> 
> What were the runtime effects of this problem?
> 
> afacit the only callers are a couple of obscure fbdev drivers.  Do you
> know of other callers?

I don't know any other callers.

I encountered the problem with OMAP's framebuffer ram allocation.
Normally the ram is allocated dynamically, and this function is not
called. However, if we want to pass the framebuffer from the bootloader
to the kernel (to retain the boot image), this function is used to check
the validity of the kernel parameters for the framebuffer ram area.

 Tomi


