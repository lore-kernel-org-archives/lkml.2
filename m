Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932832Ab1DMCQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 22:16:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:62830 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab1DMCQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 22:16:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=n/gWgFGP/COeIfZHaqmfl9TY1qcN3hnTiGiW8lo9aFimbIuRJFBKGcvp2IVvLjbfIa
         5UzkZzgmRGy0N0ml+u+g==
Date: Tue, 12 Apr 2011 19:16:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH] slub: Fix a typo in config name
In-Reply-To: <alpine.DEB.2.00.1104121301430.14692@router.home>
Message-ID: <alpine.DEB.2.00.1104121913410.15979@chino.kir.corp.google.com>
References: <4DA3FDB2.9090100@cn.fujitsu.com> <alpine.DEB.2.00.1104121301430.14692@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, Christoph Lameter wrote:

> On Tue, 12 Apr 2011, Li Zefan wrote:
> 
> > There's no config named SLAB_DEBUG, and it should be a typo
> > of SLUB_DEBUG.
> >
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > ---
> >
> > not slub expert, don't know how this bug affects slub debugging.
> 
> Affects the bootstrap code.
> 

I don't see how, there should be no partial or full slabs for either 
kmem_cache or kmem_cache_node at this point in the boot sequence.  I think 
kmem_cache_bootstrap_fixup() should only need to add the cache to the list 
of slab caches and set the refcount accordingly.
