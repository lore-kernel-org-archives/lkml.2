Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2EGU2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:28:13 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:57856 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756667Ab2EGU2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:28:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: huang ying <huang.ying.caritas@gmail.com>
Subject: Re: [RFC v2 1/5] PM, Runtime, Add power_must_be_on flag
Date: Mon, 7 May 2012 22:33:00 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Zheng Yan <zheng.z.yan@intel.com>
References: <1336119221-21146-1-git-send-email-ying.huang@intel.com> <201205042137.16425.rjw@sisk.pl> <CAC=cRTOpbbHCSXN3=JKZkpy753G0-Vgbu0DkbV-v_coVMM7Qzw@mail.gmail.com>
In-Reply-To: <CAC=cRTOpbbHCSXN3=JKZkpy753G0-Vgbu0DkbV-v_coVMM7Qzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205072233.01110.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 05, 2012, huang ying wrote:
> On Sat, May 5, 2012 at 3:37 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, May 04, 2012, Huang Ying wrote:
> >> The extreme way to save device power in runtime is to turn off power
> >> of device.  For example, D3cold for PCIe bus and ZPODD (Zero Power
> >> Optical Disk Drive) for SATA bus will do that.
> >>
> >> But sometimes power off is not expected, some possible reason is as
> >> follow
> >>
> >> - power off device usually incurs longer resume latency, if it exceeds
> >>   power QoS requirement, power off should be disabled.
> >>
> >> - For some buses, device in power off state can not support remote
> >>   wakeup.  If remote wakeup is desired, power off should be disabled.
> >>
> >> In general, whether to put a device into power off state should be
> >> decided by the driver of the device, but for some buses, whether to
> >> put a device into power off state may be done by the parent of the
> >> device.  For example, a PCIe end point device may be put into power
> >> off state by the PCIe port connected to it.
> >>
> >> So a flag is introduced for the children devices to tell the parent
> >> device, whether it should be put into power off state.
> >>
> >> This flag is also used for device driver to tell bus layer whether it
> >> is OK to be powered off.
> >>
> >> Signed-off-by: Huang Ying <ying.huang@intel.com>
> >
> > I would be almost fine with this patch, if [2/5] were not present.
> >
> > However, if you introduce a flag like this, you need to put checks
> > against it into all places where power may be removed from devices,
> > like the generic PM domains framework (but not only there).
> 
> Yes.  At least this flag will be needed by other buses, like ZPODD
> support from Lin Ming:
> 
> https://lkml.org/lkml/2012/3/28/23
> 
> So my original plan is to introduce this flag firstly, then to add
> checking for this flag in various places need it.

That sounds like a good plan, but then please don't export this to user
space as long as the kernel side is complete.

> Do you suggest to
> put PCIe D3cold support, ZPODD support, power domain related checking
> into one patchset.

This isn't necessary so long as the flag is not exported.

Thanks,
Rafael
