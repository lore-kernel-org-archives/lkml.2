Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab0LQXxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:53:19 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1576 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab0LQXxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:53:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Fri, 17 Dec 2010 15:50:51 -0800
Date: Fri, 17 Dec 2010 15:50:50 -0800
From: rmorell@nvidia.com
To: Greg KH <gregkh@suse.de>
Cc: Oliver Neukum <oliver@neukum.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
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
Message-ID: <20101217235050.GK25105@morell.nvidia.com>
References: <1292623129-26361-1-git-send-email-rmorell@nvidia.com>
 <20101217224221.GE25105@morell.nvidia.com>
 <20101217230940.GB21147@suse.de>
 <201012180017.41391.oliver@neukum.org>
 <20101217233527.GA31162@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217233527.GA31162@suse.de>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 03:35:27PM -0800, Greg KH wrote:
> On Sat, Dec 18, 2010 at 12:17:40AM +0100, Oliver Neukum wrote:
> > Am Samstag, 18. Dezember 2010, 00:09:40 schrieb Greg KH:
> > > I still don't like it, it feels like a hack that is not going to be able
> > > to be maintained very well.
> > > 
> > > And I still think the individual drivers should be fixed...
> > > 
> > 
> > But they are not buggy. The USB API was written under the
> > assumption that HCDs can deal with byte level granularity and alignment.
> > Hence the network driver pass DMA-able memory with an alignment
> > that suits them.
> 
> Ok, fair enough.
> 
> But I still don't like that urb flag stuff as a solution to this...

Yeah, I wish I knew of a better way to store this information.
urb->hcpriv seems like a nice place for host controller-private data,
but it's used by the general ehci framework throughout the lifetime of
an URB so isn't suitable for this case.

Thanks,
Robert

> thanks,
> 
> greg k-h
> 
