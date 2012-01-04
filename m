Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab2ADIzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 03:55:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2ADIzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 03:55:21 -0500
Date: Wed, 4 Jan 2012 09:55:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jan Steinhoff <mail@jan-steinhoff.de>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Synaptics USB device driver
In-Reply-To: <20120103194033.779cb829@greyhound>
Message-ID: <alpine.LNX.2.00.1201040954000.24984@pobox.suse.cz>
References: <20120103194033.779cb829@greyhound>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jan 2012, Jan Steinhoff wrote:

[ ... snip ... ]
> +static int synusb_setup_iurb(struct synusb *synusb,
> +			     struct usb_endpoint_descriptor *endpoint)
> +{
> +	char *buf;
> +
> +	if (endpoint->wMaxPacketSize < 8)
> +		return 0;
> +	if (synusb->iurb) {
> +		synusb_warn(synusb, "Found more than one possible "
> +				    "int in endpoint");
> +		return 0;
> +	}
> +	synusb->iurb = usb_alloc_urb(0, GFP_KERNEL);
> +	if (synusb->iurb == NULL)
> +		return -ENOMEM;
> +	buf = usb_alloc_coherent(synusb->udev, 8, GFP_ATOMIC,
> +				 &synusb->iurb->transfer_dma);
> +	if (buf == NULL)
> +		return -ENOMEM;

You seem to leak synusb->iurb here.

-- 
Jiri Kosina
SUSE Labs
