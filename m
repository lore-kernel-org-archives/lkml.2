Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2BRUbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 15:31:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59484 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab2BRUbL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 15:31:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: huang ying <huang.ying.caritas@gmail.com>
Subject: Re: [RFC PATCH 4/6] PM / Runtime: Introduce flag can_power_off
Date: Sat, 18 Feb 2012 21:35:06 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Zhang Rui <rui.zhang@intel.com>, Alan Stern <stern@rowland.harvard.edu>,
        Lin Ming <ming.m.lin@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Tejun Heo <tj@kernel.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
References: <Pine.LNX.4.44L0.1202130958440.1434-100000@iolanthe.rowland.org> <201202180054.49284.rjw@sisk.pl> <CAC=cRTOCpH8haMGDEDDG8k0k2DpaVM7DoU5AayrcscR1rZKXgQ@mail.gmail.com>
In-Reply-To: <CAC=cRTOCpH8haMGDEDDG8k0k2DpaVM7DoU5AayrcscR1rZKXgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202182135.06868.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 18, 2012, huang ying wrote:
> On Sat, Feb 18, 2012 at 7:54 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, February 16, 2012, Zhang Rui wrote:
> >> On 二, 2012-02-14 at 23:39 +0100, Rafael J. Wysocki wrote:
> >> > On Tuesday, February 14, 2012, Zhang Rui wrote:
> >> > > On 一, 2012-02-13 at 20:38 +0100, Rafael J. Wysocki wrote:
> >> > > > On Monday, February 13, 2012, Alan Stern wrote:
> >> > > > > On Mon, 13 Feb 2012, Lin Ming wrote:
> [snip]
> >> Yeah, I have thought about this for quite a while before, there ARE
> >> several ways to do this, but these need a lot of changes in bus code, at
> >> least for the buses that support device runtime D3 (off) by ACPI.
> >>
> >> Lets also take SATA port and ZPODD for example,
> >> proposal one,
> >> 1) introduce scsi_can_power_off and ata_can_power_off.
> >> 2) sr driver set scsi_can_power_off bit and scsi layer is aware of this,
> >> thus the scsi host can set this bit as well.
> >> 3) in the .runtime_suspend callback of ata port, it knows that its scsi
> >> host interface can be powered off, thus it invokes ata_can_power_off to
> >> tell the ata layer.
> >
> > Hmm.  I'm not sure why you want to introduce this special "power off"
> > condition.  In fact, it's nothing special, it only means that the device
> > in question shouldn't be accessed by software, which pretty much is equivalent
> > to the "suspended" condition (as defined in the runtime PM docs).
> 
> I think some reasons to introduce can_poweroff can be:
> 
> 1) To indicate the implementation of .runtime_suspend/.runtime_resume
> is compatible with power off.  That is, .runtime_suspend will save all
> needed information and .runtime_resume can work on the uninitialized
> device.
> 
> If this is already the requirement of
> .runtime_suspend/.runtime_resume.

Yes, it is.

> Then this is not needed.   Maybe we
> can make that explicitly for these callbacks via some kind of
> documentation.

I thought it was documented.

> 2) To support something like pm-qos.  power off device may have more
> exit.latency than normal low power state (such as D3Hot).  Some device
> may disable can_power_off based on that.

No, please.  There would be totally _no_ _meaning_ of that flag at the core
level.  Please use subsys_data in struct dev_pm_info for subsystem-specific
data (which is this one).

> 3) Whether to go to power off should be determined by leaf device
> (such as SATA disk), but that may be done by its parent device (such
> as SATA port).  It's a way for leaf device to tell its parent device
> whether it want to go to power off.

Well, please see above.

Thanks,
Rafael
