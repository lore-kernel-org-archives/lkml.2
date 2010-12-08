Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab0LHEdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 23:33:10 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52330 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab0LHEdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 23:33:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MjF5S6dwMfSskERwV1RwOQq4C5RhPDqXTD2bp4LBl6PdbyCxEmxAQkrChMqPqVOAFN
         1lW3SSyliRQEZtXEYvewQsNh09+P9BAlqg0gh7uuCjRuYjRCT9MNBFU47d/+0I4XSGaz
         G2ds744tPGtNblSksKLmwh2CO4saBXDgAKGaA=
Subject: Re: [06/44] numa: fix slab_node(MPOL_BIND)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>
In-Reply-To: <1291777422.26147.70.camel@zaphod>
References: <20101208000640.115606851@clark.site>
	 <1291777422.26147.70.camel@zaphod>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 05:33:02 +0100
Message-ID: <1291782782.5324.54.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 07 décembre 2010 à 22:03 -0500, Lee Schermerhorn a écrit :
> On Tue, 2010-12-07 at 16:04 -0800, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > 
> > commit 800416f799e0723635ac2d720ad4449917a1481c upstream.
> > 

> > 
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1404,7 +1404,7 @@ unsigned slab_node(struct mempolicy *pol
> >  		(void)first_zones_zonelist(zonelist, highest_zoneidx,
> >  							&policy->v.nodes,
> >  							&zone);
> > -		return zone->node;
> > +		return zone ? zone->node : numa_node_id();
> 
> I think this should be numa_mem_id().  Given the documented purpose of
> slab_node(), we want a node from which page allocation is likely to
> succeed.  numa_node_id() can return a memoryless node for, e.g.,  some
> configurations of some HP ia64 platforms.  numa_mem_id() was introduced
> to return that same node from which "local" mempolicy would allocate
> pages.

Hmm... numa_mem_id() was introduced in 2.6.35 as an optimization.

When I did this patch (to fix a bug), mm/mempolicy.c only contained
calls to numa_node_id() (and still is today)

By the way, anybody knows how I can emulate a memoryless node on a dual
node x86_64 machine (with memory present on both nodes) ?



