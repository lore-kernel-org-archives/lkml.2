Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031542Ab2K3Spq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:45:46 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:56315 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030923Ab2K3Spp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:45:45 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: pv-drivers@vmware.com, Andy King <acking@vmware.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [Pv-drivers] [PATCH 12/12] VMCI: Some header and config files.
Date: Fri, 30 Nov 2012 10:45:44 -0800
Message-ID: <27667508.9ZL27Yq4ZC@dtor-d630.eng.vmware.com>
Organization: VMware, Inc.
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7+; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121130183918.GA22577@kroah.com>
References: <20121127002357.GA27683@core.coreip.homeip.net> <1682307.3e6BJPfOqr@dtor-d630.eng.vmware.com> <20121130183918.GA22577@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 30, 2012 10:39:18 AM Greg KH wrote:
> On Fri, Nov 30, 2012 at 09:20:41AM -0800, Dmitry Torokhov wrote:
> > On Friday, November 30, 2012 09:09:21 AM Greg KH wrote:
> > > On Fri, Nov 30, 2012 at 08:47:46AM -0800, Andy King wrote:
> > > > I didn't get the resend either, so it seems our corporate mail really
> > > > is
> > > > eating messages.  Lovely.
> > > > 
> > > > > > > +#define IOCTLCMD(_cmd) IOCTL_VMCI_ ## _cmd
> > > > > > 
> > > > > > I don't recall ever getting a valid answer for this (if you did,
> > > > > > my
> > > > > > appologies, can you repeat it).  What in the world are you talking
> > > > > > about here?  Why is your driver somehow special from the thousands
> > > > > > of other ones that use the in-kernel IO macros properly for an
> > > > > > ioctl?
> > > > 
> > > > Because we're morons.  And unfortunately, we've shipped our product
> > > > using those broken definitions: our VMX uses them to talk to the
> > > > driver.
> > > > So here's what we'd like to do.  We will send out a patch soon that
> > > > fixes the other issues you mention and also adds IOCTL definitions the
> > > > proper way using _IOBLAH().  But we'd also like to retain these broken
> > > > definitions for a short period, commented as such, at least until we
> > > > can get out a patch release to Workstation 9, at which point we can
> > > > remove them.  Does that sound reasonable?
> > > 
> > > It has been my experience, that when people say "We will remove that api
> > > sometime in the future", it never happens.  So why not just do it now?
> > > 
> > > Especially given that this code will be coming out in 3.9 at the
> > > earliest, and that is 6 months away, so that should be plenty of time to
> > > get this fixed up.
> > 
> > Our schedule for releasing hosted products is not necessarily aligned
> > with mainline kernel releases.
> 
> And kernel developers don't really care about company schedules, nor
> should they, you know this :)
> 

That is why we are offering a compromise so that older installations
have a chance to work and nobody has to care about schedules too much.

However you snipped the rest of my reply: do we really need to renumber 
ioctls? There is no benefit for the driver as its ioctl handler does
not parse the numbers into components.

Thanks,
Dmitry


