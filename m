Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2G1QTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 12:19:18 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52712 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752507Ab2G1QTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 12:19:17 -0400
Date: Sat, 28 Jul 2012 12:19:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Daniel Mack <zonque@gmail.com>
cc: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        Sarbojit Ganguly <unixman.linuxboy@gmail.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: Kernel Oops while disconnecting USB peripheral (always)
In-Reply-To: <5013E074.20007@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1207281218190.23545-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2012, Daniel Mack wrote:

> Hmm, interesting. Thanks for sharing this. I personally never saw this
> bug kicking in, but if I understand your findings correctly, we would
> need something like the following patch for snd-usb and the storage driver?
> 
> Sarbojit, could you give this a test and see whether your kernel still
> crashes in any of the two drivers?


> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -1025,9 +1025,14 @@ void usb_stor_disconnect(struct usb_interface *intf)
>  {
>         struct us_data *us = usb_get_intfdata(intf);
> 
> +       if (!us)
> +               return;

This can never happen.  The disconnect routine gets called only once, 
so us will not be NULL.

> +
>         US_DEBUGP("storage_disconnect() called\n");
>         quiesce_and_remove_host(us);
>         release_everything(us);
> +
> +       usb_set_intfdata(intf, NULL);
>  }
>  EXPORT_SYMBOL_GPL(usb_stor_disconnect);

Alan Stern

