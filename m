Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab0LQXKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:10:44 -0500
Received: from cantor.suse.de ([195.135.220.2]:46005 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab0LQXKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:10:41 -0500
Date: Fri, 17 Dec 2010 15:07:02 -0800
From: Greg KH <gregkh@suse.de>
To: rmorell@nvidia.com
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
Subject: Re: [RFC] Align tegra-ehci DMA transfers to 32B
Message-ID: <20101217230702.GA21147@suse.de>
References: <1292623129-26361-1-git-send-email-rmorell@nvidia.com>
 <20101217223227.GA19418@suse.de>
 <20101217224429.GF25105@morell.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217224429.GF25105@morell.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 02:44:29PM -0800, rmorell@nvidia.com wrote:
> On Fri, Dec 17, 2010 at 02:32:27PM -0800, Greg KH wrote:
> > On Fri, Dec 17, 2010 at 01:58:47PM -0800, Robert Morell wrote:
> > > This small set of patches fixes an issue where DMA from the tegra EHCI
> > > controller could be corrupted.  It was most commonly seen with USB network
> > > adapters, though in theory it could happen with any USB traffic.
> > > 
> > > (Note: An attempt was made to fix this with commit 367c3aab, which set
> > > NET_IP_ALIGN to 0 and NET_SKB_PAD to 32.  Unfortunately, not all network
> > > drivers honor them (presumably since these are intended as optimizations rather
> > > than hard rules).  This does mean that properly-written network drivers should
> > > fall through this code with very little overhead, however.)
> > 
> > We don't have many USB network drivers, why not just fix them up to
> > handle this properly, then you will not need to change any core USB
> > code, right?
> 
> The USB core code is used by devices other than USB adapters.  We've
> only seen this problem so far with usbnet devices, but I can't test
> every USB device ever to make sure that they always align their DMA to
> 32 bytes.

Then it might just be easier for your driver to throw up a huge
WARN_ON() if it detects such memory so that the device driver could be
fixed, right?

thanks,

greg k-h
