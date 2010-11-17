Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab0KQX6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:58:03 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46240 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751658Ab0KQX6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:58:02 -0500
Date: Wed, 17 Nov 2010 23:56:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Valdis.Kletnieks@vt.edu, Lennart Poettering <mzxreary@0pointer.de>,
        linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101117235647.00766e32@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com>
References: <1289922400.1253.3.camel@yio.site>
	<20101116155717.6671e484@lxorguk.ukuu.org.uk>
	<AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
	<20101116171447.29336514@lxorguk.ukuu.org.uk>
	<AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
	<20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
	<20101116213622.GA17824@tango.0pointer.de>
	<20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
	<20101116231023.GB27594@tango.0pointer.de>
	<25482.1290031268@localhost>
	<AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Brilliant conclusion. If you have mounted it, you own it. But you can
> not make your inactive session mount another new one. It's like this
> since ages. Hint: try stuff before hitting reply too fast. :)

Except during the window when screen switching, or of course you could
just ssh in remotely and gdb or similar a process with it as controlling
tty running on your console and issue a vt switch back, then mount it.
Ironically the move from a root owned X server has made that much simpler
to automate, although it was always possible.

Given you can often guess from the idle data if the victim has gone away
from the box it's not ideal. Even better any mess will appear on my
display and get hidden when I flip it back.

The only way to stop that is to make use of the display locking facility
which takes us back where we began in saying that a usable interface is
going to need to lock the display.

At that point the current console owner has to choose to allow the
console to be switched which can be limited effectively to physical
console access and done synchronously. In turn that means to abuse it I
already have physical access to the other users key so could just as
easily steal it and the software security is therefore sufficient.

Alan
