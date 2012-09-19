Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2ISON3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 10:13:29 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39743 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751721Ab2ISONV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 10:13:21 -0400
X-Sasl-enc: Y1Ha/Pd4FwRCE+Ky/VMfze7c3cwxfCASxOSV1hVwjLaT 1348064000
Date: Wed, 19 Sep 2012 15:13:16 +0100
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the usb tree
Message-ID: <20120919141316.GA19526@kroah.com>
References: <20120919143136.46dd2318963c0d8524492041@canb.auug.org.au>
 <20120919145925.35e95b5a@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919145925.35e95b5a@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 02:59:25PM +0100, Alan Cox wrote:
> On Wed, 19 Sep 2012 14:31:36 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Greg,
> > 
> > After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
> > failed like this:
> > 
> > drivers/usb/serial/vizzini.c: In function 'vizzini_set_termios':
> > drivers/usb/serial/vizzini.c:454:22: error: invalid type argument of '->' (have 'struct ktermios')
> > 
> > Caused by commit c05fecb1d57e ("USB: serial: add vizzini driver")
> > interacting with commit adc8d746caa6 ("tty: move the termios object into
> > the tty") from the tty tree.
> > 
> > I added the following merge fix patch and can carry it as necessary:
> 
> Vizzini seems to have teleported into Greg's tree. Greg - it's got a pile
> of other bugs in it plus complete bogus comments and the like. You don't
> seem to have every posted it to the lists for comment or if you did it
> didn't turn up here ?

Yeah, I pulled it in from an out-of-tree vendor and tried to clean a
bunch of things up, but I know it has more things left to get right
(heck, I'm almost not sure it's even needed, I think this might be a
cdc-acm device...)

Any patches are appreciated, and I think that if the vendor doesn't
respond, I'll just drop the driver entirely, their emails are now
bouncing :(

greg k-h
