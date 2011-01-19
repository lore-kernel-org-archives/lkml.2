Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1ASWFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:05:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56679 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753700Ab1ASWFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:05:21 -0500
Date: Wed, 19 Jan 2011 17:05:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] PM: Do not create wakeup sysfs files for devices
 that cannot wakeup
In-Reply-To: <201101150108.45657.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1101191704080.3655-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Jan 2011, Rafael J. Wysocki wrote:

> OK, I think that problem is not present any more in the new version of the
> patch, which is appended.
> 
> > Apart from that, it all seems reasonable.  But you should change the
> > description of the wakeup attribute in Documentation/power/devices.txt;  
> > it says that the attribute file is present but empty if the device is
> > not wakeup-capable.
> 
> Right and not only that.  The descriptions in ABI/sysfs-device-power have to be
> updated too.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Do not create wakeup sysfs files for devices that cannot wake up
> 
> Currently, wakeup sysfs attributes are created for all devices,
> regardless of whether or not they are wakeup-capable.  This is
> excessive and complicates wakeup device identification from user
> space (i.e. to identify wakeup-capable devices user space has to read
> /sys/devices/.../power/wakeup for all devices and see if they are not
> empty).
> 
> Fix this issue by avoiding to create wakeup sysfs files for devices
> that cannot wake up the system from sleep states (i.e. whose
> power.can_wakeup flags are unset during registration) and modify
> device_set_wakeup_capable() so that it adds (or removes) the relevant
> sysfs attributes if a device's wakeup capability status is changed.

Yes, this all looks okay to me.

Alan Stern

