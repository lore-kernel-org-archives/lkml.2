Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab1AGMFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 07:05:13 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37438 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab1AGMFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 07:05:10 -0500
Date: Fri, 7 Jan 2011 07:04:51 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Crypto Update for 2.6.38
Message-ID: <20110107120451.GA22347@hmsreliant.think-freely.org>
References: <20100519020603.GA19654@gondor.apana.org.au>
 <20100521104404.GA29530@gondor.apana.org.au>
 <20100804140448.GA4042@gondor.apana.org.au>
 <20101024061625.GA23715@gondor.apana.org.au>
 <20110106000157.GA16089@gondor.apana.org.au>
 <AANLkTikzg3Hndp8WRi59bvJdBLxi=p-1gt7aZDLYbSW8@mail.gmail.com>
 <20110106211645.GA26184@gondor.apana.org.au>
 <AANLkTimwaJCUxvMLoeS5Cpmu7FX3y=coeSdkPrrL4zcr@mail.gmail.com>
 <20110106213932.GA26538@gondor.apana.org.au>
 <AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=fggNhMm1LpOzzZ0_ofaU6w=ahX8SMGgFkHCui@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.0 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 02:13:17PM -0800, Linus Torvalds wrote:
> On Thu, Jan 6, 2011 at 1:39 PM, Herbert Xu <herbert@gondor.hengli.com.au> wrote:
> > On Thu, Jan 06, 2011 at 01:23:19PM -0800, Linus Torvalds wrote:
> >>
> >> Explanations of interface. Code. Who uses it? What are the actual
> >> performance benefits on real code?
> >
> > You snipped out the bit in my reply where I expanded on it:
> 
> You didn't expand on it AT ALL.
> 
> You just mentioned "the interface". I haven't seen WHAT THAT INTERFACE IS!
> 
> How hard is that to understand?
> 
> > Here is the original cover email for the patches:
> 
> Ok, this is more like it. This is roughly what I wanted to see:
> 
> > : Here is a sample hash program (note that these only illustrate
> > : what the interface looks like and are not meant to be good examples
> > : of coding :)
> 
> But I'm still missing the part where you show that there is any actual
> use case that makes sense, and that actually improves performance.
> Maybe it's been posted somewhere else, but the thing is, you're asking
> _me_ to pull, and as a result you need to convince _me_ that this is a
> good idea. So if it's been posted/discussed extensively elsewhere,
> please point to those discussions.
> 
> I really don't like adding interfaces that don't have hard uses
> associated with them. We've done it in the past, and it tends to be a
> morass and a bad idea. That's been true even when the idea has been my
> own, and thus obviously genius-level and clearly the RightThing(tm),
> like "splice()". And it's why I push back on new interfaces when I see
> them.
> 
> Btw, it doesn't have to be about performance per se. Does this allow
> people to use keys without actually _seeing_ those keys? Your example
> implies that that is not the case, but that's actually one of the few
> reasons to actually support a kernel crypto interface - the ability to
> have private personal keys around, but not having to actually let
> possibly untrusted programs see them.
> 
This actually is an indirect feature of this interface.  Using it, you can open
a algorithm socket, select a specific alg, assign a key, and then pass that
socket descriptor over a unix socket to an another process using an
SCM_RIGHTS ancilliary message.  The receiving process can then use children
acceppted from that passed socket to preform the configured crypto operation
without any knoweldge of the keys used in it.  I can write a demo app if you
like.

Regards
Neil
 
