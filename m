Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1GTRhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 13:37:20 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:37080 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab1GTRhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 13:37:18 -0400
Date: Wed, 20 Jul 2011 20:37:00 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: Christoph Lameter <cl@linux.com>
cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next-20110718] Fix build error at mm/slab.c .
In-Reply-To: <alpine.DEB.2.00.1107200857350.32737@router.home>
Message-ID: <alpine.DEB.2.00.1107202036130.2847@tiger>
References: <201107200319.p6K3JWN5001223@www262.sakura.ne.jp> <alpine.DEB.2.00.1107201616120.3528@tiger> <alpine.DEB.2.00.1107200857350.32737@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Christoph Lameter wrote:

> On Wed, 20 Jul 2011, Pekka Enberg wrote:
>
>>> +++ linux-3.0-next/mm/slab.c
>>> @@ -3153,12 +3153,9 @@ static void *cache_alloc_debugcheck_afte
>>> 	objp += obj_offset(cachep);
>>> 	if (cachep->ctor && cachep->flags & SLAB_POISON)
>>> 		cachep->ctor(objp);
>>> -#if ARCH_SLAB_MINALIGN
>>> -	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
>>> +	if (ARCH_SLAB_MINALIGN && ((u32)objp & (ARCH_SLAB_MINALIGN-1)))
>>> 		printk(KERN_ERR "0x%p: not aligned to
>>> ARCH_SLAB_MINALIGN=%d\n",
>>> 		       objp, ARCH_SLAB_MINALIGN);
>>> -	}
>>> -#endif
>>> 	return objp;
>>
>> Looks good to me. Christoph?
>
> Looks okay but I thought you already had a patch that took out the #if
> there?

Indeed. Tetsuo, it's commit c225150 ("slab: fix DEBUG_SLAB build") in 
slab.git. It should appear in linux-next soon.

 			Pekka

