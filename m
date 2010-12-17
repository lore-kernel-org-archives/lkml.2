Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0LQWpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 17:45:50 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12833 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab0LQWpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 17:45:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Fri, 17 Dec 2010 14:37:04 -0800
Date: Fri, 17 Dec 2010 14:44:29 -0800
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
Subject: Re: [RFC] Align tegra-ehci DMA transfers to 32B
Message-ID: <20101217224429.GF25105@morell.nvidia.com>
References: <1292623129-26361-1-git-send-email-rmorell@nvidia.com>
 <20101217223227.GA19418@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101217223227.GA19418@suse.de>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 02:32:27PM -0800, Greg KH wrote:
> On Fri, Dec 17, 2010 at 01:58:47PM -0800, Robert Morell wrote:
> > This small set of patches fixes an issue where DMA from the tegra EHCI
> > controller could be corrupted.  It was most commonly seen with USB network
> > adapters, though in theory it could happen with any USB traffic.
> > 
> > (Note: An attempt was made to fix this with commit 367c3aab, which set
> > NET_IP_ALIGN to 0 and NET_SKB_PAD to 32.  Unfortunately, not all network
> > drivers honor them (presumably since these are intended as optimizations rather
> > than hard rules).  This does mean that properly-written network drivers should
> > fall through this code with very little overhead, however.)
> 
> We don't have many USB network drivers, why not just fix them up to
> handle this properly, then you will not need to change any core USB
> code, right?

The USB core code is used by devices other than USB adapters.  We've
only seen this problem so far with usbnet devices, but I can't test
every USB device ever to make sure that they always align their DMA to
32 bytes.

Thanks,
Robert

> thanks,
> 
> greg k-h
> 
