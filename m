Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab2LLOfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 09:35:25 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51483 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab2LLOfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 09:35:00 -0500
Message-ID: <50C89608.7050908@gmail.com>
Date: Wed, 12 Dec 2012 22:34:48 +0800
From: Yijing Wang <wangyijing0307@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 5/6] ACPI: Replace struct acpi_bus_ops with enum type
References: <8498184.VilrUmatxI@vostro.rjw.lan> <CAE9FiQXYPPcRZZBFGrqcV--0-UixMH1f+q4WdovErthsLhxn7A@mail.gmail.com> <50C74C92.1040405@gmail.com> <2093499.q2b9fD3smR@vostro.rjw.lan>
In-Reply-To: <2093499.q2b9fD3smR@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012-12-12 2:30, Rafael J. Wysocki 写道:
> Hi Gerry,
> 
> On Tuesday, December 11, 2012 11:09:06 PM Jiang Liu wrote:
>> Hi Rafael,
>> 	I have worked out a patch set to clean up ACPI/PCI related notifications,
>> please refer to
>> http://www.spinics.net/lists/linux-pci/msg17822.html
>> 	The patchset doesn't apply cleanly to Bjorn's latest pci-next tree. I will
>> help to rebase it if needed.
> 
> I have reviewed the patches and I think they make sense overall.  However,
> the statement that acpi_pci_bind()/acpi_pci_unbind() are used to maintain
> PCI-ACPI binding relationships is quite inaccurate, because all what these
> functions do is to (1) add/remove ACPI PM notifiers to/from PCI devices and
> (2) retrieve the _PRT information for bridges from ACPI tables.  In fact,
> the *binding* itself is managed by the code in drivers/acpi/glue.c.
> 
> Also, please have a look at my suggestion in the last reply to Yinghai:
> 
> http://marc.info/?l=linux-pci&m=135522965707752&w=2
> 
> In fact, I think we can go even further than that.  Namely, if we populate the
> ACPI handle of the device in pci_scan_device(), then we can just move the PM
> notifier and wakeup setup to platform_pci_wakeup_init(), where it should be
> (we'll also need to add a corresponding _exit() function, then, but that'll be
> much cleaner anyway).
> 
> Then, the remaining thing would be to ensure that _PRT entries are parsed
> as appropriate somewhere around pci_init_capabilities().
> 
> Also, I wonder if you can help test the $subject patchset on a system with
> hardware PCI hotplug (preferably on top of the linux-pm.git/master branch)?
> 
Hi Rafael,
   We are doing test for this series patches, I will send out the test result as soon.

Thanks!
Yijing



