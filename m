Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab2APTx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:53:26 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38911 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2APTxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:53:23 -0500
Date: Mon, 16 Jan 2012 19:54:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates for 3.3
Message-ID: <20120116195427.64edd96f@pyramind.ukuu.org.uk>
In-Reply-To: <CA+55aFxNcAtCmzEejS=3+_L_rp-MOBS0yLS061YgiCsFw_Mt5Q@mail.gmail.com>
References: <20120109003255.GA6598@havoc.gtf.org>
	<CA+55aFwcBQSoWfqdT9CxV=GAr5ex0=RnqtBDFty+=_Lua2VXGw@mail.gmail.com>
	<4F12E57E.3090805@garzik.org>
	<1326676534.13517.3.camel@minggr>
	<1326691403.13517.21.camel@minggr>
	<CA+55aFzqECJjbtgyOXy_H1smh09SsfgrAuVY7hK2sC-xj1GZHg@mail.gmail.com>
	<20120116194211.2cd09fb3@pyramind.ukuu.org.uk>
	<CA+55aFxNcAtCmzEejS=3+_L_rp-MOBS0yLS061YgiCsFw_Mt5Q@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jan 2012 11:47:12 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Jan 16, 2012 at 11:42 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> > There are two sets of problems with that
> >
> > The first is that quite a few machines crap themselves if you do this
> > because nobody has ever tested things like the IRQ routing or the
> > firmware on suspend/resume when they find the hardwared controller has
> > gone for a walk.
> 
> I think this could trivially be solved at least on these kinds of
> Apple machines by just making it a config option, and just not doing
> it if it doesn't work. Some kernel command line to say "ahci=force" or
> whatever.

There are patches for this from way back including a white list of
devices that were tested

Just ping Matthew about

http://www.codon.org.uk/~mjg59/tmp/ahci_quirk_cleanup.diff

> That doesn't solve the "user never even realized" problem, but at
> least it gives the user the possibility of solving the "crap firmware
> doesn't even allow this".

For the "memory found over 4GB" case it may even be worth printing a
warning.

> > Putting it back on suspend might help in some cases but then you get to
> > pick your way through the documentation minefield, deal with device
> > changes while in non AHCI mode, figure out how to set up registers the
> > BIOS didn't etc.
> 
> Yeah, no, that would just be horrible. I doubt it happens in practice,
> though.  I bet the normal PCI/AHCI resume will just do the right
> thing. But I haven't tried..

Some BIOSes go off and try and re-unlock the drive with the bios password
etc. They get most unhappy when the controller isn't in the mode they
expected. Matthew used a white list for some he tested which didn't have
problems. Most netbooks seem ok with it.

Alan
