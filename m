Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab2EWLrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 07:47:04 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50856 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932304Ab2EWLqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 07:46:40 -0400
Message-ID: <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] slab+slob: dup name string
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>, Glauber Costa <glommer@parallels.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>
Date: Wed, 23 May 2012 12:46:35 +0100
In-Reply-To: <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com>
	 <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1205220855470.17600@router.home>
	 <4FBBAE95.6080608@parallels.com>
	 <alpine.DEB.2.00.1205221216050.17721@router.home>
	 <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 15:31 -0700, David Rientjes wrote:
> On Tue, 22 May 2012, Christoph Lameter wrote:
> 
> > > I think that's precisely David's point: that we might want to destroy them
> > > eventually.
> > 
> > Cannot imagine why.
> > 
> 
> We can't predict how slab will be extended in the future and this affects 
> anything created before g_cpucache_cpu <= EARLY.  This would introduce the 
> first problem with destroying such caches and is unnecessary if a 
> workaround exists.

These problems seem to indicate that the slab behaviour: expecting the
string to exist for the lifetime of the cache so there's no need to copy
it might be better.

This must be the behaviour all users of kmem_cache_create() expect
anyway, since all enterprise distributions use slab and they're not
getting bugs reported in this area.

So, why not simply patch slab to rely on the string lifetime being the
cache lifetime (or beyond) and therefore not having it take a copy?

James


