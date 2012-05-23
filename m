Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791Ab2EWSr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:47:27 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51432 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759782Ab2EWSrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:47:25 -0400
Date: Wed, 23 May 2012 21:51:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: remove this_board macro in the s526
 driver
Message-ID: <20120523185109.GO4629@mwanda>
References: <201205221820.10770.hartleys@visionengravers.com>
 <20120523054849.GK4637@mwanda>
 <ADE657CA350FB648AAC2C43247A983F0020698BAC8A9@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698BAC8A9@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 11:06:39AM -0500, H Hartley Sweeten wrote:
> On Tuesday, May 22, 2012 10:49 PM, Dan Carpenter wrote:
> > On Tue, May 22, 2012 at 06:20:10PM -0700, H Hartley Sweeten wrote:
> >> The 'thisboard' macro depends on having a local variable with
> >> a magic name. The CodingStyle document suggests not doing this
> >> to avoid confusion. Remove the macro and use the comedi_board()
> >> inline helper to get the dev->board_ptr information.
> >> 
> >> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> >> Cc: Ian Abbott <abbotti@mev.co.uk>
> >> Cc: Mori Hess <fmhess@users.sourceforge.net>
> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> 
> >> ---
> >> @@ -769,13 +765,7 @@ static int s526_attach(struct comedi_device *dev, struct comedi_devconfig *it)
> >>  	}
> >>  	***/
> >>  
> >> -/*
> >> - * Initialize dev->board_name.  Note that we can use the "thisboard"
> >> - * macro now, since we just initialized it in the last line.
> >> - */
> >> -	dev->board_ptr = &s526_boards[0];
> >
> > Was this intended?  Most of the boards have auto probing so the
> > ->board_ptr gets set automatically.  We already called
> > comedi_board() so I wonder if the autoprobed board is the same as
> > the &s526_boards[0];?  NULL pointer perhaps?  I don't know.
> 
> Yes, removing the line was intended. Sorry I didn't mention it in the
> commit message.
> 
> The dev->board_ptr will already be set by comedi_device_attach()
> before the drivers attach() method is called.
> 
> I think the author of this driver misunderstood the skel driver and
> thought this was needed in order to simulate a "probe". See this
> comment in the skel.c driver:
> 
> /*
>  * If you can probe the device to determine what device in a series
>  * it is, this is the place to do it.  Otherwise, dev->board_ptr
>  * should already be initialized.
>  */
> 	/* dev->board_ptr = skel_probe(dev, it); */
> 

Heh.  Yeah.  I saw you removed a bunch of these comments and this
was the only one that wasn't commented so I wondered.

Ian already explained how the probing works.  Looks good.

regards,
dan carpenter


