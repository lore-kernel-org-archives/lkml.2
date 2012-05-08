Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab2EHVaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 17:30:11 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59990 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab2EHVaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 17:30:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC v2 2/5] PM, Add sysfs file power_off to control device power off policy
Date: Tue, 8 May 2012 23:34:57 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>, Lan Tianyu <tianyu.lan@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <201205072253.47736.rjw@sisk.pl> <1336441458.6190.133.camel@yhuang-dev>
In-Reply-To: <1336441458.6190.133.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205082334.58157.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 08, 2012, Huang Ying wrote:
> On Mon, 2012-05-07 at 22:53 +0200, Rafael J. Wysocki wrote:
> > On Saturday, May 05, 2012, huang ying wrote:
> > > On Sat, May 5, 2012 at 3:33 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > On Friday, May 04, 2012, Huang Ying wrote:
> > > >> From: Lan Tianyu <tianyu.lan@intel.com>
[...]
> > I think we may add helpers for exporting/unexporting power_off_allowed
> > like for the PM QoS latency attribute.  Then, whoever wants to support
> > power_off_allowed and use it will export it through that helper.
> 
> That sounds good!
> 
> > Still, I'm afraid we're trying to special case something that really ins't
> > a special case.  Namely, we may want to restrict devices from using some
> > other low-power states as well, not only power off (eg. we may want to
> > prevent devices' clocks from being stopped).
> 
> One step towards generalization is to provide a way for user to specify
> lowest power state allowed.  For example, for PCI devices, they can
> specify D1, D2, D3hot or D3cold.  But it is hard to generalize a set of
> low power states for all kind of devices.  Maybe we should keep this
> user space interface bus specific?

I came to the same conclusion. :-)

Besides, we already have the no_d1d2 and d1_support, d2_support flags
in struct pci_dev.  We can simply add no_d3_cold in analogy and add a similar
thing for ATA to cover the ZPODD case.

I would keep those things bus-type-specific and platform-specific.

> For example, we can have a sysfs file like "lowest_pm_state_allowed" for each
> PCI devices.

I'm not sure if that's going to be sufficient, because some devices appear to
have problems with _intermediate_ low-power states.

> BTW:  I wonder that are there standard low power states defined for
> devices on platform bus.

Not that I know of.

Thanks,
Rafael
