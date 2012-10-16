Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2JPAsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:48:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36676 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2JPAsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:48:35 -0400
Date: Mon, 15 Oct 2012 17:48:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        bhutchings@solarflare.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mpol_to_str revisited.
In-Reply-To: <20121008205213.GA23211@redhat.com>
Message-ID: <alpine.DEB.2.00.1210151748010.31712@chino.kir.corp.google.com>
References: <20121008150949.GA15130@redhat.com> <alpine.DEB.2.00.1210081330160.18768@chino.kir.corp.google.com> <20121008205213.GA23211@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Oct 2012, Dave Jones wrote:

>  > > diff -durpN '--exclude-from=/home/davej/.exclude' src/git-trees/kernel/linux/fs/proc/task_mmu.c linux-dj/fs/proc/task_mmu.c
>  > > --- src/git-trees/kernel/linux/fs/proc/task_mmu.c	2012-05-31 22:32:46.778150675 -0400
>  > > +++ linux-dj/fs/proc/task_mmu.c	2012-10-04 19:31:41.269988984 -0400
>  > > @@ -1162,6 +1162,7 @@ static int show_numa_map(struct seq_file
>  > >  	struct mm_walk walk = {};
>  > >  	struct mempolicy *pol;
>  > >  	int n;
>  > > +	int ret;
>  > >  	char buffer[50];
>  > >  
>  > >  	if (!mm)
>  > > @@ -1178,7 +1179,11 @@ static int show_numa_map(struct seq_file
>  > >  	walk.mm = mm;
>  > >  
>  > >  	pol = get_vma_policy(proc_priv->task, vma, vma->vm_start);
>  > > -	mpol_to_str(buffer, sizeof(buffer), pol, 0);
>  > > +	memset(buffer, 0, sizeof(buffer));
>  > > +	ret = mpol_to_str(buffer, sizeof(buffer), pol, 0);
>  > > +	if (ret < 0)
>  > > +		return 0;
>  > 
>  > We should need the mpol_cond_put(pol) here before returning.
> 
> good catch. I'll respin the patch later with this changed.
> 

Did you get a chance to fix this issue?
