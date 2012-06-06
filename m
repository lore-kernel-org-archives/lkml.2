Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2FFMSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 08:18:04 -0400
Received: from www84.your-server.de ([213.133.104.84]:43439 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab2FFMSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 08:18:00 -0400
Message-ID: <1338985098.6961.2.camel@wall-e>
Subject: Re: [PATCH] fix usb skeleton driver
From: Stefani Seibold <stefani@seibold.net>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk
Date: Wed, 06 Jun 2012 14:18:18 +0200
In-Reply-To: <201206060932.15984.oneukum@suse.de>
References: <1338966036-30443-1-git-send-email-stefani@seibold.net>
	 <201206060932.15984.oneukum@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 06.06.2012, 09:32 +0200 schrieb Oliver Neukum:
> Am Mittwoch, 6. Juni 2012, 09:00:36 schrieb stefani@seibold.net:
> > @@ -126,32 +122,21 @@ exit:
> >  
> >  static int skel_release(struct inode *inode, struct file *file)
> >  {
> > -       struct usb_skel *dev;
> > -
> > -       dev = file->private_data;
> > -       if (dev == NULL)
> > -               return -ENODEV;
> > +       struct usb_skel *dev = file->private_data;
> >  
> >         /* allow the device to be autosuspended */
> > -       mutex_lock(&dev->io_mutex);
> > -       if (dev->interface)
> > -               usb_autopm_put_interface(dev->interface);
> > -       mutex_unlock(&dev->io_mutex);
> > +       usb_autopm_put_interface(dev->interface);
> 
> That is a bug. You must check for disconnect here, because
> after a disconnect the interface may be bound already to another
> driver.
> 
> 	Regards
> 		Oliver

Yes, you are right.

But as i now figured out, the whole usb_skeleton.c drivers is full of
races in the skel_open and skel_release path.

I will send a clean and tested patch set in the next few days.

Greetings,
Stefani


