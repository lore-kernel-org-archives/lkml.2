Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab2FFHfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:35:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab2FFHfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:35:30 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: stefani@seibold.net
Subject: Re: [PATCH] fix usb skeleton driver
Date: Wed, 6 Jun 2012 09:32:15 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk
References: <1338966036-30443-1-git-send-email-stefani@seibold.net>
In-Reply-To: <1338966036-30443-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206060932.15984.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. Juni 2012, 09:00:36 schrieb stefani@seibold.net:
> @@ -126,32 +122,21 @@ exit:
>  
>  static int skel_release(struct inode *inode, struct file *file)
>  {
> -       struct usb_skel *dev;
> -
> -       dev = file->private_data;
> -       if (dev == NULL)
> -               return -ENODEV;
> +       struct usb_skel *dev = file->private_data;
>  
>         /* allow the device to be autosuspended */
> -       mutex_lock(&dev->io_mutex);
> -       if (dev->interface)
> -               usb_autopm_put_interface(dev->interface);
> -       mutex_unlock(&dev->io_mutex);
> +       usb_autopm_put_interface(dev->interface);

That is a bug. You must check for disconnect here, because
after a disconnect the interface may be bound already to another
driver.

	Regards
		Oliver
