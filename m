Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181Ab2CTOV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:21:29 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:25788 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756497Ab2CTOV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:21:28 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ysbdXlsVM1mwUOkQ2zwvkEkna4brcwmXkQbH6jo9NaK_crt
 BHjRav358XlMpv1qqJlyfNu2EmG6Doxjm23leTYuGexW.t2C92CoJZaNDZhO
 4QfInLdwqdnOmdZoz.vdTHyv10t_15hqfK4iuYH2smAnF8LpU.jwWscyeeUB
 maqOYNOxbRRltOrIfNuU944w4mp7W91nRjA_.LBdcvQx1v.I0A8qyE9AXSL7
 nqkV7n.nZy2kfOJ1z.CNf5tBT8Nabh7Tn9Ae0QwYyamTQ0T5g5Gd7WhPTU54
 pWuB_p_fTs0Mz.knq7TrYqjN.pg8Qry4FlfNKtyJY9O2.SiezabihHFEjlvI
 NA4EtOmMG7frXxU2eTew6ncVKBuhVyI2GylvYakxJSEbZGEEp.dBZE4nV5Ud
 O
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 20 Mar 2012 09:21:24 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/6] slub: add kmalloc_align()
In-Reply-To: <alpine.DEB.2.00.1203200910030.19333@router.home>
Message-ID: <alpine.DEB.2.00.1203200919520.19333@router.home>
References: <1332238884-6237-1-git-send-email-laijs@cn.fujitsu.com> <1332238884-6237-3-git-send-email-laijs@cn.fujitsu.com> <alpine.DEB.2.00.1203200910030.19333@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2012, Christoph Lameter wrote:

> > diff --git a/mm/slub.c b/mm/slub.c
> > index 4907563..01cf99d 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -3238,7 +3238,7 @@ static struct kmem_cache *__init create_kmalloc_cache(const char *name,
> >  	 * This function is called with IRQs disabled during early-boot on
> >  	 * single CPU so there's no need to take slub_lock here.
> >  	 */
> > -	if (!kmem_cache_open(s, name, size, ARCH_KMALLOC_MINALIGN,
> > +	if (!kmem_cache_open(s, name, size, ALIGN_OF_LAST_BIT(size),
> >  								flags, NULL))
> >  		goto panic;
>
> Why does the alignment of struct kmem_cache change? I'd rather have a
> __alignof__(struct kmem_cache) here with alignment specified with the
> struct definition.

Ok this aligns the data not the cache . Ok I see what is going on here.
So the kmalloc array now has a higher alignment. That means you can align
up to that limit within the structure.

