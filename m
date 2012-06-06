Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab2FFT6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 15:58:55 -0400
Received: from www84.your-server.de ([213.133.104.84]:53966 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2FFT6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 15:58:53 -0400
Message-ID: <1339012753.3437.2.camel@wall-e>
Subject: Re: [PATCH 01/11] fix wrong label in skel_open
From: Stefani Seibold <stefani@seibold.net>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
Date: Wed, 06 Jun 2012 21:59:13 +0200
In-Reply-To: <201206062052.57385.oliver@neukum.org>
References: <1339000032-10313-1-git-send-email-stefani@seibold.net>
	 <1339000032-10313-2-git-send-email-stefani@seibold.net>
	 <201206062052.57385.oliver@neukum.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 06.06.2012, 20:52 +0200 schrieb Oliver Neukum:
> Am Mittwoch, 6. Juni 2012, 18:27:02 schrieb stefani@seibold.net:
> > From: Stefani Seibold <stefani@seibold.net>
> 
> Thank you for putting the effort to even split this up.
> It makes it much easier to review.
>  
> > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > ---
> >  drivers/usb/usb-skeleton.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
> > index 0616f23..a57f1d2 100644
> > --- a/drivers/usb/usb-skeleton.c
> > +++ b/drivers/usb/usb-skeleton.c
> > @@ -114,7 +114,7 @@ static int skel_open(struct inode *inode, struct file *file)
> >  
> >  	retval = usb_autopm_get_interface(interface);
> >  	if (retval)
> > -		goto out_err;
> > +		goto exit;
> 
> Are you removing io_mutex? If not, the correct fix is a second label
> to drop the lock, not changing the label.  
> 

You are right. The skeleton driver was not compile clean and i already
fixted this. But due the split into smaller patches this was lost.

Anyway it will be fixed with the Patch 09/11] "Synchronize disconnect()
handler with open() and release(), to fix races".


