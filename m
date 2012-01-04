Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2ADJS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 04:18:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab2ADJSy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 04:18:54 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] input: Synaptics USB device driver
Date: Wed, 4 Jan 2012 10:20:41 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Jan Steinhoff <mail@jan-steinhoff.de>,
        Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20120103194033.779cb829@greyhound> <alpine.LNX.2.00.1201040954000.24984@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1201040954000.24984@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201041020.41795.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 4. Januar 2012, 09:55:19 schrieb Jiri Kosina:
> On Tue, 3 Jan 2012, Jan Steinhoff wrote:
> 
> [ ... snip ... ]
> > +static int synusb_setup_iurb(struct synusb *synusb,
> > +                          struct usb_endpoint_descriptor *endpoint)
> > +{
> > +     char *buf;
> > +
> > +     if (endpoint->wMaxPacketSize < 8)
> > +             return 0;
> > +     if (synusb->iurb) {
> > +             synusb_warn(synusb, "Found more than one possible "
> > +                                 "int in endpoint");
> > +             return 0;
> > +     }
> > +     synusb->iurb = usb_alloc_urb(0, GFP_KERNEL);
> > +     if (synusb->iurb == NULL)
> > +             return -ENOMEM;
> > +     buf = usb_alloc_coherent(synusb->udev, 8, GFP_ATOMIC,
> > +                              &synusb->iurb->transfer_dma);
> > +     if (buf == NULL)
> > +             return -ENOMEM;
> 
> You seem to leak synusb->iurb here.

Seems so, but doesn't. It gets freed when the refcount hits 0.
Now, whether this is a good technique is another question.

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
