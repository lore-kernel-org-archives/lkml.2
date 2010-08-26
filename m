Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab0HZDQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 23:16:14 -0400
Received: from smtp-out.google.com ([74.125.121.35]:60179 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab0HZDQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 23:16:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=KLWoLb2you4gFqIhUncuRGDXZvg+73HK3r9VzKFnbW+MIlE7m/uR7RtRLgerE75N+
	rfbuWQggRCai7cCUx3Saw==
Date: Wed, 25 Aug 2010 20:16:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree (slab
 tree related)
In-Reply-To: <alpine.DEB.2.00.1008252031560.32421@router.home>
Message-ID: <alpine.DEB.2.00.1008252014560.10986@chino.kir.corp.google.com>
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <20100825101320.bed89b2a.sfr@canb.auug.org.au> <4C74A01E.1060809@cs.helsinki.fi> <alpine.DEB.2.00.1008250905490.13026@router.home> <alpine.DEB.2.00.1008251656390.22018@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1008252031560.32421@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010, Christoph Lameter wrote:

> > > +	 * Special hack for UP mode. allocpercpu() falls back to kmalloc
> > > +	 * operations. So we cannot use that before the slab allocator is up
> > > +	 * Simply get the smallest possible compound page. The page will be
> > > +	 * released via kfree() when the cpu caches are resized later.
> > > +	 */
> > > +	if (slab_state < UP)
> > > +		s->cpu_slab = (__percpu void *)__get_free_page(GFP_NOWAIT, 1);
> >
> > __get_free_pages() takes an order argument.
> 
> Right. Patch not refreshed after the last tinzy winzy change. Seems that I
> got a bit rusty.
> 
> Subject: Slub: UP bandaid
> 
> Since the percpu allocator does not provide early allocation in UP
> mode (only in SMP configurations) use __get_free_page() to improvise
> a compound page allocation that can be later freed via kfree().
> 
> Compound pages will be released when the cpu caches are resized.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Acked-by: David Rientjes <rientjes@google.com>

I'm really hoping that we can remove this hack soon when the percpu 
allocator can handle these allocations on UP without any specialized slab 
behavior.
