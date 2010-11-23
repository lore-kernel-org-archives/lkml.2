Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0KWXFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:05:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47378 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752271Ab0KWXFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:05:05 -0500
Date: Tue, 23 Nov 2010 23:03:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Timur Tabi <timur@freescale.com>
Cc: Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: Re: How do I choose an arbitrary minor number for my tty device?
Message-ID: <20101123230359.3c805e2e@lxorguk.ukuu.org.uk>
In-Reply-To: <4CEBF668.2080708@freescale.com>
References: <20101118163321.GA2723@suse.de>
	<4CE5562B.8080604@freescale.com>
	<20101118165136.GA3103@suse.de>
	<4CE55ACB.80207@freescale.com>
	<20101118171856.GA4283@suse.de>
	<4CE5647F.5000203@freescale.com>
	<20101118175832.GA4931@suse.de>
	<4CE58005.7040308@freescale.com>
	<20101118200230.GA25715@suse.de>
	<4CE58736.4090703@freescale.com>
	<20101118201035.GA26287@suse.de>
	<4CE58FE5.3010502@freescale.com>
	<20101118205647.677404ec@lxorguk.ukuu.org.uk>
	<4CEA9B00.1000804@freescale.com>
	<20101123135621.5d100e81@lxorguk.ukuu.org.uk>
	<4CEBF668.2080708@freescale.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you talking about this:
> 
> static struct tty_driver *ehv_bc_console_device(struct console *co, int *index)
> {
> 	*index = co->index;
> 
> 	return ehv_bc_driver;
> }

Yes.

> I never really understood this function, but almost everyone does the same
> thing, and it seems to work for me.  Looking at console_device(), it appears
> that all of the xxx_console_device functions are called in order until one of
> them returns non-NULL.

*index is the minor number to use - so you can return whichever minor
matches your primary interface

> > I suspect in your case you probably want to attach the primary byte
> > channel to minor 0 in the driver (and reserve it for that), or some
> > similar rule.
> 
> Yes, that's a good idea.  It does simplify things a lot.

It's probably the cleanest and simplest solution and it fits the
"natural" order of things.
