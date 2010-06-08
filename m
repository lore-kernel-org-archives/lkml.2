Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab0FHWNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 18:13:48 -0400
Received: from sous-sol.org ([216.99.217.87]:48292 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752560Ab0FHWNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 18:13:46 -0400
Date: Tue, 8 Jun 2010 15:12:44 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Frank Pan <frankpzh@gmail.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       "Williams, Mitch A" <mitch.a.williams@intel.com>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Matt Carlson <mcarlson@broadcom.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Add a helper function in PCI IOV to get VF device
Message-ID: <20100608221244.GL8301@sequoia.sous-sol.org>
References: <AANLkTimTm57fvumRXo9pegOY2M78mduBsClwYlmAOzpo@mail.gmail.com>
 <20100601183920.GB19955@kroah.com>
 <EA929A9653AAE14F841771FB1DE5A1365FF3EC130E@rrsmsx501.amr.corp.intel.com>
 <AANLkTinmxW5gQUOYJgK67Dc1FdakeXSmuu1hExKKL1qk@mail.gmail.com>
 <EA929A9653AAE14F841771FB1DE5A1365FF3F8D431@rrsmsx501.amr.corp.intel.com>
 <AANLkTilDY61GMGNLezXYLbbe3B8-SvgMOK5L9Q6juETL@mail.gmail.com>
 <20100603175643.GY8301@sequoia.sous-sol.org>
 <AANLkTil7ZIqfdYeNA1dkfIDoKPeWU-FIArR-n-1HjqEz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTil7ZIqfdYeNA1dkfIDoKPeWU-FIArR-n-1HjqEz@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Pan (frankpzh@gmail.com) wrote:
> > VF is often loaded on the physical machine.  There's also a networking
> > specific mechanism for querying and configuring a VF via the PF.
> ? I don't really understand. What do you mean load? I don't think
> physical machine is able to use it as a hardware device.

Yes, it is possible.  Your example of igb...igbvf driver can be loaded
on physical machine and drive a VF instance.  In fact, this is a pretty
normal mode for KVM.

> > While your patch is simple, it's unclear to me what your end goal is.
> > The patch itself only adds a function. if you showed how you are
> > planning to use it, that would really help.
> Currently my hack is applied on 2.6.18 because of xen's limitation. As
> Mitch says, igb driver is significantly different with recent ones. On
> the other hand, my hack just exposes several PCI configuration and
> MMIO registers to the sysfs, you will only understand the use case
> when you also see the userspace hacks.

OK, but this sounds like the wrong approach.  We already have a
mechanism for using the PF to program a VF.  Have a look at the netlink
interface.  Specifically, do_setvfinfo().

thanks,
-chris
