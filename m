Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab2BNHLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:11:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:57074 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab2BNHLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:11:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="106511918"
Message-ID: <1329203489.19384.39.camel@rui.sh.intel.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
From: Zhang Rui <rui.zhang@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Lin Ming <ming.m.lin@intel.com>,
        Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <tj@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Tue, 14 Feb 2012 15:11:29 +0800
In-Reply-To: <Pine.LNX.4.44L0.1202131534040.11382-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1202131534040.11382-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alan,

On 一, 2012-02-13 at 15:41 -0500, Alan Stern wrote:
> On Mon, 13 Feb 2012, Rafael J. Wysocki wrote:
> 
> > > I'm not sure if this is really the right approach.  What you're trying 
> > > to do is implement two different low-power states, basically D3hot and 
> > > D3cold.  Currently the runtime PM core doesn't support such things; all 
> > > it knows about is low power and full power.
> > 
> > I'd rather say all it knows about is "suspended" and "active", which mean
> > "the device is not processing I/O" and "the device may be processing I/O",
> > respectively.  A "suspended" device may or may not be in a low-power state,
> > but the runtime PM core doesn't care about that.
> 
> Yes, okay.  We can say that this patch tries to implement two different 
> "suspended" states, basically "low power" and "power off" (or D3hot and 
> D3cold).
> 
Right!

> > > Before doing an ad-hoc implementation, it would be best to step back
> > > and think about other subsystems.  Other sorts of devices may well have
> > > multiple low-power states.  What's the best way for this to be
> > > supported by the PM core?
> > 
> > Well, I honestly don't think there's any way they all can be covered at the
> > same time and that's why we chose to support only "suspended" and "active"
> > as defined above.  The handling of multiple low-power states must be
> > implemented outside of the runtime PM core (like in the PCI core, for example).
> 
> That's the point.  If this is to be implemented outside of the runtime
> PM core, should the patch be allowed to add new fields to struct
> dev_pm_info (which has to be shared among all subsystems)?
> 
Surely it shouldn't in this case.

> Or to put it another way, if we do add new fields to struct dev_pm_info
> (like can_power_off) in order to help support multiple "suspended"  
> states, shouldn't these new fields be such that they can be used by
> many different subsystems rather than being special for the
> full-power/no-power situation?
> 
My opinion is that the concept of "no-power state" is unique for all
devices/buses/platforms.
If any of them support this, they can use the routines without any
confusion.

thanks,
rui

