Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1GTN6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:58:07 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:21410 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751243Ab1GTN6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:58:05 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: f0UwwwAVM1kJiHC2JLltl3HK8xb3xxk9XiaMzcmw6LEdptI
 DfemEXoaXpkSbtO17YqyAYBDL2suoKhrzm_SLz8dAwbQ5lLglVqmHj58xBTt
 tiH8F1iQ.OmUA5YagXO2pV6qTUnlhuzklr4YRJJzgQfIpQHSYZ6_9rwenr_5
 jsPVxJeD_oj_YNyECLTSaWJQROO4HgNUDQderZuBr_k08RW9zYj8i.0KLxFc
 U7OAfgFPHKPAvffG7KzOVC72iBO4aDYnzaaMR7WPMwHN_LGFopPKQoC06hMA
 6shIaBeaduTQZUWshvQkBFHvwk_vXpHb5oK2aqHwqKnJHKy0HY5bz8GmVmev
 WiqOVl8vpsPCA33WsKuN3GYvg
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 20 Jul 2011 08:58:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next-20110718] Fix build error at mm/slab.c .
In-Reply-To: <alpine.DEB.2.00.1107201616120.3528@tiger>
Message-ID: <alpine.DEB.2.00.1107200857350.32737@router.home>
References: <201107200319.p6K3JWN5001223@www262.sakura.ne.jp> <alpine.DEB.2.00.1107201616120.3528@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jul 2011, Pekka Enberg wrote:

> > +++ linux-3.0-next/mm/slab.c
> > @@ -3153,12 +3153,9 @@ static void *cache_alloc_debugcheck_afte
> > 	objp += obj_offset(cachep);
> > 	if (cachep->ctor && cachep->flags & SLAB_POISON)
> > 		cachep->ctor(objp);
> > -#if ARCH_SLAB_MINALIGN
> > -	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
> > +	if (ARCH_SLAB_MINALIGN && ((u32)objp & (ARCH_SLAB_MINALIGN-1)))
> > 		printk(KERN_ERR "0x%p: not aligned to
> > ARCH_SLAB_MINALIGN=%d\n",
> > 		       objp, ARCH_SLAB_MINALIGN);
> > -	}
> > -#endif
> > 	return objp;
>
> Looks good to me. Christoph?

Looks okay but I thought you already had a patch that took out the #if
there?

