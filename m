Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2KOVkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 16:40:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18027 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2KOVkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 16:40:03 -0500
Date: Fri, 16 Nov 2012 00:38:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Markus Grabner <grabner@icg.tugraz.at>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, devel@driverdev.osuosl.org,
        line6linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/8] staging: line6: wrap >80 char lines in capture.c
Message-ID: <20121115213821.GK11566@mwanda>
References: <1352636686-31170-1-git-send-email-stefanha@gmail.com>
 <1352636686-31170-2-git-send-email-stefanha@gmail.com>
 <20121114143305.GH11515@mwanda>
 <1602710.lBylyCQOHr@medialab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602710.lBylyCQOHr@medialab>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2012 at 10:03:27PM +0100, Markus Grabner wrote:
> Am Mittwoch, 14. November 2012, 17:33:05 schrieb Dan Carpenter:
> > On Sun, Nov 11, 2012 at 01:24:39PM +0100, Stefan Hajnoczi wrote:
> > > Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
> > > ---
> > > 
> > >  drivers/staging/line6/capture.c | 13 ++++++++-----
> > >  1 file changed, 8 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/staging/line6/capture.c
> > > b/drivers/staging/line6/capture.c index c85c5b6..389c41f 100644
> > > --- a/drivers/staging/line6/capture.c
> > > +++ b/drivers/staging/line6/capture.c
> > > @@ -256,8 +256,8 @@ static void audio_in_callback(struct urb *urb)
> > > 
> > >  #ifdef CONFIG_LINE6_USB_IMPULSE_RESPONSE
> > >  
> > >  		if (!(line6pcm->flags & LINE6_BITS_PCM_IMPULSE))
> > >  
> > >  #endif
> > > 
> > > -			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM, &line6pcm-
> >flags)
> > > -			    && (fsize > 0))
> > > +			if (test_bit(LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM,
> > 
> > The reason this is hitting the 80 character limit is because
> > "LINE6_INDEX_PCM_ALSA_CAPTURE_STREAM" is 35 characters long.  It
> > isn't even clear from the name what it holds.  It's just a very crap
> > name.
> Please refer to the file pcm.h for a detailed documentation of this and 
> similar names (in fact, the documentation explains the LINE6_BIT_PCM_* names 
> instead, but I bevlieve the correspondence is obvious). It's hard to define a 
> shorter name which is at the same time descriptive, consistent, and not to be 
> confused with related names.
> 
> Should such documentation be moved to a separate file (e.g., 
> "Documentation/sound/alsa/line6usb.txt")?

The documentation is pretty good actually and it belongs where it
is.  But 35 characters is just tooooooooooooooooooooooooooooooooooo
long.

To me the word "INDEX_" is confusing because what are we indexing?
In this context it means the the variable is a bit flag.  That was
obvious because we were calling test_bit().

I think we could drop the PCM_ as well, because why do we need that?

We could change the LINE6 to L6.

			if (test_bit(L6_ALSA_CAPTURE_STREAM, &line6pcm - flags)

It fits!

regards,
dan carpenter

