Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1EDOnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:43:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56838 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753883Ab1EDOns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:43:48 -0400
Date: Wed, 4 May 2011 15:44:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, tglx@linutronix.de, arnd@arndb.de,
        nico@fluxnic.net
Subject: Re: [PATCHv3 0/7] gpio: extend basic_mmio_gpio for different
 controllers
Message-ID: <20110504154440.1674adb9@lxorguk.ukuu.org.uk>
In-Reply-To: <20110504143757.GB15967@pulham.picochip.com>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
	<20110503210950.GA2866@ponder.secretlab.ca>
	<BANLkTi=5Ad7_9_fVMCcJ7MfM5Ns8q9qqsQ@mail.gmail.com>
	<20110503215211.GA8491@oksana.dev.rtsoft.ru>
	<20110503220408.GA6978@pulham.picochip.com>
	<20110503223415.GA14024@oksana.dev.rtsoft.ru>
	<20110504110939.GB13514@pulham.picochip.com>
	<20110504113131.GA639@oksana.dev.rtsoft.ru>
	<20110504143757.GB15967@pulham.picochip.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, so here's what I've got so far (patches attached).  I've updated the 
> basic_mmio_gpio library with your initial lkml patch and updated it to 
> allow bgpio_chip to be embedded in another structure.  I've also 
> attempted to convert over the bt8xx and langwell drivers but they're a 
> little rough around the edges in places (and untested as I don't have 
> the hardware).

Looking at the Langwell driver you replace 130 lines of code that do the
job, with 126 lines of code that do setup for a whole extra module which
makes it bigger and slower as well as much harder to maintain.

That sounds to me like for Langwell at least it is not worth doing
because all you've done is added complexity, indirection and overhead. So
NAK the Langwell one.

The bt8xx looks a nice example of one of the cases where it will help
however.

Alan
