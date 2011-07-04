Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab1GDQ7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:59:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36066 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755997Ab1GDQ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:59:42 -0400
Date: Mon, 4 Jul 2011 18:02:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 7/7] serial/8250: make PIO support optional
Message-ID: <20110704180216.4dc9c79d@lxorguk.ukuu.org.uk>
In-Reply-To: <201107041835.22660.arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
	<201106281352.01459.arnd@arndb.de>
	<20110628132255.71dcb72a@lxorguk.ukuu.org.uk>
	<201107041835.22660.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Where I failed so far is the dynamic configuration of ports using
> setserial. This intentionally allows changing the io_type setting
> as well as the actual resources (ioport, mapbase, irq, ...).
> Changing the io_type is not supported by /bin/setserial, but
> other tools might be doing it.
> My question is whether we should still care about those. If
> we can remove the reconfiguration of existing ports or move
> it to one of the more obscure parts of the driver, it's possible
> to confine the dependencies on the ioport_ops to the front-end
> drivers, while the core 8250 library driver would not need it
> any more.

otherwise you need a table that drivers register their port types
in and to take module references on the table entry to pin the relevant
driver code ?
 
> Today, most ports don't set the UPF_FIXED flag, even though
> the ports definitely have fixed resources, e.g. all of the
> 8250-platform drivers in arch/ or the 8250_pnp and 8250_cs
> front-ends. Do you think it would be reasonable to mark all
> 8250 ports except the ISA ones as UPF_FIXED, and move the
> reconfiguration logic into the 8250_isa driver along with
> old_serial_port, serial8250_isa_devs,  and
> serial8250_isa_init_ports?

I suspect one or two people will scream about some peculiar configuration
that should be handled automatically anyway and those are best fixed
properly if so rather than by allowing setserial incantations to work
around stuff like unknown PCI idents

