Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab1HCISM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 04:18:12 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:54885 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1HCISJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 04:18:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: balbi@ti.com
Subject: Re: [PATCH][Resend] Remove unneeded version.h includes (and add where needed) for drivers/usb/
Date: Wed, 3 Aug 2011 10:18:23 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37-gentoo-r3; KDE/4.6.5; x86_64; ; )
Cc: Jesper Juhl <jj@chaosbits.net>, LKML <linux-kernel@vger.kernel.org>,
        trivial@kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <alpine.LNX.2.00.1108012329380.31999@swampdragon.chaosbits.net> <201108030011.54322.laurent.pinchart@ideasonboard.com> <20110802225041.GA10284@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110802225041.GA10284@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108031018.23654.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Wednesday 03 August 2011 00:50:42 Felipe Balbi wrote:
> On Wed, Aug 03, 2011 at 12:11:53AM +0200, Laurent Pinchart wrote:
> > On Tuesday 02 August 2011 23:19:24 Felipe Balbi wrote:
> > > On Mon, Aug 01, 2011 at 11:33:29PM +0200, Jesper Juhl wrote:
> > > > It was pointed out by 'make versioncheck' that linux/version.h was
> > > > not always being included where needed and sometimes included
> > > > needlessly in drivers/usb/.
> > > > This patch fixes up the includes.
> > > > 
> > > > For the UVC gadget driver bits, this was ACK'ed by Laurent Pinchart.
> > > > 
> > > > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > ---
> > > > 
> > > >  drivers/usb/gadget/uvc.h         |    1 +
> > > >  drivers/usb/gadget/uvc_v4l2.c    |    1 -
> > > >  drivers/usb/storage/realtek_cr.c |    1 -
> > > >  3 files changed, 1 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/drivers/usb/gadget/uvc.h b/drivers/usb/gadget/uvc.h
> > > > index 5b79194..81971fb 100644
> > > > --- a/drivers/usb/gadget/uvc.h
> > > > +++ b/drivers/usb/gadget/uvc.h
> > > > @@ -56,6 +56,7 @@ struct uvc_event
> > > > 
> > > >  #include <linux/usb.h>	/* For usb_endpoint_* */
> > > >  #include <linux/usb/gadget.h>
> > > >  #include <linux/videodev2.h>
> > > > 
> > > > +#include <linux/version.h>
> > > 
> > > does uvc.h really needs <linux/version.h> ?? Laurent ?
> > 
> > uvc.h has
> > 
> > #define DRIVER_VERSION_NUMBER                   KERNEL_VERSION(0, 1, 0)
> > 
> > This is used in drivers/usb/gadget/uvc_v4l2.c only.
> > 
> > As the uvc gadget driver lives in-tree, the best fix is probably to
> > remove DRIVER_VERSION_NUMBER completely, and replace it with
> > LINUX_VERSION_CODE where it is used.
> 
> yeah, I can agree with that, but do you need a MODULE_VERSION() anyway ?
> Would it be better to just remove the MODULE_VERSION altogether as
> there's no real benefit from having it ?

DRIVER_VERSION_NUMBER isn't used as a MODULE_VERSION() argument. The driver 
uses it to report its version through the V4L2 API.

-- 
Regards,

Laurent Pinchart
