Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab0IXXW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 19:22:59 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:57444 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424Ab0IXXW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 19:22:57 -0400
Date: Fri, 24 Sep 2010 16:21:56 -0700
From: matt mooney <mfm@muteddisk.com>
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        usb-storage@lists.one-eyed-alien.net,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>,
        David Vrabel <david.vrabel@csr.com>, Michal Marek <mmarek@suse.cz>
Subject: Re: [usb-storage] [PATCH 23/24] usb: change to new flag variable
Message-ID: <20100924232156.GB8191@haskell.muteddisk.com>
Mail-Followup-To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
	kernel-janitors@vger.kernel.org,
	David Brownell <dbrownell@users.sourceforge.net>,
	usb-storage@lists.one-eyed-alien.net,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>,
	David Vrabel <david.vrabel@csr.com>, Michal Marek <mmarek@suse.cz>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
 <1dd0f4a1709a9b139fe87f2b311cc0d129900b3f.1285355033.git.mfm@muteddisk.com>
 <20100924200218.GC25677@one-eyed-alien.net>
 <20100924202823.GB4598@haskell.muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924202823.GB4598@haskell.muteddisk.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:28 Fri 24 Sep     , matt mooney wrote:
> On 13:02 Fri 24 Sep     , Matthew Dharm wrote:
> > On Fri, Sep 24, 2010 at 12:17:33PM -0700, matt mooney wrote:
> > > Replace EXTRA_CFLAGS with ccflags-y.
> > 
> > > diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
> > > index ef7e5a8..786f086 100644
> > > --- a/drivers/usb/storage/Makefile
> > >
> +++ b/drivers/usb/storage/Makefile
> > > @@ -5,7 +5,7 @@
> > >  # Rewritten to use lists instead of if-statements.
> > >  #
> > >  
> > > -EXTRA_CFLAGS	:= -Idrivers/scsi
> > > +ccflags-y	:= -Idrivers/scsi
> > >  
> > >  obj-$(CONFIG_USB_STORAGE)	+= usb-storage.o
> > 
> > I don't really know anything about the new 'ccflags' stuff.. but my
> > instincts tell me that perhaps that should be
> > 'ccflags-$(CONFIG_USB_STORAGE)' rather than 'ccflags-y'?
> 
> The flag has the same effect as EXTRA_CFLAGS in that it will be used to build
> all  sources at the same hierarchical level (i.e., per directory not including
> subdirectories). I didn't want to change the semantics of the way the variable
> was being used, but after looking at the Kconfig it seems that would be a
> reasonable change. If only usb-storage needs the flag then it makes sense,
> though it seems that everything else in the directory relies on usb-storage
> anyway, but it gives it greater meaning knowing that only usb-storage relies on
> the flag, IMHO.
> 
> > 
> > Does it make a difference that usb-storage can be built-in or a loadable
> > module?
> 
> That would make a difference because ccflags-m is not used, so the change is not
> possible.
 
I failed to mention earlier that there is a per file flag. If you really only
want usb-storage.o built with the flag, you can do:

CFLAGS_usb-storage.o := -Idrivers/scsi

-mfm
