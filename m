Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab2GWQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 12:28:25 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44802 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab2GWQ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 12:28:23 -0400
Date: Mon, 23 Jul 2012 17:32:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 02/12] usb: fix sillies in the metro USB driver
Message-ID: <20120723173201.5724b9d0@pyramind.ukuu.org.uk>
In-Reply-To: <4FE78B62.4090106@suse.cz>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
	<20120622153655.1405.21453.stgit@localhost.localdomain>
	<4FE78B62.4090106@suse.cz>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2012 23:49:22 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> On 06/22/2012 05:38 PM, Alan Cox wrote:
> > Bits noticed doing the termios conversion
> > 
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > ---
> > 
> >  drivers/usb/serial/metro-usb.c |    8 +-------
> >  1 file changed, 1 insertion(+), 7 deletions(-)
> > 
> > diff --git a/drivers/usb/serial/metro-usb.c b/drivers/usb/serial/metro-usb.c
> > index 81423f7..bad5f0c 100644
> > --- a/drivers/usb/serial/metro-usb.c
> > +++ b/drivers/usb/serial/metro-usb.c
> > @@ -130,20 +130,14 @@ static void metrousb_read_int_callback(struct urb *urb)
> ...
> >  	if (tty && urb->actual_length) {
> >  		/* Loop through the data copying each byte to the tty layer. */
> >  		tty_insert_flip_string(tty, data, urb->actual_length);
> >  
> >  		/* Force the data to the tty layer. */
> >  		tty_flip_buffer_push(tty);
> > +		tty_kref_put(tty);
> >  	}
> > -	tty_kref_put(tty);
> 
> This doesn't seem right. (Depends on whether tty is non-null iff
> urb->actual_length is non-zero.)

Doh fixed.. queued
