Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab1CCWHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:07:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:31260 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab1CCWHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:07:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,260,1297065600"; 
   d="scan'208";a="663619512"
Date: Thu, 3 Mar 2011 17:07:35 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-ID: <20110303220735.GA3663@linux.intel.com>
References: <20110303204749.GY3663@linux.intel.com>
 <20110303211336.GA32645@kroah.com>
 <20110303214104.GZ3663@linux.intel.com>
 <20110303215155.GA30451@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110303215155.GA30451@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 01:51:55PM -0800, Greg KH wrote:
> Heh, no, well, submit_io should just go through the block layer and not
> be a separate ioctl, right?

Just like with SG_IO, there are reasons to do I/Os without going through
the block layer.

> > There's a bit of an impedence mismatch there.  Think of this as
> > being drive firmware instead of controller firmware.  This isn't for
> > request_firmware() kind of uses, it's for some admin tool to come along
> > and tell the drive "Oh, here's some new firmware for you".
> 
> That's fine, request_firmware will work wonderfully for that.

How would the driver know that it should call request_firmware()?
Do it every 60 seconds in case somebody's downloaded some new firmware?

> > If you look at the spec [1], you'll see there are a number of firmware
> > slots in the device, and it's up to the managability utility to decide
> > which one to replace or activate.  I dno't think you want to pull all
> > that gnarly decision making code into the kernel, do you?
> > 
> > [1] http://download.intel.com/standards/nvmhci/NVM_Express_1_0_Gold.pdf
> 
> No, just export multiple "slots" as firmware devices ready to be filled
> in by userspace whenever it wants/needs to.  The management utility can
> just dump the firmware to those sysfs files when it determines it needs
> to update the firmware, no decision making in the kernel at all.

OK ... glad we decided to limit the number of slots.  I still don't see
(in Documentation/firmware_class/README) how this works for user-initiated
firmware updates rather than kernel-initiated.
