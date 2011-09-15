Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469Ab1IOS64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:58:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37232 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934457Ab1IOS6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:58:53 -0400
Date: Thu, 15 Sep 2011 19:58:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Alex Deucher <alexdeucher@gmail.com>, Keith Packard <keithp@keithp.com>,
        linux-fbdev@vger.kernel.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Archit Taneja <archit@ti.com>, "Clark, Rob" <rob@ti.com>
Subject: Re: Proposal for a low-level Linux display framework
Message-ID: <20110915195804.4e6d965b@lxorguk.ukuu.org.uk>
In-Reply-To: <4E724659.5080709@gmx.de>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<4E724659.5080709@gmx.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, I rather think that the fb API is more user centric to allow every program
> to use it directly in contrast to the KMS/DRM API which aims to support every
> feature the hardware has. For this the fb API should not change much, but I
> understand some additions were needed for some special users, probably limited
> to X and wayland.

Wayland needs vblank frame buffer switching and the like. Likewise given
you want to composite buffers really any serious accelerated device ends
up needing a full memory manager and that ends up needing a buffer
manager. Wayland needs clients to be doing their own rendering into
objects which means authorisation and management of the render engine
which ends up looking much like DRM.

> One of my biggest problems with KMS is that it has (naturally) a lot more
> complexity than the fb API which leads to instability. Basically it's very

It shouldn't do - and a sample of one (your machine) is not a
statistically valid set. Fb is pretty much ununsable in contrast on my
main box, but that's not a statistically valid sample either.

I'm not that convinced by the complexity either. For a simple video card
setup such as those that the fb layer can kind of cope with (ie linear
buffer, simple mode changes, no client rendering, no vblank flipping,
limited mode management, no serious multi-head) a DRM driver is also
pretty tiny and simple.

> Well, I think it's too late to really fix this thing. We now have 3 APIs in the
> kernel that have to be kept. Probably the best we can do now is figure out how
> we can reduce code duplication and do extensions to those APIs in a way that
> they are compatible with each other or completely independent and can be used
> across the APIs.

I think it comes down to 'when nobody is using the old fb drivers they can
drop into staging and oblivion'. Right now the fb layer is essentially
compatibility glue on most modern x86 platforms.

Alan
