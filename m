Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480Ab2FGJV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:21:27 -0400
Received: from www84.your-server.de ([213.133.104.84]:45363 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2FGJVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:21:25 -0400
Message-ID: <1339060906.11583.9.camel@wall-e>
Subject: Re: [PATCH 02/13] code cleanup
From: Stefani Seibold <stefani@seibold.net>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de,
        linux-usb@vger.kernel.org
Date: Thu, 07 Jun 2012 11:21:46 +0200
In-Reply-To: <877gvjtrsf.fsf@nemi.mork.no>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
	 <1339057243-10029-3-git-send-email-stefani@seibold.net>
	 <877gvjtrsf.fsf@nemi.mork.no>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 07.06.2012, 11:06 +0200 schrieb Bjørn Mork:
> stefani@seibold.net writes:
> 
> > @@ -95,15 +93,12 @@ static int skel_open(struct inode *inode, struct file *file)
> >  	if (!interface) {
> >  		pr_err("%s - error, can't find device for minor %d\n",
> >  			__func__, subminor);
> > -		retval = -ENODEV;
> > -		goto exit;
> > +		return -ENODEV;
> >  	}
> 
> 
> This may save you a line, but that line was there for a reason...
> 
> Using a common exit path for errors makes it easier to keep unlocking,
> deallocation and other cleanups correct.  Although you *can* do that
> change now, you introduce future bugs here.  Someone adding a lock
> before this will now have to go through all the error paths to ensure
> that they unlock before exiting.
> 
> See "Chapter 7: Centralized exiting of functions" in
> Documentation/CodingStyle.
> 

If it is necessary... I get alway ten different complains from six
developers. Developer A says do it in this way, developer B do it in the
other way.

> Focus on creating a *good* example.  Compacting the code is not
> necessarily improving the code...
> 

Compacting improves since it will make the code more readable.

> 
> 
> >  	/* verify that we actually have some data to write */
> > -	if (count == 0)
> > -		goto exit;
> > +	if (!count)
> > +		return 0;
> 
> zero-testing is discussed over and over again, and is a matter of
> taste. But I fail to see how changing it can be part of a cleanup.  It
> just changes the flavour to suit another taste.  What's the reason for
> doing that?
> 

Consistency - there are a lot places in the driver skeleton handling
this in the same way.



