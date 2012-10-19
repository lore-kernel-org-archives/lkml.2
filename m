Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030492Ab2JSQel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:34:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42747 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab2JSQek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:34:40 -0400
Date: Fri, 19 Oct 2012 09:34:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 5/5] xen-kbdfront: handle backend CLOSED without CLOSING
Message-ID: <20121019163436.GB2152@core.coreip.homeip.net>
References: <507FD39F.4060601@citrix.com>
 <1350554618-14582-5-git-send-email-david.vrabel@citrix.com>
 <20121019130059.GE26830@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019130059.GE26830@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 09:00:59AM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, Oct 18, 2012 at 11:03:38AM +0100, David Vrabel wrote:
> > From: David Vrabel <david.vrabel@citrix.com>
> > 
> > Backend drivers shouldn't transistion to CLOSED unless the frontend is
> > CLOSED.  If a backend does transition to CLOSED too soon then the
> > frontend may not see the CLOSING state and will not properly shutdown.
> > 
> > So, treat an unexpected backend CLOSED state the same as CLOSING.
> > 
> > Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> > Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> > Cc: linux-input@vger.kernel.org
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> 
> Hey Dmitry,
> 
> Should I prep a git pull for you for this or are you OK giving
> an Ack for me to put this patch in my git pull for Linus?

Sure, please merge with the rest through your tree.

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks!

> 
> Thx.
> > ---
> >  drivers/input/misc/xen-kbdfront.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
> > index 02ca868..6f7d990 100644
> > --- a/drivers/input/misc/xen-kbdfront.c
> > +++ b/drivers/input/misc/xen-kbdfront.c
> > @@ -311,7 +311,6 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
> >  	case XenbusStateReconfiguring:
> >  	case XenbusStateReconfigured:
> >  	case XenbusStateUnknown:
> > -	case XenbusStateClosed:
> >  		break;
> >  
> >  	case XenbusStateInitWait:
> > @@ -350,6 +349,10 @@ InitWait:
> >  
> >  		break;
> >  
> > +	case XenbusStateClosed:
> > +		if (dev->state == XenbusStateClosed)
> > +			break;
> > +		/* Missed the backend's CLOSING state -- fallthrough */
> >  	case XenbusStateClosing:
> >  		xenbus_frontend_closed(dev);
> >  		break;
> > -- 
> > 1.7.2.5

-- 
Dmitry
