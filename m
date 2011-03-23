Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702Ab1CWLew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 07:34:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39854 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932689Ab1CWLet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 07:34:49 -0400
Date: Wed, 23 Mar 2011 11:34:55 +0000
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
Message-ID: <20110323113455.59492e24@lxorguk.ukuu.org.uk>
In-Reply-To: <4D89D5EB.50803@linaro.org>
References: <4D79F068.2080009@linaro.org>
	<20110323094720.63e7c6b2@lxorguk.ukuu.org.uk>
	<4D89C618.1020608@linaro.org>
	<201103231132.02690.arnd@arndb.de>
	<4D89CDE4.3000504@linaro.org>
	<20110323105607.50697c65@lxorguk.ukuu.org.uk>
	<4D89D5EB.50803@linaro.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> business to know, but that the usb device on the specific wired-up USB 
> port to the RJ45 soldered on the board should be guided a particular way 
> when the interface name is registered.  That can only be done properly 
> in-kernel by passing in a flag to usbnet specific to the device instance 
> to guide its choice.

To my mind the MAC case is a bit different to the name case. It's really
not about policy in that situation it's a USB widget with a non standard
"retrieve mac address" method.

You could fix it up in user space from firmware tables, or in either from
looking in your device tree.

There is one way you could actually hide all this in your board specific
gunge at the moment without touching the core kernel I think. Take a look
at how register_netdev_notifier() works.

That will give you a NETDEV_REGISTER event for each device being
registered so you can then pick out your usb network device.

It might need some slightly unclean knowledge of the usb net driver in
your glue but in the short term until there is a nice device tree type
answer it would allow you to get your MAC address set up properly I
think ?

Alan
