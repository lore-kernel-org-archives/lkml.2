Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564Ab1CDLwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:52:49 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56531 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759519Ab1CDLwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:52:47 -0500
Date: Fri, 4 Mar 2011 11:49:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steffen Sledz <sledz@dresearch.de>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
        Mario Schuknecht <m.schuknecht@dresearch.de>,
        "Fred N. van Kempen" <waltje@uWalt.NL.Mugnet.ORG>,
        Mark Evans <evansmp@uhura.aston.ac.uk>,
        Corey Minyard <wf-rch!minyard@relay.EU.net>,
        Florian La Roche <flla@stud.uni-sb.de>,
        Charles Hedrick <hedrick@klinzhai.rutgers.edu>,
        Linus Torvalds <torvalds@cs.helsinki.fi>,
        Alan Cox <gw4pts@gw4pts.ampr.org>,
        Matthew Dillon <dillon@apollo.west.oic.com>,
        Arnt Gulbrandsen <arnt@gulbrandsen.priv.no>,
        Jorge Cwik <jorge@laser.satlink.net>,
        Matthew Dillon <dillon@crater.dragonflybsd.org>,
        Alan Cox <alc@FreeBSD.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Charles Hedrick <hedrick@rutgers.edu>,
        "" <Fred.van.Kempen@microwalt.nl>
Subject: Re: [PATCH] tcp: ioctl type SIOCOUTQNSD returns amount of data not
 sent
Message-ID: <20110304114937.6ae1b203@lxorguk.ukuu.org.uk>
In-Reply-To: <4D64FA12.4070800@dresearch.de>
References: <1286271154-18600-1-git-send-email-m.schuknecht@dresearch.de>
	<4D64FA12.4070800@dresearch.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 13:14:10 +0100
Steffen Sledz <sledz@dresearch.de> wrote:

> Am 05.10.2010 11:32, schrieb Mario Schuknecht:
> > In contrast to SIOCOUTQ which returns the amount of data sent
> > but not yet acknowledged plus data not yet sent this patch only
> > returns the data not sent.
> > 
> > For various methods of live streaming bitrate control it may
> > be helpful to know how much data are in the tcp outqueue are
> > not sent yet.
> > 
> > Signed-off-by: Mario Schuknecht <m.schuknecht@dresearch.de>
> > ---
> >  include/asm-generic/ioctls.h |    1 +
> >  include/linux/sockios.h      |    1 +
> >  net/ipv4/tcp.c               |    9 +++++++++
> >  3 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
> > index a321665..b87115b 100644
> > --- a/include/asm-generic/ioctls.h
> > +++ b/include/asm-generic/ioctls.h
> > @@ -72,6 +72,7 @@
> >  #define TCSETXF		0x5434
> >  #define TCSETXW		0x5435
> >  #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
> > +#define TIOCOUTQNSD	0x5437

These are tty not socket ioctl codes. For various historical reasons some
of them got sort of emulated by the socket layer in Unix and thus in
Linux.

If you plan to add one to Linux then please post the accompanying *tty
layer* patches and reasoning, otherwise if it is socket only please stick
to the socket ioctl.

Alan
