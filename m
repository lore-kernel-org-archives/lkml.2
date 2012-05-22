Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2EVWK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:10:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58328 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2EVWK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:10:27 -0400
Date: Tue, 22 May 2012 15:10:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Hans de Goede <hdegoede@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-hid-core: Set intfdata to NULL if probe fails
Message-ID: <20120522221017.GA12874@kroah.com>
References: <1337629176-1624-1-git-send-email-hdegoede@redhat.com>
 <4FBB469B.50801@suse.cz>
 <4FBB49CE.9020408@redhat.com>
 <4FBB4E51.6020607@suse.cz>
 <4FBB5D4C.9090804@redhat.com>
 <alpine.LNX.2.00.1205230000070.30445@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1205230000070.30445@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 12:00:37AM +0200, Jiri Kosina wrote:
> On Tue, 22 May 2012, Hans de Goede wrote:
> 
> > Well then lets work towards making it guaranteed, since I still believe
> > the following holds true:
> > 1) drvdata is for a driver to store a pointer to driver specific data
> > 2) If no driver is bound, there is no driver specific data associated with
> >    the device
> > 3) Thus logically drvdata should be NULL if no driver is bound.
> > 
> > I'll do a patch for the USB-core to ensure that intfdata gets set to NULL
> > on probe failure.
> 
> Hans,
> 
> I believe this is a good thing per se, but shouldn't this rather be done 
> in driver core, to guarantee that this hold across all buses?

Maybe, but that would require that the driver core set the field to NULL
after every probe call that fails?  Is that really necessary to fix up
bugs in different bus subsystems that forget to clean up properly?

I'm not saying it's a bad thing to change it there, it just seems a bit
heavy-handed for a very rare event.

thanks,

greg k-h
