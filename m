Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab2EHONN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:13:13 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:39564 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754582Ab2EHONM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 10:13:12 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IZGQCxwVM1ntvA8CFbeRNNN0pQWZa4O1Pxz1wep4z1Porix
 LIbObgpntmwOWLjNX_p4Fr1wgYUTZb2A3xri8SsAjlxnd2WKeNo8SDGaCdfD
 jYxIzAUXN5gd8ZAK5wQiAb3ie2bpjZKGrhKf8UuW0pEUHQPUovdmqrT3bbLw
 74hOCG6yFkzF_ZcOpVQjeOf_ttVifhD8HQ6FijB2tx0Ht44w74yeNZ3nij45
 g11mRe55Q8OAG0joGOITBG15JsT.pTrdeuA64PbSNoHpFijM3IxgRaNlY_lM
 qxsQYezg_2w_qHPHCARcwqxcnfxmXaoOhYbqLExDA30NQ5ByTBFU3tkNdXEi
 PM0j3lGFdzM8RfO4ku9jWcNp2LDkgwguCOF0N0yBhfZ7WtxcWrDM2nZmBlO9
 y
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 8 May 2012 09:13:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: Joonsoo Kim <js1304@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] slub: fix incorrect return type of get_any_partial()
In-Reply-To: <alpine.LFD.2.02.1205080831580.4372@tux.localdomain>
Message-ID: <alpine.DEB.2.00.1205080912590.25669@router.home>
References: <1327651943-28225-1-git-send-email-js1304@gmail.com> <alpine.LFD.2.02.1205080831580.4372@tux.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, Pekka Enberg wrote:

> On Fri, 27 Jan 2012, Joonsoo Kim wrote:
>
> > Commit 497b66f2ecc97844493e6a147fd5a7e73f73f408 ('slub: return object pointer
> > from get_partial() / new_slab().') changed return type of some functions.
> > This updates missing part.
> >
> > Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> >
> > diff --git a/mm/slub.c b/mm/slub.c
> > index ffe13fd..18bf13e 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -1579,7 +1579,7 @@ static void *get_partial_node(struct kmem_cache *s,
> >  /*
> >   * Get a page from somewhere. Search in increasing NUMA distances.
> >   */
> > -static struct page *get_any_partial(struct kmem_cache *s, gfp_t flags,
> > +static void *get_any_partial(struct kmem_cache *s, gfp_t flags,
> >  		struct kmem_cache_cpu *c)
> >  {
> >  #ifdef CONFIG_NUMA
> > --
> > 1.7.0.4
>
> Applied, thanks!

Could we also fix the comment at the same time?

