Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab2JDUU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 16:20:26 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59414 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011Ab2JDUUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 16:20:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4] ACPI: kill acpi_pci_root_start
Date: Thu, 04 Oct 2012 21:54:36 +0200
Message-ID: <1535647.4ENXPBYvrO@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.4.6-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAErSpo48XLzLvziACEi+0nWuRXurHCLnw+iwgqu8-BRutjNtWw@mail.gmail.com>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com> <CAE9FiQWDnrk7VccFLLHucCVSxN5RRS0-8pwYazLy2aw3oqmPLQ@mail.gmail.com> <CAErSpo48XLzLvziACEi+0nWuRXurHCLnw+iwgqu8-BRutjNtWw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 of October 2012 13:44:42 Bjorn Helgaas wrote:
> On Thu, Oct 4, 2012 at 12:36 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Thu, Oct 4, 2012 at 10:47 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >> On Wed, Oct 03, 2012 at 04:00:10PM -0700, Yinghai Lu wrote:
> >> This is a fundamental difference: at boot-time, all the ACPI devices below the
> >> host bridge already exist before the pci_root.c driver claims the bridge,
> >> while at hot-add time, pci_root.c claims the bridge *before* those ACPI
> >> devices exist.
> >>
> >> I think this is wrong.  The hot-plug case (where the driver is already
> >> loaded and binds to the device as soon as it's discovered, before the
> >> ACPI hierarchy below it is enumerated) seems like the obviously correct
> >> order.  I think we should change the boot-time order to match that, i.e.,
> >> we should register pci_root.c *before* enumerating ACPI devices.
> >
> > in booting path, all device get probed at first, and then register driver...
> > do you want to register all pci driver before probing pci devices?
> 
> I don't think we should have dependencies either way.  It shouldn't
> matter whether we enumerate devices first or we register the driver
> first.  That's why I think the current PCI/ACPI binding is broken --
> it assumes that we fully enumerate ACPI before the driver is
> registered.
> 
> To answer your specific question, yes, I do think drivers that are
> statically built in probably should be registered before devices are
> enumerated.  That way, the boot-time case is more similar to the
> hot-add case.
> 
> Obviously, for drivers that can be modules, the reverse must work as
> well (enumerate devices, then load and register the driver).  And then
> the other order (register driver, then enumerate device) must also
> work so future hot-adds of the same device type work.

Agreed.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
