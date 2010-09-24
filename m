Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0IXFvJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 01:51:09 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:49501 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999Ab0IXFvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 01:51:08 -0400
Date: Thu, 23 Sep 2010 22:50:12 -0700
From: matt mooney <mfm@muteddisk.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
        linux-kernel@vger.kernel.org,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
        Tim Abbott <tabbott@ksplice.com>
Subject: Re: [PATCH v4 2/2] bsearch: prevent overflow when computing middle
 comparison element
Message-ID: <20100924055012.GC18432@haskell.muteddisk.com>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	=?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
	linux-kernel@vger.kernel.org,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Tim Abbott <tabbott@ksplice.com>
References: <cover.1257864802.git.andre.goddard@gmail.com>
 <200911141012.19050.rusty@rustcorp.com.au>
 <AANLkTinhg-ZgQRQ5KUXR-FeTa9zo+cUF+3vZykzeaHwE@mail.gmail.com>
 <201009231056.11938.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201009231056.11938.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:56 Thu 23 Sep     , Rusty Russell wrote:
> On Thu, 23 Sep 2010 12:12:13 am André Goddard Rosa wrote:
> > On Fri, Nov 13, 2009 at 8:42 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > On Sat, 14 Nov 2009 01:33:04 am Thiago Farina wrote:
> > >> Hi Rusty,
> > >>
> > >> On Thu, Nov 12, 2009 at 11:06 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > >> > On Wed, 11 Nov 2009 01:30:25 am André Goddard Rosa wrote:
> > >> >> It's really difficult to occur in practice because the sum of the lower
> > >> >> and higher limits must overflow an int variable, but it can occur when
> > >> >> working with large arrays. We'd better safe than sorry by avoiding this
> > >> >> overflow situation when computing the middle element for comparison.
> > >> >
> > >> > I applied all these, after testing.  In future would have been nice for you
> > >> > to have posted a test patch so I didn't have make my own...
> > >>
> > >> Where did you apply this patch?
> > >
> > > To my kernel series, which means it is now in linux-next.
> > >
> > > Hope that helps,
> > > Rusty.
> > >
> > 
> > Hi, Rusty!
> > 
> >     Is there any chance that this patchset will land into mainline anytime soon?
> > 
> >     Here we have another use for the binary search function:
> >         http://marc.info/?l=linux-kernel&m=128515012817787&w=2
> 
> "Unused code is buggy code".  Can we have some users please?  Do people
> care that uninlining means an indirect fn call now for cmp?
> 
> Nonetheless, I've merged all the fixes together:
>

[snip]

> +#include <linux/module.h>
> +#include <linux/bsearch.h>
> +
> +/*
> + * bsearch - binary search an array of elements
> + * @key: pointer to item being searched for
> + * @base: pointer to data to sort

The comment for "@base" seems wrong. It appears that it should say "pointer to
sorted data" or "pointer to search data" instead.

-mfm
