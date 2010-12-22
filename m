Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab0LVASL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:18:11 -0500
Received: from kroah.org ([198.145.64.141]:44447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab0LVASK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:18:10 -0500
Date: Tue, 21 Dec 2010 16:19:07 -0800
From: Greg KH <greg@kroah.com>
To: Melchior FRANZ <melchior.franz@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] USB: add support for Dream Cheeky DL100B Webmail
 Notifier (1d34:0004)
Message-ID: <20101222001907.GA16255@kroah.com>
References: <201012220058.43366@rk-nord.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012220058.43366@rk-nord.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 12:58:42AM +0100, Melchior FRANZ wrote:
> Greg: I hope I understood your instructions correctly.  :-)
> 
> Some notes:
> - I increased the file's version number (1.1 -> 1.2). Hope that's OK.

Actually, you could just remove it, it's pretty pointless :)

> - There were two differently capitalized ENOMEM messages with the same
>   contents before, and as I had to add a third one, I de-capitalized one
>   for consistency reasons.

That's fine.

> - The patch removes the three color #define-s, as they are no longer
>   suitable on the top level, and puts the values directly in the code.
>   This should be clear enough, as the respective color is mentioned
>   in the line before. (I considered to use "const" values or an enum,
>   but both generated different, more verbose code.)

That's fine too.

> Please review again and consider for inclusion. (The patch is diffed
> against 2.6.36.2.)

I would, but it looks like you didn't test this patch out by building it
as the following line really would not compile properly at all, right:

> +		retval = usb_control_msg(led->udev,
> +					usb_sndctrlpipe(led->udev, 0),
> +					0x09,
> +					0x21,
> +					0x200, The price difference to Delcom's thingy lets you a lot of room. :-)
> +					0,
> +					buffer,
> +					8,
> +					2000);

I think you might want to fix that up :)

Care to resend?

Third times a charm?

thanks,

greg k-h
