Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab0KRLYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:24:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40727 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751016Ab0KRLYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:24:47 -0500
Date: Thu, 18 Nov 2010 11:23:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dr. Werner Fink" <werner@suse.de>
Cc: Greg KH <greg@kroah.com>, Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101118112335.434de53a@lxorguk.ukuu.org.uk>
In-Reply-To: <20101118110020.GA13871@boole.suse.de>
References: <20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
	<20101116213622.GA17824@tango.0pointer.de>
	<20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
	<20101116231023.GB27594@tango.0pointer.de>
	<25482.1290031268@localhost>
	<AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com>
	<20101117235647.00766e32@lxorguk.ukuu.org.uk>
	<20101118012734.GA8558@kroah.com>
	<20101118014848.GA7873@tango.0pointer.de>
	<20101118015310.GA30480@kroah.com>
	<20101118110020.GA13871@boole.suse.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> is the most pressing case e.g. on s390 or zSeries) and this without
> forcing (and maybe stealing) the controlling tty on the system console
> to be able to detect the primary tty/console.

What do you mean by console in this context

The console in printk context and the "console" in "active vt window" are
unrelated concepts with the same name, so its a bit confusing to follow
here.

> facilities (having device, read, write, and unblank) are also shown
> in the new file /sys/class/tty/console/active ... but maybe Randy
> could says a few words for what this is usable.

The system console does not even need to be a tty device, and on many
embedded devices is not (it may for example by a RAM buffer not wiped
over reboots or it may be jtag or MIPI trace ports.

"tty0" is *currently* a shorthand for "the VT the keyboard/display are
showing". That's a shorthand that in itself will make no sense in future.

Alan
