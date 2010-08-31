Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab0HaLKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:10:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58475 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756649Ab0HaLKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:10:42 -0400
Date: Tue, 31 Aug 2010 12:23:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier.adi@gmail.com>,
        "Michael H. Warfield" <mhw@wittsend.com>
Subject: Re: [RFC 0/5] tty: move stuff around
Message-ID: <20100831122340.7153388f@lxorguk.ukuu.org.uk>
In-Reply-To: <20100831104205.GA2301@bitwizard.nl>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
	<201008302333.22447.arnd@arndb.de>
	<20100830232800.3cb768fc@lxorguk.ukuu.org.uk>
	<201008311126.45190.arnd@arndb.de>
	<20100831104205.GA2301@bitwizard.nl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now I've missed the first part of this discussion... Is there a change
> imminent that requires rewriting of all the drivers?

Mostly locking - it's not a trivial entry point thing. The gs layer for
example was full of races and needed rewriting so just got declared
broken.
 
> (If rewriting serial drivers, PLEASE make it so that the
> userspace-kernel interface just passes a baud rate integer, not the
> one-of-16-possible baudrate-flags. The old stuff can be emulated in a

Did that several years ago. I think you still need to use the ioctl
because several years is apparently a bit short for glibc to get with it
even though a glibc person thought up how to do the new interface 8)

> library. Secondly serial port drivers should NOT have to worry about
> DCD changes and what to do with sleeping processes. The driver should
> have an kernel function to call: "hey, one of the control lines
> changed level. These are the new ones". And "These characters
> arrived". And the driver has an entry point: "please send these
> characters". )

Mostly done. See tty_port_*

Alan
