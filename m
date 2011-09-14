Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab1INWCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 18:02:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37820 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933412Ab1INWCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 18:02:23 -0400
Date: Wed, 14 Sep 2011 23:01:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: doug@easyco.com
Cc: Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org, nab@linux-iscsi.org,
        ryanh@us.ibm.com
Subject: Re: [PATCH 1/2] block: export __make_request
Message-ID: <20110914230104.51c03fa6@lxorguk.ukuu.org.uk>
In-Reply-To: <CAFx4rwR2LgMZ8x8aCPa=FnPF0yCOH+7=HbX8OENdbZoMUzO59g@mail.gmail.com>
References: <20110911145053.GA28996@infradead.org>
	<4E6DD7F0.8020903@kernel.dk>
	<20110912122507.GA12229@infradead.org>
	<4E6DFA8C.3030400@kernel.dk>
	<20110912133826.GA22548@infradead.org>
	<4E6E49BE.6020005@kernel.dk>
	<20110913211911.GA13894@infradead.org>
	<4E70E1C1.8040907@panasas.com>
	<CAFx4rwR=EnCVfi4Pzm9pmTtKWAdzvzOg7wwzBbzZN7YTvu5-fw@mail.gmail.com>
	<20110914194040.37ed38c9@lxorguk.ukuu.org.uk>
	<CAFx4rwR2LgMZ8x8aCPa=FnPF0yCOH+7=HbX8OENdbZoMUzO59g@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree with you, in part.  What you are saying implies that no new
> EXPORT can ever happen.  If you wrote this function, then obviously,

No.

> you can choose to export it GPL only.  Likewise, if you wrote this
> function, considering it's location in the block IO layer, I would ask
> that you consider exporting it generally.

The kernel is GPL, any work that is derivative is subject to the licence,
any work which is not is generally not subject to the licence.

> I don't think this is true, at least from a practical point.  If you
> develop a commercial module, you can link to the kernel through public
> symbols.  These symbols, and the kernels header files, define a public

You can create commercial modules but their licence must be GPL
compatible including source etc if they are derivative in any way. At
least that is what my lawyer advises me.

Possibly you mean "proprietary" here. The GPL welcomes people making
money out of things, it just rejects theft of freedoms given by other
parties.

> API that is usable from commercial modules.  Provided that the
> techniques used inside of the commercial module were not "derived
> from" the rest of the kernel, using the API is acceptable.

I'm not sure derivative works law is quite so clear cut, but then
'provide a clear concise definition of derivative works' appears to be
the legal version of The Goldbach Conjecture.

> When a symbol is not exported publicly, then, pretty much by
> definition, it is not a part of the public API.  This creates kernel

Not the view of the legal advice I have

> Again, I was not trying to create a contentious issue.  I was just
> asking that new exports consider what is around them, and try to
> maintain some consistency of GPL vs open exports.  A function that
> submits a block IO request seems to be a good candidate for an open
> API which implies an open export.

It's a GPL kernel, so to me the question is really moot.

I'm not trying to create contention. The reason I reply now and then to
these kinds of discussions is that I've been advised by my lawyer to do
so, because anyone who then produces a violating module who has seen this
message either as a recipient or if it turns up in a trawl can them be
subject to triple damages for wilful infringement - should it turn out
that the work is violating and they do not in turn have a good legal
assessment with which to show they did in fact take good care (and which
of course might well happen because derivative works are such a grey
fuzzy mess)

Whether it says EXPORT_SYMBOL, EXPORT_SYMBOL_GPL or RUBBERIZED_BANANA is
to my understanding irrelevant. If it does turn out to be relevant
however you are correct I'd make all my symbols _GPL....

Alan
