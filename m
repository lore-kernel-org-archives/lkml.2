Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab1LLJB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 04:01:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1LLJB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 04:01:26 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: "Henrik Rydberg" <rydberg@euromail.se>
Subject: Re: [PATCH] Input: bcm5974 - Fix USB autosuspend
Date: Mon, 12 Dec 2011 10:02:52 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
References: <1323680764-2155-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1323680764-2155-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112121002.53004.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. Dezember 2011, 10:06:04 schrieb Henrik Rydberg:
> @@ -895,6 +857,10 @@ static int bcm5974_probe(struct usb_interface *iface,
>         /* save our data pointer in this interface device */
>         usb_set_intfdata(iface, dev);
>  
> +       error = bcm5974_start_traffic(dev);
> +       if (error)
> +               goto err_free_buffer;
> +
>         return 0;
>  
>  err_free_buffer:
> -- 

Why do you want to start traffic before open() in probe() ?
It doesn't make sense to ask a device to deliver data nobody
wants.

	Regards
		Oliver
