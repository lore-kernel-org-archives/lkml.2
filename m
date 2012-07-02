Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab2GBKD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:03:28 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60373 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932871Ab2GBKD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:03:27 -0400
Message-ID: <4FF1714A.7050400@parallels.com>
Date: Mon, 2 Jul 2012 14:00:42 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: <penberg@kernel.org>, <linux-kernel@vger.kernel.org>,
        <fengguang.wu@intel.com>, <sfr@canb.auug.org.au>, <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] slab: Fix a tpyo in commit 8c138b "slab: Get rid of obj_size
 macro"
References: <1341210550-11038-1-git-send-email-feng.tang@intel.com>
In-Reply-To: <1341210550-11038-1-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 10:29 AM, Feng Tang wrote:
> Commit  8c138b only sits in Pekka's and linux-next tree now, which tries
> to replace obj_size(cachep) with cachep->object_size, but has a typo in
> kmem_cache_free() by using "size" instead of "object_size", which casues
> some regressions.
> 
> Reported-and-tested-by: Fengguang Wu <wfg@linux.intel.com>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Cc: Christoph Lameter <cl@linux.com>
> ---
>  mm/slab.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slab.c b/mm/slab.c
> index 64c3d03..605b3b7 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3890,7 +3890,7 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
>  	unsigned long flags;
>  
>  	local_irq_save(flags);
> -	debug_check_no_locks_freed(objp, cachep->size);
> +	debug_check_no_locks_freed(objp, cachep->object_size);
>  	if (!(cachep->flags & SLAB_DEBUG_OBJECTS))
>  		debug_check_no_obj_freed(objp, cachep->object_size);
>  	__cache_free(cachep, objp, __builtin_return_address(0));
> 

I saw another bug in a patch that ended up not getting in, and was
reported to Christoph, that was exactly due to a typo between size and
object-size.

So first:

Acked-by: Glauber Costa <glommer@parallels.com>

But this also means that that confusion can have been made in other
points. I suggest we take an extensive look into that to make sure there
aren't more.

