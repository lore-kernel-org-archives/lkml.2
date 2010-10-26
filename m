Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab0JZPAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:00:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35959 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754095Ab0JZPAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:00:36 -0400
Date: Tue, 26 Oct 2010 15:59:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend] Add sc16is7x2 driver
Message-ID: <20101026155934.7e70a57c@lxorguk.ukuu.org.uk>
In-Reply-To: <20101026145107.GA18531@kroah.com>
References: <4CAD818B.2070603@iis.fraunhofer.de>
	<20101014190133.GB1009@kroah.com>
	<4CB801B2.808@iis.fraunhofer.de>
	<20101015142709.GA18905@kroah.com>
	<4CB86E8F.3060907@iis.fraunhofer.de>
	<20101015164922.GB21576@kroah.com>
	<4CBC177E.8020407@iis.fraunhofer.de>
	<20101019153748.GB4589@kroah.com>
	<4CC6977C.1020908@iis.fraunhofer.de>
	<20101026145107.GA18531@kroah.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > And huh, "grep -R serial_max3100.h *" gives what? Only max3100.c
> > So do we need to remove serial_max3100.h as it's not used anywhere else?
> 
> Yup, that sounds like a great idea, I'll go queue up that patch when I
> get back from my travels at the moment.

Sounds a very bad idea to me. The point of the platform data objects
throughout the kernel is to allow other devices to use the driver without
having to hack it up. Removing these interfaces breaks that.

So NAK such a change. The existing code is right, the fact that the
interface isn't being used in that way visibly by currently merged code
doesn't mean it shouldn't be there.

Also max3100 has an active maintainer so perhaps you should Cc them on
such discussion ?

Alan
