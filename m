Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2DICiD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:38:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58791 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756563Ab2DICiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:38:00 -0400
Message-ID: <1333939078.2508.19.camel@joe2Laptop>
Subject: Re: [00/02] add BUILD_BUG_DECL assertion (for 3.4??)
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 08 Apr 2012 19:37:58 -0700
In-Reply-To: <CAJfuBxz2fD2KDxpg5gZfGW4bFvuviTG709Aev0=p-ojuzRNpCQ@mail.gmail.com>
References: <1333924698-3894-1-git-send-email-jim.cromie@gmail.com>
	 <1333925535.2508.15.camel@joe2Laptop>
	 <CAJfuBxz2fD2KDxpg5gZfGW4bFvuviTG709Aev0=p-ojuzRNpCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-08 at 17:59 -0600, Jim Cromie wrote:
> On Sun, Apr 8, 2012 at 4:52 PM, Joe Perches <joe@perches.com> wrote:
> > On Sun, 2012-04-08 at 16:38 -0600, Jim Cromie wrote:
> >
> >> this patch (0001) adds new bug.h macro, BUILD_BUG_DECL(name, cond),
> >> which unlike other *BUG* assertions is usable at file scope.  Its
> >> primary purpose is to enforce identical sizes of 2 separate arrays,
> >> which but for considerations of packing/padding/section, would be
> >> together in a struct.
> >>
> >> const char const *names[] = { "bart", "lisa", "homer", "marge" };
> >> int a[] = {1,2,3,4};
> >> int b[] = {1,2,3,5};
> >> long d[] = {1,2};
> >>
> >> BUILD_BUG_DECL(foo, ARRAY_SIZE(a) != ARRAY_SIZE(b));
> >> BUILD_BUG_DECL(buz, sizeof(a) != sizeof(b));  // good
> >> BUILD_BUG_DECL(a, sizeof(a) != sizeof(d));    // ok on x32, error x64
> >> BUILD_BUG_DECL(b, ARRAY_SIZE(a) != ARRAY_SIZE(names));        // good
> >>
> >> macro expands as:
> >> static __attribute__ ((__section__(".init.data"))) struct {
> >>        int BUILD_BUG_DECL_buz[1 - 2*!!(sizeof(a) != sizeof(b))];
> >> } BUILD_BUG_DECL_buz[0] __attribute__((unused));
> >>
> >
> > If possible, it might be better to wrap the
> > declarations themselves in a macro that ensures
> > the sizes are the same.
> >
> > Something like:
> >
> > declare_same_size_arrays(
> >        typeof array1[] = {...},
> >        typeof array2[] = {...}
> > );
> >
> >
> 
> Unless Im mis-reading you, this has a couple disadvantages:
> 
> - bigger patches where its added.
> granted these are mostly whitespace, but theyre less trivial to inspect.

Not a problem in my view, it moves the
related declarations closer together.

> - not useful for array definitions which are not contiguous
> granted thats a minority case, and the definitions could often be moved,
> but not always.

Discontiguous array definitions must be ugly.

> Do you see advantages other than stylistic ones ?

Not really.

Contiguous declarations.
No need for other markings.

Seems useful enough.

