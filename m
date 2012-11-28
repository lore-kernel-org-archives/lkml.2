Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945914Ab2K1WjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:39:14 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:35552 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932312Ab2K1WjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:39:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PCI/PM: Keep runtime PM enabled for unbound PCI devices
Date: Wed, 28 Nov 2012 23:43:56 +0100
Message-ID: <1962888.rQgbRUetgj@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAErSpo6CPSMXjq1eSTX41vtwOcd5rQOdC0-9ye5NZhds9U1B8A@mail.gmail.com>
References: <1353398902-21253-1-git-send-email-ying.huang@intel.com> <CAErSpo6CPSMXjq1eSTX41vtwOcd5rQOdC0-9ye5NZhds9U1B8A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 28, 2012 03:25:59 PM Bjorn Helgaas wrote:
> On Tue, Nov 20, 2012 at 1:08 AM, Huang Ying <ying.huang@intel.com> wrote:
> > For unbound PCI devices, what we need is:
> >
> >  - Always in D0 state, because some devices does not work again after
> >    being put into D3 by the PCI bus.
> >
> >  - In SUSPENDED state if allowed, so that the parent devices can still
> >    be put into low power state.
> >
> > To satisfy these requirement, the runtime PM for the unbound PCI
> > devices are disabled and set to SUSPENDED state.  One issue of this
> > solution is that the PCI devices will be put into SUSPENDED state even
> > if the SUSPENDED state is forbidden via the sysfs interface
> > (.../power/control) of the device.  This is not an issue for most
> > devices, because most PCI devices are not used at all if unbounded.
> > But there are exceptions.  For example, unbound VGA card can be used
> > for display, but suspend its parents make it stop working.
> >
> > To fix the issue, we keep the runtime PM enabled when the PCI devices
> > are unbound.  But the runtime PM callbacks will do nothing if the PCI
> > devices are unbound.  This way, we can put the PCI devices into
> > SUSPENDED state without put the PCI devices into D3 state.
> 
> Does this fix a reported problem?  Is there a bug report URL?  What
> problem would a user notice?

There is a BZ: https://bugzilla.kernel.org/show_bug.cgi?id=48201

Unfortunately, the reporter hasn't confirmed that the bug is fixed,
although we're quite confident that it will be.

> This doesn't look critical enough to try to put in v3.7 (correct me if
> I'm wrong).  It's getting pretty late for the v3.8 merge window, but
> it looks like it qualifies as a bug fix that we would merge even after
> the merge window, so I'll put it in my -next branch headed for v3.8.
> Then it can be backported to v3.6 and v3.7.

I think that's OK.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
