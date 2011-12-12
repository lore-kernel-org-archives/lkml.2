Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1LLHYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:24:06 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59894 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1LLHYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:24:02 -0500
Message-ID: <1323674637.2576.17.camel@edumazet-laptop>
Subject: Re: Switch per cpu partial page support off for debugging
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Dec 2011 08:23:57 +0100
In-Reply-To: <alpine.LFD.2.02.1112120915030.2555@tux.localdomain>
References: <alpine.DEB.2.00.1111230923260.16544@router.home>
	 <alpine.LFD.2.02.1112120915030.2555@tux.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 12 décembre 2011 à 09:16 +0200, Pekka Enberg a écrit :
> On Wed, 23 Nov 2011, Christoph Lameter wrote:
> > Eric saw an issue with accounting of slabs during validation. Its not
> > possible to determine accurately how many per cpu partial slabs exist at
> > any time so this switches off per cpu partial pages during debug.
> >
> > Subject: Switch per cpu partial page support off for debugging
> >
> > Otherwise we have accounting issues.
> >
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> >
> >
> > ---
> > mm/slub.c |    4 +++-
> > 1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > Index: linux-2.6/mm/slub.c
> > ===================================================================
> > --- linux-2.6.orig/mm/slub.c	2011-11-22 11:57:21.000000000 -0600
> > +++ linux-2.6/mm/slub.c	2011-11-22 11:57:55.000000000 -0600
> > @@ -3027,7 +3027,9 @@ static int kmem_cache_open(struct kmem_c
> > 	 *    per node list when we run out of per cpu objects. We only fetch 50%
> > 	 *    to keep some capacity around for frees.
> > 	 */
> > -	if (s->size >= PAGE_SIZE)
> > +	if (kmem_cache_debug(s))
> > +		s->cpu_partial = 0;
> > +	else if (s->size >= PAGE_SIZE)
> > 		s->cpu_partial = 2;
> > 	else if (s->size >= 1024)
> > 		s->cpu_partial = 6;
> 
> Looks OK to me. CC'ing Eric and David.

This seems fine to me, thanks.

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


