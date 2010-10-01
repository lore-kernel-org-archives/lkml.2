Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab0JASwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:52:53 -0400
Received: from relay3.sgi.com ([192.48.152.1]:55738 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754570Ab0JASww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:52:52 -0400
Date: Fri, 1 Oct 2010 13:52:50 -0500
From: Robin Holt <holt@sgi.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, Greg KH <greg@kroah.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>, steiner@sgi.com
Subject: Re: [PATCH 4/9] v3 Allow memory blocks to span multiple memory
 sections
Message-ID: <20101001185250.GK14064@sgi.com>
References: <4CA62700.7010809@austin.ibm.com>
 <4CA62917.80008@austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA62917.80008@austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 01:31:51PM -0500, Nathan Fontenot wrote:
> Update the memory sysfs code such that each sysfs memory directory is now
> considered a memory block that can span multiple memory sections per
> memory block.  The default size of each memory block is SECTION_SIZE_BITS
> to maintain the current behavior of having a single memory section per
> memory block (i.e. one sysfs directory per memory section).
> 
> For architectures that want to have memory blocks span multiple
> memory sections they need only define their own memory_block_size_bytes()
> routine.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
> 
> ---
>  drivers/base/memory.c |  155 ++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 108 insertions(+), 47 deletions(-)
> 
> Index: linux-next/drivers/base/memory.c
> ===================================================================
> --- linux-next.orig/drivers/base/memory.c	2010-09-30 14:13:50.000000000 -0500
> +++ linux-next/drivers/base/memory.c	2010-09-30 14:46:00.000000000 -0500
...
> +static unsigned long get_memory_block_size(void)
> +{
> +	u32 block_sz;
        ^^^

I think this should be unsigned long.  u32 will work, but everything
else has been changed to use unsigned long.  If you disagree, I will
happily acquiesce as nothing is currently broken.  If SGI decides to make
memory_block_size_bytes more dynamic, we will fix this up at that time.

Robin
