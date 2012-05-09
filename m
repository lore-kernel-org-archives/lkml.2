Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab2EIGqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:46:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:43540 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab2EIGqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 02:46:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163808420"
Message-ID: <1336546000.6190.219.camel@yhuang-dev>
Subject: Re: [RFC v2 2/5] PM, Add sysfs file power_off to control device
 power off policy
From: Huang Ying <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>, Lan Tianyu <tianyu.lan@intel.com>
Date: Wed, 09 May 2012 14:46:40 +0800
In-Reply-To: <201205082334.58157.rjw@sisk.pl>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com>
	 <201205072253.47736.rjw@sisk.pl> <1336441458.6190.133.camel@yhuang-dev>
	 <201205082334.58157.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 23:34 +0200, Rafael J. Wysocki wrote:
> On Tuesday, May 08, 2012, Huang Ying wrote:
> > On Mon, 2012-05-07 at 22:53 +0200, Rafael J. Wysocki wrote:
> > > On Saturday, May 05, 2012, huang ying wrote:
> > > > On Sat, May 5, 2012 at 3:33 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > > On Friday, May 04, 2012, Huang Ying wrote:
> > > > >> From: Lan Tianyu <tianyu.lan@intel.com>
> [...]
> > > I think we may add helpers for exporting/unexporting power_off_allowed
> > > like for the PM QoS latency attribute.  Then, whoever wants to support
> > > power_off_allowed and use it will export it through that helper.
> > 
> > That sounds good!
> > 
> > > Still, I'm afraid we're trying to special case something that really ins't
> > > a special case.  Namely, we may want to restrict devices from using some
> > > other low-power states as well, not only power off (eg. we may want to
> > > prevent devices' clocks from being stopped).
> > 
> > One step towards generalization is to provide a way for user to specify
> > lowest power state allowed.  For example, for PCI devices, they can
> > specify D1, D2, D3hot or D3cold.  But it is hard to generalize a set of
> > low power states for all kind of devices.  Maybe we should keep this
> > user space interface bus specific?
> 
> I came to the same conclusion. :-)
> 
> Besides, we already have the no_d1d2 and d1_support, d2_support flags
> in struct pci_dev.  We can simply add no_d3_cold in analogy and add a similar
> thing for ATA to cover the ZPODD case.
> 
> I would keep those things bus-type-specific and platform-specific.

But power-off sate seems like the only low power state that can be
shared between buses.  And keep power_must_be_on in dev_pm_info seems
good for power domain implementation.  Because one power domain may
contain devices comes from different buses.

Best Regards,
Huang Ying


