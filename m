Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0H3Mmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:42:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58506 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751920Ab0H3Mmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:42:50 -0400
Date: Mon, 30 Aug 2010 14:00:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/5] tty: move stuff around
Message-ID: <20100830140054.294a15f1@lxorguk.ukuu.org.uk>
In-Reply-To: <201008301415.56934.arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
	<201008301337.27672.arnd@arndb.de>
	<4C7B9C1D.9030207@suse.cz>
	<201008301415.56934.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010 14:15:56 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 30 August 2010, Jiri Slaby wrote:
> > On 08/30/2010 01:37 PM, Arnd Bergmann wrote:
> > > These are the drivers I was planning to move:
> > > +obj-$(CONFIG_CYCLADES)         += cyclades.o
> > 
> > There are some users still with CYY cards. No CYZ card users known to me.
> > 
> > > +obj-$(CONFIG_MOXA_INTELLIO)    += moxa.o
> > 
> > Maybe few users left.
> > 
> > > +obj-$(CONFIG_MOXA_SMARTIO)     += mxser.o
> > 
> > Still in use. (And supports relatively new devices; not the PCI-e ones
> > though.)
> 
> Are they all candidates for a conversion to serial_core then?
> Or are they not sufficiently 8250-like?

Please don't convert stuff to serial_core - it's got some horrible
problems with adapting to the new locking model, its buffering model
pre-dates kfifo and all in all serial_core needs a rewrite not more users.
