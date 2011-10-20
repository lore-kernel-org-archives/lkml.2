Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab1JXNIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:08:05 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:63336 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab1JXNIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:08:01 -0400
Date: Thu, 20 Oct 2011 19:44:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] xen: map foreign pages for shared rings by updating
 the PTEs directly
Message-ID: <20111020234459.GF19558@phenom.dumpdata.com>
References: <1319107519-2253-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319107519-2253-1-git-send-email-david.vrabel@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4EA56315.003F:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 11:45:15AM +0100, David Vrabel wrote:
> This series of patches allows the vmalloc_sync_all() to be removed
> from alloc_vm_area() by getting the hypervisor to update the PTEs (in
> init_mm) directly rather than having the hypervisor look in the
> current page tables to find the PTEs.
> 
> Once the hypervisor has updated the PTEs, the normal mechanism of
> syncing the page tables after a fault works as expected.
> 
> This mechanism doesn't currently work on the ia64 port as that does
> not support the GNTMAP_contains_pte flag.
> 
> Andrew, patch 4 (xen: map foreign pages for shared rings by updating
> the PTEs directly) depends on patch 1 so it's probably best to go via
> Konrad's Xen tree with your acked-by.

Or I can Ack patch 1 and Andrew can pick both of them. Either way - but let
mention the Ack on patch #1

> 
> David
> 
> David Vrabel (4):
>   xen: use generic functions instead of xen_{alloc,free}_vm_area()
>   block: xen-blkback: use API provided by xenbus module to map rings
>   net: xen-netback: use API provided by xenbus module to map rings
>   xen: map foreign pages for shared rings by updating the PTEs directly
> 
>  arch/ia64/include/asm/xen/grant_table.h |   29 -----------
>  arch/ia64/xen/grant-table.c             |   62 ------------------------
>  arch/x86/include/asm/xen/grant_table.h  |    7 ---
>  arch/x86/xen/grant-table.c              |    2 +-
>  drivers/block/xen-blkback/common.h      |    5 +--
>  drivers/block/xen-blkback/xenbus.c      |   54 +++------------------
>  drivers/net/xen-netback/common.h        |   11 ++--
>  drivers/net/xen-netback/netback.c       |   80 +++++++------------------------
>  drivers/xen/xenbus/xenbus_client.c      |   15 ++++--
>  include/linux/vmalloc.h                 |    2 +-
>  include/xen/grant_table.h               |    1 -
>  mm/vmalloc.c                            |   27 +++++-----
>  12 files changed, 55 insertions(+), 240 deletions(-)
>  delete mode 100644 arch/ia64/include/asm/xen/grant_table.h
>  delete mode 100644 arch/x86/include/asm/xen/grant_table.h
> 
> -- 
> 1.7.2.5
