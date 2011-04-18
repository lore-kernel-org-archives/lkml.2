Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab1DRM0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 08:26:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38444 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752903Ab1DRM0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 08:26:00 -0400
Date: Mon, 18 Apr 2011 13:26:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ben Nizette <bn@niasdigital.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Message-ID: <20110418132629.12d9a106@lxorguk.ukuu.org.uk>
In-Reply-To: <92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com>
	<3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com>
	<20110418091902.13345132@lxorguk.ukuu.org.uk>
	<92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fair call, but bringing this back to the particular case in hand what in that enum is worth 'hinting' in a might-have-an-effect manner rather than just letting the board take care of it?
> 
> Still my question stands, where is the driver ever better placed to make these calls than the board code?

The logical extension to that is to delete the gpio layer because the
board code can do it ?

> > Also your comment re simply in or out on or off is incorrect. Pins may
> > also be in use by firmware and the like and in a 'neither' state.
> > Something certain gpio people seem to be in denial over.
> 
> Quite right, but should a pin ever be in a neither state and simultaneously controlled by a gpiolib driver?  If so, how should it behave and if not, is it anything that stricter enforcement of gpio_request() semantics can't get around?

That won't fix sysfs.

It also doesn't solve the real problem which is that you've got to
implement platform specific parallel gpio extensions all over the place
when you really want it all using the same 'handle' and request logic.

The gpio layer doesn't seem to know what it is doing. It's a fine resource
allocator and call distributor but it can't make up its mind whether it
wants to just do that job, or to be a proper extensible gpio layer.
Instead it sits there being almost useful but incomplete and unwilling to
either do the job needed or get out of the way.

One possible way to tackle a lot of it would be to actually let the
drivers make the choices instead of imposing arbitarily wrong sematics
in the upper layers.

And for a lot of this stuff that the gpio layer really doesn't want
internal knowledge of other chunks of the kernel have used models like
'get_property/set_property' (eg battery, video4linux etc) so that the mid
layer can plumb in a conversation between the handle owner and the driver
without getting involved in the conversation.

Alan
