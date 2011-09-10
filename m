Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab1IJDM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 23:12:59 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37678 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab1IJDM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 23:12:58 -0400
Date: Sat, 10 Sep 2011 05:12:51 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jesper Andersen <jespera@diku.dk>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Hauke Mehrtens <hauke@hauke-m.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Backporting the Linux kernel, for good - was: Re: semantic patch
 inference
In-Reply-To: <CA+RMdsmEJRv8i81o_GD6o7Bn0MpQJMidghTnt3f-QEeU6V6eNQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1109100512190.14019@ask.diku.dk>
References: <CAB=NE6U0ks9CobukO04=bZpnkm3Yw+Pf7keVPsP-hv1NyJZ_Xw@mail.gmail.com>
 <Pine.LNX.4.64.1109092245170.9242@ask.diku.dk>
 <CA+RMdsmEJRv8i81o_GD6o7Bn0MpQJMidghTnt3f-QEeU6V6eNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Sep 2011, Jesper Andersen wrote:

> I'm in Singapore now and will head for Denmark tomorrow so I can't promise
> very instant reponses.
> 
> I haven't read the full thread just yet, but I just wanted to clarify one
> thing:
> 
> On Saturday, September 10, 2011, Julia Lawall wrote:
> >
> > There was also the question about one or multiple types of changes.  I
> > think this is not a problem, but Jesper should confirm.  If a patch
> > contains
> > two changes and one can be generalized and the other one cannot for some
> > reason, does spdiff give up on the whole thing, or does it do what it can?
> >
> >
> It's a little difficult to answer this precisely, so let me instead give an
> example and then you can say in what way my example falls short of what you
> thought of.
> 
> Suppose we have two functions that changed:
> 
> f1=
> void foo() {
>   bar(x->dev);
>   foz(117);
> }
> 
> f2=
> void goo() {
>   if(b) bar(y->dev);
> }
> 
> 
> And the new versions are:
> 
> f1'=
> void foo() {
>   bar(x);
>   foz(117, 42);
> }
> 
> f2'=
> void goo() {
>   if(b) bar(y);
> }
> 
> In this example there are basically three changes:
> 
> x->dev becomes x
> y->dev becomes y
> foz(117) becomes foz(117', 42)
> 
> In this case spdiff will find: (I just ran it to be sure)
> @@
> expression X0;
> @@
> - bar(X0->dev);
> + bar(X0);
> 
> So the one ungeneralizable change was simply not included. Does this cover
> your question Julia?

That seems good.  But perhaps the user would like to know about the 
elements that were not generalizable as well.

julia
