Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab0LRBb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 20:31:58 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13606 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab0LRBby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 20:31:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Fri, 17 Dec 2010 17:29:38 -0800
Date: Fri, 17 Dec 2010 17:29:38 -0800
From: rmorell@nvidia.com
To: Greg KH <gregkh@suse.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: ehci: tegra: Align DMA transfers to 32 bytes
Message-ID: <20101218012937.GM25105@morell.nvidia.com>
References: <1292623129-26361-1-git-send-email-rmorell@nvidia.com>
 <1292623129-26361-3-git-send-email-rmorell@nvidia.com>
 <20101217223502.GB19418@suse.de>
 <20101217224221.GE25105@morell.nvidia.com>
 <20101217230940.GB21147@suse.de>
 <20101217234008.GJ25105@morell.nvidia.com>
 <20101218003747.GB16600@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101218003747.GB16600@suse.de>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 04:37:47PM -0800, Greg KH wrote:
> On Fri, Dec 17, 2010 at 03:40:08PM -0800, rmorell@nvidia.com wrote:
> > On Fri, Dec 17, 2010 at 03:09:40PM -0800, Greg KH wrote:
> > > On Fri, Dec 17, 2010 at 02:42:21PM -0800, rmorell@nvidia.com wrote:
> > > > On Fri, Dec 17, 2010 at 02:35:02PM -0800, Greg KH wrote:
> > > > > On Fri, Dec 17, 2010 at 01:58:49PM -0800, Robert Morell wrote:
> > > > > > --- a/include/linux/usb.h
> > > > > > +++ b/include/linux/usb.h
> > > > > > @@ -975,6 +975,7 @@ extern int usb_disabled(void);
> > > > > >  #define URB_SETUP_MAP_SINGLE	0x00100000	/* Setup packet DMA mapped */
> > > > > >  #define URB_SETUP_MAP_LOCAL	0x00200000	/* HCD-local setup packet */
> > > > > >  #define URB_DMA_SG_COMBINED	0x00400000	/* S-G entries were combined */
> > > > > > +#define URB_DRIVER_PRIVATE	0x80000000	/* For driver-private use */
> > > > > 
> > > > > Um, what?  You are using this for a build check, which seems pointless
> > > > > as you already modified the code to not need this.
> > > > > 
> > > > > So it doesn't look like this is needed, right?
> > > > 
> > > > The intention was to reserve space in the URB flags for
> > > > implementation-specific use.
> > > 
> > > Yes, but _which_ driver are you talking about here?  You didn't say that
> > > this was a HCD-only flag, right?
> > 
> > Sorry, I may not have been clear.  I did mean HCD-only flag; its exact
> > meaning depends on the HCD in question.  In the case of tegra-ehci, it
> > means that a temporary buffer has been allocated that needs freeing
> > later.
> > 
> > Would it make more sense if I called it URB_HCD_PRIVATE_MASK?
> 
> How about naming it what it is being used for?

Sure, I can do that.  I was just trying to avoid polluting the general
USB namespace with HCD-specific constants, but I'll send out a revised
patchset with this change.

Thanks,
Robert
