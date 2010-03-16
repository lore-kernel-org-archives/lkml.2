Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966208Ab0CPN0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:26:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966190Ab0CPN0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:26:19 -0400
Date: Tue, 16 Mar 2010 14:26:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       daniel.ritz@gmx.ch, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@vger.kernel.org
Subject: Re: usbtouchscreen: support bigger iNexio touchscreens
In-Reply-To: <201003161423.54495.linux@rainbow-software.org>
Message-ID: <alpine.LRH.2.00.1003161425480.26353@twin.jikos.cz>
References: <201003161423.54495.linux@rainbow-software.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding some more relevant CCs ]

On Tue, 16 Mar 2010, Ondrej Zary wrote:

> Bigger Nexio touchscreens not only send more data but also the header values
> are modified somehow. Fix the header somehow (it's a guesswork but it works
> at least on one 46" touchscreen with 2.00SMS firmware) and also increase
> rept_size.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> --- linux-2.6.34-rc1-orig/drivers/input/touchscreen/usbtouchscreen.c	2010-03-16 13:34:51.000000000 +0100
> +++ linux-2.6.34-rc1/drivers/input/touchscreen/usbtouchscreen.c	2010-03-16 13:46:15.000000000 +0100
> @@ -858,6 +858,11 @@
>  	if ((pkt[0] & 0xe0) != 0xe0)
>  		return 0;
>  
> +	if (be16_to_cpu(packet->data_len) > 0xff)
> +		packet->data_len = cpu_to_be16(be16_to_cpu(packet->data_len) - 0x100);
> +	if (be16_to_cpu(packet->x_len) > 0xff)
> +		packet->x_len = cpu_to_be16(be16_to_cpu(packet->x_len) - 0x80);
> +
>  	/* send ACK */
>  	ret = usb_submit_urb(priv->ack, GFP_ATOMIC);
>  
> @@ -1113,7 +1118,7 @@
>  
>  #ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
>  	[DEVTYPE_NEXIO] = {
> -		.rept_size	= 128,
> +		.rept_size	= 1024,
>  		.irq_always	= true,
>  		.read_data	= nexio_read_data,
>  		.init		= nexio_init,
> 
> 
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

