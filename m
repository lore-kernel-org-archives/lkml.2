Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab2BWNlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 08:41:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:45722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab2BWNlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 08:41:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120525347"
Subject: Re: [RFC PATCH 2/6] ACPI: Reference devices in ACPI Power Resource
From: Lin Ming <ming.m.lin@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Zhang, Rui" <rui.zhang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1202211059180.1366-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1202211059180.1366-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Feb 2012 21:41:36 +0800
Message-ID: <1330004496.2469.3.camel@hp6530s>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 11:06 -0500, Alan Stern wrote:
> On Tue, 21 Feb 2012, Lin Ming wrote:
> 
> > > Then maybe you can use pm_runtime_no_callbacks() for the ZPODD device.
> > > It's explained in Documentation/power/runtime_pm.txt, and I use it for
> > > USB interfaces.
> > 
> > If pm_runtime_no_callbacks() is used, runtime PM sysfs attributes
> > won't be created.
> > Then how to disable ZPODD feature in userspace?
> > 
> > Currently, I use "control" file of scsi device to enable/disable
> > ZPODD, for example
> > echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata0/host1/target1:0:0/1:0:0:0/power/control
> > echo on > /sys/devices/pci0000:00/0000:00:1f.2/ata0/host1/target1:0:0/1:0:0:0/power/control
> 
> You could get the same result by using the "control" file for the ATA
> port.
> 
> > > The idea is that the ZPODD will never receive any runtime PM callbacks
> > > from the PM core. �Instead the ATA port callback routines will be
> > > responsible for power management of the ZPODD device.
> > 
> > Does the ATA port callback also responsible to resume its child?
> > 
> > For example,
> > /sys/devices/pci0000:00/0000:00:1f.2/ata0/host1/target1:0:0/1:0:0:0/
> > 
> > ata0 is resumed.
> > 
> > Then who will be responsible to resume host1, target1:0:0 and 1:0:0:0?
> > 
> > Or do you mean that we don't need to resume these devices at all?
> > host1 and target1:0:0 are logical devices, but I think 1:0:0:0 is not.
> 
> That's right.  It makes no difference whether the host and target 
> are resumed or suspended.  In fact, you could also call 
> pm_runtime_no_callbacks() for them.

But host and target are added in scsi layer. How do we know if they are
"logical device"?

Or do you mean that we can call pm_runtime_no_callbacks() for them
because scsi layer(scsi_pm.c) only implements runtime pm for scsi
device.

Thanks,
Lin Ming 

> 
> Alan Stern
> 


