Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab0LAOmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:42:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab0LAOmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:42:37 -0500
Date: Wed, 1 Dec 2010 09:42:35 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add rb_next in block throttle
Message-ID: <20101201144234.GD4672@redhat.com>
References: <AANLkTimV=6=Je=k6UW=ivJtmR0ONoTrscM2i8YJd5JjA@mail.gmail.com>
 <20101130143631.GC26758@redhat.com>
 <AANLkTimAAr7PgH85G+yqOXwdExRUHbZm3HXz0WsRjLuW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimAAr7PgH85G+yqOXwdExRUHbZm3HXz0WsRjLuW@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 09:11:01PM +0800, Hillf Danton wrote:
> On Tue, Nov 30, 2010 at 10:36 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Nov 26, 2010 at 10:06:27PM +0800, Hillf Danton wrote:
> >> When selecting group for dispatching, the first entry of the service
> >> tree is sequentially dequeued, then the first entry is recomputed by
> >> calling rb_first().
> >>
> >> When the first is removed from service tree, new first could also be
> >> computed with rb_next(), since it could be faster than rb_first in
> >> this special environment.
> >>
> >> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> >> ---
> >
> > Ok. So set the leftmost element with the help of rb_next() at the time of
> > deletion of existing leftmost element. Not sure whether it is cheaper or
> > not but does not harm doing it this way.
> >
> > Have you tested it to make sure nothing is broken?
> 
> Hm..if broken, we rush out and gnarl at Andrea Arcangeli as loud as we could.
> 

Well, some testing is always good. This looks simple enough though.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> Thanks
> Hillf
> >
> > Thanks
> > Vivek
> >
> >>
> >> --- a/block/blk-throttle.c    2010-11-01 19:54:12.000000000 +0800
> >> +++ b/block/blk-throttle.c    2010-11-26 21:27:40.000000000 +0800
> >> @@ -251,7 +251,7 @@ static void rb_erase_init(struct rb_node
> >>  static void throtl_rb_erase(struct rb_node *n, struct throtl_rb_root *root)
> >>  {
> >>       if (root->left == n)
> >> -             root->left = NULL;
> >> +             root->left = rb_next(n);
> >>       rb_erase_init(n, &root->rb);
> >>       --root->count;
> >>  }
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >
