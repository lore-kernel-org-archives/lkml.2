Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab2HXNLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:11:06 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59879 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab2HXNLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:11:01 -0400
Date: Fri, 24 Aug 2012 14:15:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joe Millenbach <jmillenbach@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>, team-fjord@googlegroups.com
Subject: Re: [PATCH] tty: Added a CONFIG_TTY option to allow removal of TTY
Message-ID: <20120824141537.63274081@pyramind.ukuu.org.uk>
In-Reply-To: <CADwDc1BgCM9AA4T3mUxfOGNaNoYwERP-x4y2ZS4mAhfF-K_qzA@mail.gmail.com>
References: <1345499431-21658-1-git-send-email-jmillenbach@gmail.com>
	<20120821142047.777e4bb0@pyramind.ukuu.org.uk>
	<CADwDc1AvCvWbj8znN-1WbkZA9WYVAqaTkxi7+ENZfJ-qFNRAvw@mail.gmail.com>
	<CADwDc1BgCM9AA4T3mUxfOGNaNoYwERP-x4y2ZS4mAhfF-K_qzA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2012 18:14:48 -0700
Joe Millenbach <jmillenbach@gmail.com> wrote:

> ---------- Forwarded message ----------
> From: Joe Millenbach <jmillenbach@gmail.com>
> Date: Thu, Aug 23, 2012 at 5:56 PM
> Subject: Re: [PATCH] tty: Added a CONFIG_TTY option to allow removal of TTY
> To: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Cox
> <alan@linux.intel.com>, linux-serial@vger.kernel.org,
> linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
> team-fjord@googlegroups.com
> 
> 
> On Tue, Aug 21, 2012 at 6:20 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >
> > ...
> >
> > >  config MOUSE_PS2
> > >       tristate "PS/2 mouse"
> > > +     depends on TTY
> >
> > It shouldn't. It would be good to understand why this occurs.
> 
> 
> If I enable this config option, and turn off TTY I get the below errors.
> 
> drivers/built-in.o: In function `serport_ldisc_read':
> serport.c:(.text+0x1aace6): undefined reference to `tty_name'
> serport.c:(.text+0x1aad57): undefined reference to `tty_name'
> drivers/built-in.o: In function `serport_init':
> serport.c:(.init.text+0x8478): undefined reference to `tty_register_ldisc'
> drivers/built-in.o: In function `serport_exit':
> serport.c:(.exit.text+0xb29): undefined reference to `tty_unregister_ldisc'
> 
> All because MOUSE_PS2 depends on SERIO, just like a lot of entries I
> blocked.  I assume this means I should keep the dependency on TTY.
> Unfortunately, I don't have time to dig deeper for the true cause of the
> dependency right now.

The true cause I think is that serio/serport.c should depend on tty to be
built but the ps/2 mouse bits shouldn't.

Alan
