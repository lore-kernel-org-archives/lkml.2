Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880Ab2EWTDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:03:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:40829 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932888Ab2EWTDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:03:31 -0400
Date: Wed, 23 May 2012 22:07:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: remove this_board macro in the s526
 driver
Message-ID: <20120523190715.GP4629@mwanda>
References: <201205221820.10770.hartleys@visionengravers.com>
 <20120523054849.GK4637@mwanda>
 <4FBCAB50.5000907@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F0020698BAC8D8@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698BAC8D8@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 11:28:32AM -0500, H Hartley Sweeten wrote:
> On Wednesday, May 23, 2012 2:18 AM, Ian Abbott wrote:
> > On 2012-05-23 06:48, Dan Carpenter wrote:
> >> On Tue, May 22, 2012 at 06:20:10PM -0700, H Hartley Sweeten wrote:
> >>> -/*
> >>> - * Initialize dev->board_name.  Note that we can use the "thisboard"
> >>> - * macro now, since we just initialized it in the last line.
> >>> - */
> >>> -	dev->board_ptr =&s526_boards[0];
> >>
> >> Was this intended?  Most of the boards have auto probing so the
> >> ->board_ptr gets set automatically.  We already called
> >> comedi_board() so I wonder if the autoprobed board is the same as
> >> the&s526_boards[0];?  NULL pointer perhaps?  I don't know.
> >
> > If .num_names in struct comedi_driver is non-zero, the core comedi 
> > module will set dev->board_ptr to something non-NULL and meaningful to 
> > the driver before it calls the driver's ->attach() method.  (This is 
> > done by the comedi_recognize() function.)  The driver can change 
> > dev->board_ptr to something else if it wants.  In this case, 
> > dev->board_ptr will already be set to &s526_boards[0] so there is no 
> > point setting it again.
> 
> Ian,
> 
> Side-note on the boardinfo stuff.
> 
> I wonder if it makes sense to create a common boardinfo struct
> and modify the comedi_driver struct a bit. Something like:
> 
> struct comedi_boardinfo {
> 	const char *name;
> 	unsigned short	vendor;
> 	unsigned short device;
> 	void *private;
> };
> 
> struct comedi_driver {
> 	struct comedi_driver *next;
> 
> 	const char *driver_name;
> 	struct module *module;
> 	int (*attach) (struct comedi_device *, struct comedi_devconfig *);
> 	void (*detach) (struct comedi_device *);
> 	int (*attach_pci) (struct comedi_device *, struct pci_dev *);
> 	int (*attach_usb) (struct comedi_device *, struct usb_interface *);
> 
> 	u32 num_boards;
> 	struct comedi_boardinfo *board;
> };
> 
> This would allow comedi_recognize() to walk the boardinfo
> to find the match without all the ugly casts.

That function wouldn't be so bad if we just removed all the consts.
There is no point because we drop all of them anyway when we return
the struct.

regards,
dan carpenter


