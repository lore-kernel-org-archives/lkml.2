Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653Ab2EKTMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:12:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26168 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759850Ab2EKTMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:12:51 -0400
Date: Fri, 11 May 2012 15:06:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] zsmalloc: zsmalloc: align cache line size
Message-ID: <20120511190643.GB3785@phenom.dumpdata.com>
References: <1336027242-372-4-git-send-email-minchan@kernel.org>
 <4FA28EFD.5070002@vflare.org>
 <4FA33E89.6080206@kernel.org>
 <alpine.LFD.2.02.1205071038090.2851@tux.localdomain>
 <4FA7C2BC.2090400@vflare.org>
 <4FA87837.3050208@kernel.org>
 <731b6638-8c8c-4381-a00f-4ecd5a0e91ae@default>
 <4FA9C127.5020908@kernel.org>
 <d8fb8c73-0fd4-47c6-a9bb-ba3573569d63@default>
 <4FAC5C87.3060504@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAC5C87.3060504@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> 1. zs_handle zs_malloc(size_t size, gfp_t flags) - share a pool by many subsystem(like kmalloc)
> >> 2. zs_handle zs_malloc_pool(struct zs_pool *pool, size_t size) - use own pool(like kmem_cache_alloc)
> >>
> >> Any thoughts?
> > 
> > I don't have any objections to adding this kind of
> > capability to zsmalloc.  But since we are just speculating
> > that this capability would be used by some future
> > kernel subsystem, isn't it normal kernel protocol for
> > this new capability NOT to be added until that future
> > kernel subsystem creates a need for it.
> 
> 
> Now zram makes pool per block device and a embedded system may use zram
> for several block device, ex) swap device, several compressed tmpfs
> In such case, share pool is better than private pool because embedded system
> don't mount/umount frequently on such directories since booting.
> 
> > 
> > As I said in reply to the other thread, there is missing
> > functionality in zsmalloc that is making it difficult for
> > it to be used by zcache.  It would be good if Seth
> > and Nitin (and any other kernel developers) would work
> 
> 
> So, if you guys post TODO list, it helps fix the direction.
> 
> > on those issues before adding capabilities for non-existent
> > future users of zsmalloc.
> 
> 
> I think it's not urgent than zs_handle mess.

I am having a hard time parsing that. Are you saying that
this is not as important as the zs_handle fixup? I think
that is what you meant, but what to make sure.
