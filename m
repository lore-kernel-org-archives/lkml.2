Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab0H2XA7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 19:00:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44697 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754018Ab0H2XA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 19:00:58 -0400
Date: Mon, 30 Aug 2010 00:18:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] tty: move stuff around
Message-ID: <20100830001855.1071b6fc@lxorguk.ukuu.org.uk>
In-Reply-To: <1283115995-4734-1-git-send-email-arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Of course, moving stuff around always has the tendency to
> break patches against it, so we might not want to do this after
> all.
> 
> Any other opinions?

Linus actually suggested this should get done in some form a while ago
back when I was tty maintainer but about the same time as I decided not
to be.

>   tty: move tty layer code to drivers/tty

I would be tempted to put the core stuff in /tty as its not drivers

>   tty/vt: move files to drivers/tty/vt/
>   tty/hvc: move files to drivers/tty/hvc
>   tty/hw: move hardware drivers to drivers/tty/hw
>   tty: rearrange Kconfig structure

drivers/serial should also walk into tty I think ?

drivers/pcmcia/serial is a bit trickier but I guess should stay as with
drivers/usb/serial

There are several unbuildable ancient drivers. Perhaps if we are having
the great rename those should simply get deleted first, as there is no
way to test them in their current config ?
