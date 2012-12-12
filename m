Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab2LLWeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:34:15 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:59077 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab2LLWeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:34:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Yijing Wang <wangyijing0307@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 5/6] ACPI: Replace struct acpi_bus_ops with enum type
Date: Wed, 12 Dec 2012 23:39:12 +0100
Message-ID: <20863259.Bu9Is6dGkB@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <50C89D2B.4060206@gmail.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <50C89608.7050908@gmail.com> <50C89D2B.4060206@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 12, 2012 11:05:15 PM Jiang Liu wrote:
> On 12/12/2012 10:34 PM, Yijing Wang wrote:
> > 于 2012-12-12 2:30, Rafael J. Wysocki 写道:
> >> Hi Gerry,
> >>
> >> On Tuesday, December 11, 2012 11:09:06 PM Jiang Liu wrote:
> >>> Hi Rafael,
> >>> 	I have worked out a patch set to clean up ACPI/PCI related notifications,
> >>> please refer to
> >>> http://www.spinics.net/lists/linux-pci/msg17822.html
> >>> 	The patchset doesn't apply cleanly to Bjorn's latest pci-next tree. I will
> >>> help to rebase it if needed.
> >>
> >> I have reviewed the patches and I think they make sense overall.  However,
> >> the statement that acpi_pci_bind()/acpi_pci_unbind() are used to maintain
> >> PCI-ACPI binding relationships is quite inaccurate, because all what these
> >> functions do is to (1) add/remove ACPI PM notifiers to/from PCI devices and
> >> (2) retrieve the _PRT information for bridges from ACPI tables.  In fact,
> >> the *binding* itself is managed by the code in drivers/acpi/glue.c.
> >>
> >> Also, please have a look at my suggestion in the last reply to Yinghai:
> >>
> >> http://marc.info/?l=linux-pci&m=135522965707752&w=2
> >>
> >> In fact, I think we can go even further than that.  Namely, if we populate the
> >> ACPI handle of the device in pci_scan_device(), then we can just move the PM
> >> notifier and wakeup setup to platform_pci_wakeup_init(), where it should be
> >> (we'll also need to add a corresponding _exit() function, then, but that'll be
> >> much cleaner anyway).
> >>
> >> Then, the remaining thing would be to ensure that _PRT entries are parsed
> >> as appropriate somewhere around pci_init_capabilities().
> >>
> >> Also, I wonder if you can help test the $subject patchset on a system with
> >> hardware PCI hotplug (preferably on top of the linux-pm.git/master branch)?
> >>
> > Hi Rafael,
> >    We are doing test for this series patches, I will send out the test result as soon.
> Hi Rafael,
> 	We have tried to merge your patchset with IOH hotplug patchsets from Yinghai,
> and obviously it's not a ease task and we have run into panics. We will try to find
> some ways to test your patchset only next step.

Thanks a lot for doing this, really appreciated!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
