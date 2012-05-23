Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab2EWMYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 08:24:44 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50946 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932363Ab2EWMYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 08:24:43 -0400
Message-ID: <1337775878.3013.16.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] slab+slob: dup name string
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Glauber Costa <glommer@parallels.com>
Cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>
Date: Wed, 23 May 2012 13:24:38 +0100
In-Reply-To: <4FBCD328.6060406@parallels.com>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com>
	  <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
	  <alpine.DEB.2.00.1205220855470.17600@router.home>
	  <4FBBAE95.6080608@parallels.com>
	  <alpine.DEB.2.00.1205221216050.17721@router.home>
	  <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com>
	 <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com>
	 <4FBCD328.6060406@parallels.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 16:08 +0400, Glauber Costa wrote:
> On 05/23/2012 03:46 PM, James Bottomley wrote:
> >> We can't predict how slab will be extended in the future and this affects
> >> >  anything created before g_cpucache_cpu<= EARLY.  This would introduce the
> >> >  first problem with destroying such caches and is unnecessary if a
> >> >  workaround exists.
> > These problems seem to indicate that the slab behaviour: expecting the
> > string to exist for the lifetime of the cache so there's no need to copy
> > it might be better.
> >
> > This must be the behaviour all users of kmem_cache_create() expect
> > anyway, since all enterprise distributions use slab and they're not
> > getting bugs reported in this area.
> >
> > So, why not simply patch slab to rely on the string lifetime being the
> > cache lifetime (or beyond) and therefore not having it take a copy?
> >
> You mean patch slub? slub is the one that takes a copy currently.

Yes ... a one letter typo.  

James


