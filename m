Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0FCR6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:58:37 -0400
Received: from sous-sol.org ([216.99.217.87]:51353 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751380Ab0FCR6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:58:35 -0400
Date: Thu, 3 Jun 2010 10:56:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Frank Pan <frankpzh@gmail.com>
Cc: "Williams, Mitch A" <mitch.a.williams@intel.com>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Yu Zhao <yu.zhao@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Add a helper function in PCI IOV to get VF device
Message-ID: <20100603175643.GY8301@sequoia.sous-sol.org>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com>
 <20100601183920.GB19955@kroah.com>
 <EA929A9653AAE14F841771FB1DE5A1365FF3EC130E@rrsmsx501.amr.corp.intel.com>
 <AANLkTinmxW5gQUOYJgK67Dc1FdakeXSmuu1hExKKL1qk@mail.gmail.com>
 <EA929A9653AAE14F841771FB1DE5A1365FF3F8D431@rrsmsx501.amr.corp.intel.com>
 <AANLkTilDY61GMGNLezXYLbbe3B8-SvgMOK5L9Q6juETL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilDY61GMGNLezXYLbbe3B8-SvgMOK5L9Q6juETL@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Pan (frankpzh@gmail.com) wrote:
> hi Mitch,
> 
> > Frank, I'm not sure what you're trying to accomplish here. All of the information you need is already in sysfs. Given the PF device, you can look at /sys/class/net/ethX/device/virtfnX to get the bus/device/function of each of the VF devices.
> 
> Yes, that's the most funny part. Sysfs can only be traversed in
> usespace. So the thing userspace knows isn't known by driver(pf driver
> have no idea about vf's bdf), while the thing driver knows isn't known
> by userspace(one cannot infer pf's bdf from vf's bdf).
> Please think kernel/userspace as 2 system, they can hardly communicate
> these informations. IMHO give a syscall/ioctl telling these is funny
> and strange.
> 
> > If the VF driver is loaded in your kernel, then given the bus/device/function of the vf device, you can look at /sys/class/net/ethX/device/virtfnX/net to see which interface corresponds to that VF.
> 
> VF driver will never be loaded on physical machine, it can only be
> loaded in a virtual machine. On a physical machine, VF won't have any
> interface.

VF is often loaded on the physical machine.  There's also a networking
specific mechanism for querying and configuring a VF via the PF.

While your patch is simple, it's unclear to me what your end goal is.
The patch itself only adds a function. if you showed how you are
planning to use it, that would really help.

It's especially confusing that you are comparing your patch with
symlinks visible in sysfs.

thanks,
-chris
