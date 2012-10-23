Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab2JWJrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:47:03 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49911 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab2JWJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:47:01 -0400
Date: Tue, 23 Oct 2012 10:51:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, devel@driverdev.osuosl.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] staging: Add firewire-serial driver
Message-ID: <20121023105140.5996c3a5@pyramind.ukuu.org.uk>
In-Reply-To: <1350959679.2621.55.camel@thor>
References: <1350565015.23730.4.camel@thor>
	<20121022224505.GD24489@kroah.com>
	<1350959679.2621.55.camel@thor>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. The ldisc drops the contents of tty_buffer on hangup (rather than
> waiting for completion). Maybe for other devices this isn't so
> noticeable because the ldisc can mostly keep up with the device, but on
> firewire the ldisc lags well behind. Right now, this driver works around
> this by holding off the hangup until the ldisc empties the tty_buffer.
> The driver determines how much data is still left in the tty_buffer by
> walking the flip buffers.

The driver should not be trying to look at this, so it's good that it
broke now. If you need it to process the data on then hangup then the
core code wants fixing to allow this to occur.

> 2. Because this driver can fill the entire tty_buffer (64K +) before the
> ldisc even runs once, this driver has to self-throttle when feeding the
> tty_buffer.

That wants investigating properly. We do multiple megabits quite happily
via the tty layer with 3G modems over USB. What is your data rate ?

Again it wants dealing with properly.

Alan
