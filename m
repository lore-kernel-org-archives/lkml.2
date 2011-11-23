Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1KWKtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:49:39 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:48766 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab1KWKth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:49:37 -0500
Message-ID: <1322045373.1753.56.camel@x61.thuisdomein>
Subject: Re: [RFCv1 8/9] xshm: Makefile and Kconfig for M7400 Shared Memory
 Drivers
From: Paul Bolle <pebolle@tiscali.nl>
To: Sjur =?ISO-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 23 Nov 2011 11:49:33 +0100
In-Reply-To: <CAJK669Yfct+-JE3OHBO_=CGuyLfrsyZz-Srm9tjBCajFmvQQEg@mail.gmail.com>
References: <1321883764-1958-1-git-send-email-sjur.brandeland@stericsson.com>
	 <1321883764-1958-9-git-send-email-sjur.brandeland@stericsson.com>
	 <1321907436.32195.25.camel@x61.thuisdomein>
	 <CAJK669Yfct+-JE3OHBO_=CGuyLfrsyZz-Srm9tjBCajFmvQQEg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sjur,

On Mon, 2011-11-21 at 22:15 +0100, Sjur Brændeland wrote:
> >> +++ b/drivers/xshm/Kconfig
> >> @@ -0,0 +1,10 @@
> >> +config XSHM
> >> +     tristate "External Shared Memory Protocol (XSHM)"
> >> +#    depends on GENIO
> >
> > Why is this added commented out?
> 
> A proper GENIO driver is not yet submitted, but will be later on (see
> patch 5/9).
> When this driver is contributed I'm expecting a Kconfig with "config GENIO"
> to show up, that XSHM should depend upon. This comment serves as
> a reminder.

Well, if you feel that reminder is needed please add a short explanation
(in another comment) so it won't be overlooked.

> >> +obj-$(CONFIG_XSHM) +=  xshmchr.o
> >> +xshmchr-objs := xshm_chr.o
> >
> > A quick scan of the other patches didn't show a file named xshmchr.c. If
> > that's correct, can't you rename either the object or the source file?
> Yes, you're right. I'll fix this.
> 
> >
> >> +obj-$(CONFIG_XSHM) += xshm.o
> >> +xshm-objs := xshm_boot.o xshm_pdev.o genio_dummy.o
> >
> > Are these two separate drivers (modules) that both are built if one
> > Kconfig symbol is set?
> 
> Yes, that was the idea.
> 
> >If so, is there a reason why you can't use either
> > one combined driver or two Kconfig symbols?
> 
> xshm exposes devices that can be of type stream or packet,
> while xshm_chr and caif_xshm are drivers for stream and
> packet devices. It looked as a good idea to keep these separate,
> but I'm open for other opinions here. In a real life deployment
> they will all be build-in anyway.

I have no opinion whether or not to use two devices. But if you do use
two devices you might consider exposing them through separate Kconfig
symbols. Perhaps you already did consider that and decided that it would
be of little benefit. Or maybe it's simply not possible. Well, my
message seems just to be to give this some thought.


Paul Bolle

