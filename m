Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab1AYC7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 21:59:06 -0500
Received: from netrider.rowland.org ([192.131.102.5]:45177 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751980Ab1AYC7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 21:59:04 -0500
Date: Mon, 24 Jan 2011 21:59:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: rmorell@nvidia.com
cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Benoit Goby <benoit@android.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Oliver Neukum <oliver@neukum.org>, Olof Johansson <olof@lixom.net>,
        Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 2/2] USB: ehci: tegra: Align DMA transfers to 32 bytes
In-Reply-To: <20110124225323.GA5701@morell.nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1101242154550.27801-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011 rmorell@nvidia.com wrote:

> > > +	if (dir == DMA_FROM_DEVICE && !status)
> > > +		memcpy(temp->old_xfer_buffer, temp->data,
> > > +			urb->transfer_buffer_length);
> > 
> > Even if status is nonzero, there may be valid data in the buffer.  You 
> > should skip that test.
> 
> Thanks for looking, Alan.  I added that test based on earlier feedback.
> I think the big concern here is security: if the URB fails in such a way
> that the buffer is not overwritten, then we may copy out freed kernel
> data to userspace.

Not to userspace, only to the driver that submitted the URB.  That 
driver must be part of the kernel.  For URBs that _do_ originate in 
userspace, by way of usbfs, the usbfs code is responsible for not 
leaking any kernel data.

> Are there specific status codes that I can check for here?

No.

>  I guess the
> only other option is to remove the direction check from the alloc path
> or alloc with GFP_ZERO.

You don't have to worry about this; it isn't a security concern.

Alan Stern

