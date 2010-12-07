Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0LGQ2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:28:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:58464 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab0LGQ2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:28:03 -0500
Date: Tue, 7 Dec 2010 08:27:55 -0800
From: Greg KH <gregkh@suse.de>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] bind/unbind uevent
Message-ID: <20101207162755.GA32328@suse.de>
References: <alpine.LFD.2.02.1012071713500.1897@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1012071713500.1897@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 05:18:27PM +0100, Sebastian Ott wrote:
> Hi,
> 
> There is currently no generic trigger for userspace to know when a driver
> is bound to a device.

Not true at all, you get one when a device is attached to a bus.  What's
wrong with that notification?

> Such a trigger may be required in cases where setup
> steps must be performed in userspace after the device is bound, e.g.
> because the driver adds sysfs attributes in its probe function.

A driver should not add sysfs attributes in its probe function as that
is racy as you have noticed.  Add the attributes in the bus functions
for that driver and it should be fine.

> I can imagine 3 possible ways to solve this problem:
> * add a bus specific change event (triggered by BUS_NOTIFY_BOUND_DRIVER)
>   - this may result in duplicated code for each bus
> * dissable autoprobing and "manually" probe the device from userspace
>   triggered by the add event - this duplicates logic already implemented
>   in the kernel
> * add a generic bind/unbind uevent
> 
> Which one is preferred from a driver core perspective?

None, use the existing notifications like everyone else :)

thanks,

greg k-h
