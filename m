Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0HYUPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 16:15:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24683 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab0HYUPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 16:15:05 -0400
Date: Wed, 25 Aug 2010 13:13:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Lameter <cl@linux.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: linux-next: Tree for August 25 (mm/slub)
Message-Id: <20100825131344.a2c26b31.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.2.00.1008251447410.22117@router.home>
References: <20100825132057.c8416bef.sfr@canb.auug.org.au>
	<20100825094559.bc652afe.randy.dunlap@oracle.com>
	<alpine.DEB.2.00.1008251409260.22117@router.home>
	<20100825122134.2ac33360.randy.dunlap@oracle.com>
	<alpine.DEB.2.00.1008251447410.22117@router.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 14:51:14 -0500 (CDT) Christoph Lameter wrote:

> On Wed, 25 Aug 2010, Randy Dunlap wrote:
> 
> > Certainly.  config file is attached.
> 
> Ah. Memory hotplug....
> 
> 
> 
> Subject: Slub: Fix up missing kmalloc_cache -> kmem_cache_node case for memoryhotplug
> 
> Memory hotplug allocates and frees per node structures. Use the correct name.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  mm/slub.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/mm/slub.c
> ===================================================================
> --- linux-2.6.orig/mm/slub.c	2010-08-25 14:48:23.000000000 -0500
> +++ linux-2.6/mm/slub.c	2010-08-25 14:49:03.000000000 -0500
> @@ -2909,7 +2909,7 @@ static void slab_mem_offline_callback(vo
>  			BUG_ON(slabs_node(s, offline_node));
> 
>  			s->node[offline_node] = NULL;
> -			kmem_cache_free(kmalloc_caches, n);
> +			kmem_cache_free(kmem_cache_node, n);
>  		}
>  	}
>  	up_read(&slub_lock);
> @@ -2942,7 +2942,7 @@ static int slab_mem_going_online_callbac
>  		 *      since memory is not yet available from the node that
>  		 *      is brought up.
>  		 */
> -		n = kmem_cache_alloc(kmalloc_caches, GFP_KERNEL);
> +		n = kmem_cache_alloc(kmem_cache_node, GFP_KERNEL);
>  		if (!n) {
>  			ret = -ENOMEM;
>  			goto out;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
