Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab0IUQvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:51:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:35902 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab0IUQvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:51:10 -0400
Date: Tue, 21 Sep 2010 09:50:48 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, Phil Turmel <philip@turmel.org>,
        Mat <jackdachef@gmail.com>, Guillaume Chazarain <guichaz@gmail.com>,
        linux-kernel@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        Alan Ott <alan@signal11.us>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, Andreas Bombe <aeb@debian.org>,
        Alex Riesen <raa.lkml@gmail.com>,
        Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st
 insert, ignored on 2nd insert, lsusb stuck at usbdev_open
Message-ID: <20100921165048.GB8756@suse.de>
References: <alpine.LNX.2.00.1009211156520.26813@pobox.suse.cz>
 <Pine.LNX.4.44L0.1009211013460.1644-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1009211013460.1644-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 10:30:18AM -0400, Alan Stern wrote:
> On Tue, 21 Sep 2010, Jiri Kosina wrote:
> 
> > I have just found out that it's actually CONFIG_USB_DYNAMIC_MINORS which 
> > makes the difference. When unset, the problem doesn't trigger, and 
> > usb_find_interface() always returns the proper interface. When 
> > CONFIG_USB_DYNAMIC_MINORS is being used, the oops happen.
> > 
> > I'll look into that.
> 
> Apparently the problem is that intf->minors doesn't get initialized 
> properly.  This patch should fix it.  Everybody, please try it out.

Wow, what happened to suddenly cause this?  Nothing has changed here in
a long time.

wierd.

thanks,

greg k-h
