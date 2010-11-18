Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab0KROme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:42:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58846 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758685Ab0KROmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:42:33 -0500
Date: Thu, 18 Nov 2010 14:41:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Dr. Werner Fink" <werner@suse.de>
Cc: Greg KH <greg@kroah.com>, Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101118144123.5417ccbd@lxorguk.ukuu.org.uk>
In-Reply-To: <20101118131420.GA23872@boole.suse.de>
References: <25482.1290031268@localhost>
	<AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com>
	<20101117235647.00766e32@lxorguk.ukuu.org.uk>
	<20101118012734.GA8558@kroah.com>
	<20101118014848.GA7873@tango.0pointer.de>
	<20101118015310.GA30480@kroah.com>
	<20101118110020.GA13871@boole.suse.de>
	<20101118112335.434de53a@lxorguk.ukuu.org.uk>
	<20101118121256.GA19884@boole.suse.de>
	<20101118125822.16718289@lxorguk.ukuu.org.uk>
	<20101118131420.GA23872@boole.suse.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How can I detect the major and minor of the primary console device
> of /dev/console without controlling tty?  Even if my old blogd

In the general case you can't - because a console may not have a tty.
Quite a few don't. For the cases where one has a device I can't see a
clean way to do it as an fstat on the console device will give you the
console major/mninor and some code depends upon that.

The iniability to get it is clearly a flaw and you need the sysfs link or
a sysfs list of consoles (again remembering many of them won't have a tty
bound).

> and the bootlogd(8) of SysInitV using TIOCCONS are outdated by SystemD
> the question before doing the TIOCCONS is which is the primary console
> device to e.g. create the device node in initrd or for bootlogd(8)
> to write a copy of the console messages back to the original
> primary console (and the other console devices).

For init it is /dev/console as opened at boot time and passed to the
initial user init task but with no nice way to work back to a device node.

Incidentally the primary console (as in printk) can be accessed as a tty
via the ttyprintk driver which got added recently because embedded people
wanted to use the printk interface as a (write only) tty console as well.




