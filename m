Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab1INVlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 17:41:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48868 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341Ab1INVlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 17:41:18 -0400
MIME-Version: 1.0
Reply-To: doug@easyco.com
In-Reply-To: <20110914194040.37ed38c9@lxorguk.ukuu.org.uk>
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
Date: Wed, 14 Sep 2011 14:34:50 -0700
X-Google-Sender-Auth: Gvh8RF6b7gfDIsN3S5z9-HkLGiw
Message-ID: <CAFx4rwR2LgMZ8x8aCPa=FnPF0yCOH+7=HbX8OENdbZoMUzO59g@mail.gmail.com>
Subject: Re: [PATCH 1/2] block: export __make_request
From: Doug Dumitru <doug@easyco.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org, nab@linux-iscsi.org,
        ryanh@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 11:40 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 14 Sep 2011 10:53:22 -0700
> Doug Dumitru <doug@easyco.com> wrote:
>
>> It would be great if this function were exported, but I would
>> encourage everyone to consider exporting it generally, not just for
>> GPL usage.
>
> That would require a licensing change for the kernel. The kernel is a GPL
> work. Some of us have not licensed it in any other way.

Alan,

I agree with you, in part.  What you are saying implies that no new
EXPORT can ever happen.  If you wrote this function, then obviously,
you can choose to export it GPL only.  Likewise, if you wrote this
function, considering it's location in the block IO layer, I would ask
that you consider exporting it generally.

This does not change the GPL nature of the kernel.  It does change how
non GPL modules can interact with the kernel.  There are some (and I
am not sure if this includes you), that believe that all commercial
license kernel modules violate the GPL.  Other believe that they are
legal, but perhaps not desirable.  Others believe there is no issue.

Again, my request was just a polite request to consider the sub-system
when deciding on whether an EXPORT or EXPORT_GPL was more appropriate.

>> The kernel seems to be pretty clean that some subsystems are GPL only
>> (things like sysfs), and some are open
>
> The _GPL is meant to make it clear they are internal symbols. The lack of
> an _GPL does not make them usable by non GPL code, it merely indicates
> that its perhaps more likely that you could in some cases shown something
> was not a derivative work.

I don't think this is true, at least from a practical point.  If you
develop a commercial module, you can link to the kernel through public
symbols.  These symbols, and the kernels header files, define a public
API that is usable from commercial modules.  Provided that the
techniques used inside of the commercial module were not "derived
from" the rest of the kernel, using the API is acceptable.

When a symbol is not exported publicly, then, pretty much by
definition, it is not a part of the public API.  This creates kernel
functionality that is unreachable from a commercial module, regardless
of whether the commercial module is derived or not.  As such, the
EXPORT_GPL has the effect of being even more stringent than the GPL
license itself.  With an EXPORT_GPL, the author is saying that this
API is not available to commercial modules even if the commercial
software is not a derivative work.

> The licensing is determined by the license document, and that very
> clearly says the boundary is derivative works. The rest is just vague
> guidance.

I am very careful about what is a derivative work.  I am also careful
about honoring author's "desires" as to how stuff gets exported.
Right now, the block IO layer has a pretty clean, published, API with
adequate public symbols to get real work done, either from GPL or
commercial licensed modules.  If useful functions are walled off,
then this does not change the derivative nature, but just degrades the
usefulness of the kernel.  This would be like exporting kmalloc() as
an open symbol, but exporting kfree() as GPL only.

I guess another way of saying this is that if you are creating a new
entry into an existing, published API, and the API keeps caller/called
at "arms length" (which the block IO layer does), then it is possible
to create a work that uses the API but is not a derivative, and
hopefully the new symbol will be declared accessible to everyone.

> In addition btw please be careful when trying to do this even with non
> derivative code your lawyer is happy with. The kernel contains algorithms
> which are subject to various US software patent mess where GPL use has
> been granted, that may impact you if you use such code indirectly in non
> GPL code.

Understood, but, in all fairness, the US patent mess is far worse and
I suspect that breathing violates someones claim.

> Alan

Again, I was not trying to create a contentious issue.  I was just
asking that new exports consider what is around them, and try to
maintain some consistency of GPL vs open exports.  A function that
submits a block IO request seems to be a good candidate for an open
API which implies an open export.

-- 
Doug Dumitru
EasyCo LLC
