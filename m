Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab0JAMO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:14:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:42265 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab0JAMO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:14:58 -0400
Subject: Re: Introduce support for little endian PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, paulus@samba.org,
        linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinSDMvBb7rnnfwYMkEVOgDUqRetZg86rh-UmSAg@mail.gmail.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
	 <2C5357FA-F87F-457E-B5C1-0DCC5A842DE7@kernel.crashing.org>
	 <AANLkTinSDMvBb7rnnfwYMkEVOgDUqRetZg86rh-UmSAg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 22:14:43 +1000
Message-ID: <1285935283.2463.78.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 07:30 -0400, Josh Boyer wrote:
> 
> > From a community aspect is anyone actually going to use this?  Is
> this going to be the equivalent of voyager on x86?  I've got nothing
> against some of the endian clean ups this introduces.  However the
> changes to misc_32.S are a bit ugly from a readability point of view.
>  Just seems like this is likely to bit-rot pretty quickly.
> 
> I'm with Kumar on this one.  Why would we want to support this?  I
> can't say I would be very willing to help anyone run in LE mode, let
> alone have it randomly selectable. 

There's some good reasons on the field ... sadly.

At this stage this is mostly an experiment, which went pretty well in
the sense that it's actually quite easy and a lot of the "fixes" are
actually reasonable cleanups to carry.

Now, the main reasons in practice are anything touching graphics.

There's quite a few IP cores out there for SoCs that don't have HW
swappers, and -tons- of more or less ugly code that can't deal with non
native pixel ordering (hell, even Xorg isn't good at it, we really only
support cards that have HW swappers today).

There's an even bigger pile of application code that deals with graphics
without any regard for endianness and is essentially unfixable.

So it becomes a matter of potential customers that will take it if it
does LE and won't if it doesn't ...

Now, I don't have a problem supporting that as the maintainer, as I
said, from a kernel standpoint, it's all quite easy to deal with. Some
of the most gory aspects in misc_32.S could probably be done in a way
that is slightly more readable, but the approach is actually good, I
think, to have macros to represent the high/low parts of register pairs.

So at this stage, I'd say, let's not dismiss it just because we all come
from a long education of hating LE for the sake of it :-)

It makes -some- sense, even if it's not necessarily on the markets
targeted by FSL today for example. At least from the kernel POV, it
doesn't seem to me to be a significant support burden at all.

Cheers,
Ben.


