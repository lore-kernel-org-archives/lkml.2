Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab0LYVpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 16:45:06 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:17025 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab0LYVpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 16:45:04 -0500
Date: Sat, 25 Dec 2010 22:35:20 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Sage Weil <sage@newdream.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Ceph: Fix a use-after-free bug in
 ceph_destroy_client().
In-Reply-To: <AANLkTincx8rSM+72czJ+tTrG=D=aOJLBb9nd9Jt_RsD2@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1012252234340.10759@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012251914370.10759@swampdragon.chaosbits.net> <AANLkTik+yrpY8T69w_RQ84ZbRqwkjvFhvxHLBvU14N3f@mail.gmail.com> <alpine.LNX.2.00.1012252223380.10759@swampdragon.chaosbits.net>
 <AANLkTincx8rSM+72czJ+tTrG=D=aOJLBb9nd9Jt_RsD2@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Dec 2010, richard -rw- weinberger wrote:

> On Sat, Dec 25, 2010 at 10:24 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > On Sat, 25 Dec 2010, richard -rw- weinberger wrote:
> >
> >> On Sat, Dec 25, 2010 at 7:17 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> >> > Hello,
> >> >
> >> > In net/ceph/ceph_common.c::ceph_destroy_client() the pointer 'client' is
> >> > freed by kfree() and subsequently used in a call to dout() - use after
> >> > free bug.
> >>
> >> Not really. %p reads only the address of "client".
> >> kfree() does not alter this address.
> >>
> >
> > Ok, I see your point and you are correct. But still, the patch does not
> > change behaviour and it makes it absolutely clear that there's no
> > use-after-free bug, so it might still have merit... or?
> 
> Your patch does not fix a bug.
> I would say it's a style fix.
> 
At this point in time I'd agree. :-)

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

