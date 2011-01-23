Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299Ab1AWITn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 03:19:43 -0500
Received: from kroah.org ([198.145.64.141]:46918 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab1AWITm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 03:19:42 -0500
Date: Sat, 22 Jan 2011 19:46:53 -0800
From: Greg KH <greg@kroah.com>
To: Robert Morell <rmorell@nvidia.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Oliver Neukum <oliver@neukum.org>, Olof Johansson <olof@lixom.net>,
        Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 1/2] USB: HCD: Add driver hooks for (un)?map_urb_for_dma
Message-ID: <20110123034653.GA20186@kroah.com>
References: <1294356045-1018-1-git-send-email-rmorell@nvidia.com>
 <1295559715-14264-2-git-send-email-rmorell@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295559715-14264-2-git-send-email-rmorell@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 01:41:54PM -0800, Robert Morell wrote:
> Provide optional hooks for the host controller driver to override the
> default DMA mapping and unmapping routines.  In general, these shouldn't
> be necessary unless the host controller has special DMA requirements,
> such as alignment contraints.  If these are not specified, the
> general usb_hcd_(un)?map_urb_for_dma functions will be used instead.
> Also, pass the status to unmap_urb_for_dma so it can know whether the
> DMA buffer has been overwritten.
> 
> Finally, add a flag to be used by these implementations if they
> allocated a temporary buffer so it can be freed properly when unmapping.
> 
> Signed-off-by: Robert Morell <rmorell@nvidia.com>

I'd like to get an ACK from Alan before applying this one, and ideally
also from David and Sarah as they know the HCD code also.

Anyone?

thanks,

greg k-h
