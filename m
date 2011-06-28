Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab1F1MV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:21:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55898 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757144Ab1F1MU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 08:20:28 -0400
Date: Tue, 28 Jun 2011 13:22:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 7/7] serial/8250: make PIO support optional
Message-ID: <20110628132255.71dcb72a@lxorguk.ukuu.org.uk>
In-Reply-To: <201106281352.01459.arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
	<1309211120-2803-8-git-send-email-arnd@arndb.de>
	<20110628110500.1cf60104@lxorguk.ukuu.org.uk>
	<201106281352.01459.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I got this done for all the obscure ones in patches 1-6, leaving
> only the common UPIO_PORT and UPIO_MEM ones. Changing those would
> mean a lot more churn, and also solving a few other problems:

Yes I like 1-5 ...

> I would much prefer getting a build error on inb/outb for the latter
> kind than having to provide bogus definitions in a lot of architectures.
> For request_region, it's probably better to stub out the macro than
> the users.

Agreed but that can be done by io_serial_in/io_serial_out out of the
8250.c file. Really we need p->ops or a function in another file which
provides the ioport 8250 interface and then all you'd have in the core
code would be

	uart8250_set_ioport_ops(p);

which would live in 8250_ioport.c or be a "return -EINVAL' for anything
else. 

That leaves request/release_std resources depending how such platforms
handle request_region attempts, and the other fourport bits which want
pushing into the 8250f_fourport driver perhaps as extra p-> ops.

	if (p->startup)
		p->startup(p);

etc

(Or indeed probably a p->ops-> for the lot is even saner)



Thoughts ?
