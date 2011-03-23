Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab1CWK4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:56:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43254 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932303Ab1CWK4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:56:07 -0400
Date: Wed, 23 Mar 2011 10:56:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: andy.green@linaro.org
Cc: andy@warmcat.com, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
Message-ID: <20110323105607.50697c65@lxorguk.ukuu.org.uk>
In-Reply-To: <4D89CDE4.3000504@linaro.org>
References: <4D79F068.2080009@linaro.org>
	<20110323094720.63e7c6b2@lxorguk.ukuu.org.uk>
	<4D89C618.1020608@linaro.org>
	<201103231132.02690.arnd@arndb.de>
	<4D89CDE4.3000504@linaro.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > rules for the default device name that usbnet assigns. Simply letting
> > a device driver flag "this is always an external ethernet, not
> > a point-to-point connection" would be enough to solve this problem,
> > and take some of the heat out of the discussion for how to solve
> > the MAC address assignment.
> 
> Completely agree, I have a happy feeling being able to say that too. 
> But I already see there's no path through Greg let alone Alan, so it'll 
> have to be dealt with a less good way.

Having a USB net driver flag the fact it knows from its vid/did that it
is probably P2P rather than net (or vice versa) isn't something I see a
problem with, it's probably quite helpful for various network
autoconfigurator guesses. What we don't want however is the kernel
deciding the naming scheme should change. Name tweaks are really policy,
knowing if an interface vid/did say its P2P or net is merely information
that can guide a policy in user space.

Now if your user space uses that flag to issue ifrenames fine, that's
your choice. It's probably sufficient just to set IFF_POINTOPOINT
appropriately on the net interface flags to make all that work ?

Alan
