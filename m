Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab2GNRES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 13:04:18 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50913 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313Ab2GNREP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 13:04:15 -0400
X-Sasl-enc: RsVV7s4DxM7XAr9guF03gwcdokuqVGinl1PHuaneP1jo 1342285454
Date: Sat, 14 Jul 2012 10:04:11 -0700
From: Greg KH <greg@kroah.com>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>
Subject: Re: [RFC 1/2] PCI-Express Non-Transparent Bridge Support
Message-ID: <20120714170411.GA25775@kroah.com>
References: <1342215900-3358-1-git-send-email-jon.mason@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342215900-3358-1-git-send-email-jon.mason@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 02:44:59PM -0700, Jon Mason wrote:
> The NTB device driver is needed to configure these memory windows, doorbell, and
> scratch-pad registers as well as use them in such a way as they can be turned
> into a viable communication channel to the remote system.  ntb_hw.[ch]
> determines the usage model (NTB to NTB or NTB to Root Port) and abstracts away
> the underlying hardware to provide access and a common interface to the doorbell
> registers, scratch pads, and memory windows.  These hardware interfaces are
> exported so that other, non-mainlined kernel drivers can access these.

Why would you have non-mainlined drivers?

Can you submit the drivers at the same time so we see how you are using
these new interfaces?

> +++ b/drivers/ntb/ntb_hw.c
> @@ -0,0 +1,1283 @@
> +/*
> + * This file is provided under a dual BSD/GPLv2 license.  When using or
> + *   redistributing this file, you may do so under either license.
> + *
> + *   GPL LICENSE SUMMARY
> + *
> + *   Copyright(c) 2012 Intel Corporation. All rights reserved.
> + *
> + *   This program is free software; you can redistribute it and/or modify
> + *   it under the terms of version 2 of the GNU General Public License as
> + *   published by the Free Software Foundation.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + *   General Public License for more details.
> + *
> + *   You should have received a copy of the GNU General Public License
> + *   along with this program; if not, write to the Free Software
> + *   Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
> + *   The full GNU General Public License is included in this distribution
> + *   in the file called LICENSE.GPL.

You really want to track the office movements of the FSF for the next 40
years?  You should ask your lawyers if you can remove this paragraph.

> +/**
> + * ntb_hw_link_status() - return the hardware link status
> + * @ndev: pointer to ntb_device instance
> + *
> + * Returns true if the hardware is connected to the remote system
> + *
> + * RETURNS: true or false based on the hardware link state
> + */
> +bool ntb_hw_link_status(struct ntb_device *ndev)
> +{
> +	return ndev->link_status == NTB_LINK_UP;
> +}
> +EXPORT_SYMBOL(ntb_hw_link_status);

EXPORT_SYMBOL_GPL() perhaps, for these, and the other symbols you are
creating?

thanks,

greg k-h
