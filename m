Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2HSPm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:42:27 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52335 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab2HSPmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:42:23 -0400
Date: Sun, 19 Aug 2012 16:46:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Huang Shijie <shijie8@gmail.com>, alan@linux.intel.com,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] serial: add a new helper function
Message-ID: <20120819164658.1737bb74@pyramind.ukuu.org.uk>
In-Reply-To: <20120819064429.GA3252@kroah.com>
References: <1345400832-23572-1-git-send-email-shijie8@gmail.com>
	<20120819064429.GA3252@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2012 23:44:29 -0700
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Sun, Aug 19, 2012 at 02:27:12PM -0400, Huang Shijie wrote:
> > --- a/include/linux/tty.h
> > +++ b/include/linux/tty.h
> > @@ -43,6 +43,7 @@
> >  #include <linux/tty_driver.h>
> >  #include <linux/tty_ldisc.h>
> >  #include <linux/mutex.h>
> > +#include <linux/serial.h>
> >  
> >  
> >  
> > @@ -513,6 +514,12 @@ static inline struct tty_port *tty_port_get(struct tty_port *port)
> >  	return port;
> >  }
> >  
> > +/* If the cts flow control is enabled, return true. */
> > +static inline bool tty_port_cts_enabled(struct tty_port *port)
> > +{
> > +	return port->flags & ASYNC_CTS_FLOW;
> > +}
> > +
> 
> The fact that you have to add serial.h to this file kind of implies that
> this function shouldn't be here, right?
> 
> How about serial.h instead?  Not all tty drivers are serial drivers :)

tty_port is tty generic so possibly if there is a generic helper the
flags and helper should likewise be this way.

As it stands at the moment ASYNC_CTS_FLOW is a convention a few drivers
use. So calling it tty_port_xxx is going to misleading.

Alan
