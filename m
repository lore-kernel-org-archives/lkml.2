Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab0JAUud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:50:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:48886 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab0JAUuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:50:32 -0400
Subject: Re: Introduce support for little endian PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        paulus@samba.org, linux-kernel@vger.kernel.org,
        Ian Munsie <imunsie@au1.ibm.com>
In-Reply-To: <1285950041.15020.272.camel@thor.local>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	 <2C5357FA-F87F-457E-B5C1-0DCC5A842DE7@kernel.crashing.org>
	 <AANLkTinSDMvBb7rnnfwYMkEVOgDUqRetZg86rh-UmSAg@mail.gmail.com>
	 <1285935283.2463.78.camel@pasglop>  <1285950041.15020.272.camel@thor.local>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 06:50:04 +1000
Message-ID: <1285966204.2463.137.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 18:20 +0200, Michel Dänzer wrote:
> On Fre, 2010-10-01 at 22:14 +1000, Benjamin Herrenschmidt wrote: 
> > 
> > Now, the main reasons in practice are anything touching graphics.
> > 
> > There's quite a few IP cores out there for SoCs that don't have HW
> > swappers, and -tons- of more or less ugly code that can't deal with non
> > native pixel ordering (hell, even Xorg isn't good at it, we really only
> > support cards that have HW swappers today).
> 
> That's not true. Even the radeon driver doesn't really need the HW
> swappers anymore with KMS.

And last I looked X still pukes if you give it a pixmap in non native
byte order but that might have been fixed. In any case, X is far from
the target here. More like existing stacks for embedded SoCs, including
codecs etc... all written for LE.

> > There's an even bigger pile of application code that deals with graphics
> > without any regard for endianness and is essentially unfixable.
> 
> Out of curiosity, what kind of APIs are those apps using? X11 and OpenGL
> have well-defined semantics wrt endianness, allowing the drivers to
> handle any necessary byte swapping internally, and IME the vast majority
> of apps handle this correctly.

So why is it so hard to get any video card working on ppc ? :-) I
haven't even started to look at r6xx which -does- have HW swapping
capabilities...

In this case tho, see above. I don't even need to care much about the
details, customers are making the point over and over again. It might be
fixable, but either they don't have the resources to fix it or don't
want to fix it, or their -own- customers won't chose their product if
it's BE for "perceived" difficulty of porting reason, whether they are
valid or not.

So it boils down to do we want to be another Amiga sinking into oblivion
but keeping our purity intact, or do we make that "reasonably easy"
thing to support LE at least at the kernel level for now, and -possibly-
give powerpc a bit more juice on the market for a while longer ?

Cheers,
Ben.


