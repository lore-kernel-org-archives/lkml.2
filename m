Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892Ab0HEHkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:40:45 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6969 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759674Ab0HEHkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:40:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Eu+TKIRSrJyoFZaCsDizau3NooVCBOdbyNbAJJe0KpMbWsA2URtnxy+qDuZWReyUQ
	4zrcaRvu7bXWqlUGPnKLQ==
Date: Thu, 5 Aug 2010 00:40:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q3 03/23] slub: Use a constant for a unspecified node.
In-Reply-To: <alpine.DEB.2.00.1008040946200.11084@router.home>
Message-ID: <alpine.DEB.2.00.1008050036520.29020@chino.kir.corp.google.com>
References: <20100804024514.139976032@linux.com> <20100804024525.562559967@linux.com> <alpine.DEB.2.00.1008032029380.23490@chino.kir.corp.google.com> <alpine.DEB.2.00.1008040946200.11084@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Christoph Lameter wrote:

> > >  static struct page *get_partial(struct kmem_cache *s, gfp_t flags, int node)
> > >  {
> > >  	struct page *page;
> > > -	int searchnode = (node == -1) ? numa_node_id() : node;
> > > +	int searchnode = (node == NUMA_NO_NODE) ? numa_node_id() : node;
> > >
> > >  	page = get_partial_node(get_node(s, searchnode));
> > >  	if (page || (flags & __GFP_THISNODE) || node != -1)
> >
> > This has a merge conflict with 2.6.35 since it has this:
> >
> > 	page = get_partial_node(get_node(s, searchnode));
> > 	if (page || (flags & __GFP_THISNODE))
> > 		return page;
> >
> > 	return get_any_partial(s, flags);
> >
> > so what happened to the dropped check for returning get_any_partial() when
> > node != -1?  I added the check for benchmarking.
> 
> Strange no merge conflict here. Are you sure you use upstream?
> 

Yes, 2.6.35 does not have the node != -1 check and Linus hasn't pulled 
slub/fixes from Pekka's tree yet.  Even when he does, "slub numa: Fix rare 
allocation from unexpected node" removes the __GFP_THISNODE check before 
adding node != -1, so this definitely doesn't apply to anybody else's 
tree.
