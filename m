Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab1CKTed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:34:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45871 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751284Ab1CKTec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:34:32 -0500
Date: Fri, 11 Mar 2011 19:34:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg Brigley <gbrigley@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to use gma500 framebuffer driver?
Message-ID: <20110311193440.754b9636@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTikwjHbPWp5xwZFLStEupck46mFw5dqEUcQOXiD6@mail.gmail.com>
References: <AANLkTikwjHbPWp5xwZFLStEupck46mFw5dqEUcQOXiD6@mail.gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 0e83f46d3869a5255a04b875bb885bd141a609ef, from Feb 26 - the last
> commit on drivers/staging/gma500, and now I can build successfully,
> but have not succeeded in producing video output.

Currently it works on the Dell mini 10 and some other panels, but I know
it's not yet working on quite a few other setups.

> I guess I'll start by saying what I'm trying to do, to make sure I'm
> not misguided in trying this in the first place.  I want to run Xfbdev
> and drive both an LVDS and HDMI display at the same time (mirrored).
> I don't need 2d or 3d acceleration.  I don't see an indication that
> anyone else has tried mirrored displays with this driver, and I don't
> mind being the first, but should it work in theory?  If it's not
> supported, would it be difficult to add?

It's on the todo list, as is non mirrored dual display.

> So here are my questions for those who have used the staging driver:
> * Should I be compiling it as a module, or as part of the kernel?

Either - it's probably best tested as a module for the moment

> * If I'm compiling it as a module, is there some sort of incantation
> to make the framebuffer device show up when I insert the module?

That would be the default behaviour providing it manages to set up the
port. If it doesn't it will stay in text mode

> Currently, when I insmod psb_gfx.ko, nothing appears in /proc/fb, or
> in /dev.  I'm using udev.  If I do "mknod /dev/fb0 c 29 0", then both
> fbset and Xfbdev give me "no such device" errors.

What shows up in "dmesg" ?

Alan
