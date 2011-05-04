Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1EDSxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:53:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:48208 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab1EDSxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:53:47 -0400
Date: Wed, 4 May 2011 11:53:38 -0700
From: Greg KH <gregkh@suse.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] Staging: hv: Add the necessary dependencies to
 hyperv	Kconfig
Message-ID: <20110504185338.GB9823@suse.de>
References: <1304535105-26892-1-git-send-email-kys@microsoft.com>
 <0D753D10438DA54287A00B027084269764D295CE91@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B027084269764D295CE91@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 01:44:27PM -0500, H Hartley Sweeten wrote:
> On Wednesday, May 04, 2011 11:52 AM, K. Y. Srinivasan wrote:
> >
> > The vmbus driver dependes on ACPI and PCI subsystems. Change 
> > Kconfig to reflect this.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > ---
> >  drivers/staging/hv/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/staging/hv/Kconfig b/drivers/staging/hv/Kconfig
> > index 76f0756..5e0c9f6 100644
> > --- a/drivers/staging/hv/Kconfig
> > +++ b/drivers/staging/hv/Kconfig
> > @@ -1,6 +1,6 @@
> >  config HYPERV
> >  	tristate "Microsoft Hyper-V client drivers"
> > -	depends on X86 && m
> > +	depends on X86 && ACPI && PCI && m
> >  	default n
> >  	help
> > 	  Select this option to run Linux as a Hyper-V client operating
> 
> ACPI itself depends on PCI.

Still?  I thought that got removed a while ago.

> It also depends on IA64 || X86.  Will the vmbus driver work with IA64?

No.

> If so the depends on could just be:
> 
> 	depends on ACPI && m

No, see above for the IA64 reason.

> Also, default n is redudant since n is the default anyway.

True, but it doesn't hurt either :)

thanks,

greg k-h
