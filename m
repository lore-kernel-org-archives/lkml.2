Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab2EGQju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:39:50 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33612 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab2EGQjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:39:49 -0400
Date: Mon, 7 May 2012 17:42:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 3/3] tty_lock: Localise the lock
Message-ID: <20120507174240.4209c5cb@pyramind.ukuu.org.uk>
In-Reply-To: <1336408208.3638.15.camel@lappy>
References: <20120503212151.568.91854.stgit@bob.linux.org.uk>
	<20120503212219.568.15653.stgit@bob.linux.org.uk>
	<CA+1xoqezLCQh_fqJ1iNAs25X7Fm24W=-0J8zTZuVVJQnWTtSLg@mail.gmail.com>
	<20120507171126.5beddc27@pyramind.ukuu.org.uk>
	<1336408208.3638.15.camel@lappy>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 May 2012 18:30:08 +0200
Sasha Levin <levinsasha928@gmail.com> wrote:

> On Mon, 2012-05-07 at 17:11 +0100, Alan Cox wrote:
> > > I don't believe that this change is correct.
> > > 
> > > Consider the following scenario:
> > > 
> > > tty_release -> tty_lock -> pty_close -> tty_vhangup -> tty_lock
> > 
> > We hang up tty->link not tty.
> > 
> > It's now a per tty lock. So I think we are ok.
> 
> Unless we can cause tty->link == tty, in which case:


We should not be able to cause tty->link == tty. So that's a different
problem altogether.

tty->link is set to point to the other half of the pty in pty_install and
in pty98_unix_install. It's never assigned to the same tty and ptys
simply wouldn't work if this wasn't the case.

So whatever your trace is showing, that's not the bug. Something more
complicated would appear to be afoot.

Alan


