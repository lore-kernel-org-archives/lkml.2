Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab2L0AKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 19:10:39 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:54442 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2L0AKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 19:10:35 -0500
MIME-Version: 1.0
In-Reply-To: <6257154.ucqGyPHqkg@vostro.rjw.lan>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan>
	<CAE9FiQWr6-=kvrCXKEWFvUHHv6xbHKt-oAdt+VPUMphVUW4U4A@mail.gmail.com>
	<CAE9FiQVOvqqEFXcRbZt5=8e4fQgmzw03WCS=env46eYADFpXLw@mail.gmail.com>
	<6257154.ucqGyPHqkg@vostro.rjw.lan>
Date: Wed, 26 Dec 2012 16:10:32 -0800
X-Google-Sender-Auth: QhVP-Qp0xlzBl3Os6NjXVAaLSY0
Message-ID: <CAE9FiQWpAvgam3t7isFcZOz+OEe4D4QJxBbqcbiqMJVwJz=-8A@mail.gmail.com>
Subject: Re: [Alternative][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 2:36 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, December 26, 2012 12:41:05 PM Yinghai Lu wrote:
>> On Wed, Dec 26, 2012 at 12:16 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Wed, Dec 26, 2012 at 12:10 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> >> Do you have a reference for this?  I think this might have been true
>> >> in the past, but I don't think it's true for any version of gcc we
>> >> support for building Linux.
>> >
>> > http://lkml.indiana.edu/hypermail/linux/kernel/0804.3/3600.html
>>
>> the problem is already addressed by:
>>
>> | commit f9d14250071eda9972e4c9cea745a11185952114
>> | Author: Linus Torvalds <torvalds@linux-foundation.org>
>> | Date:   Fri Jan 2 09:29:43 2009 -0800
>> |
>> |    Disallow gcc versions 4.1.{0,1}
>> |
>> |    These compiler versions are known to miscompile __weak functions and
>> |    thus generate kernels that don't necessarily work correctly.  If a weak
>> |    function is int he same compilation unit as a caller, gcc may end up
>> |    inlining it, and thus binding the weak function too early.
>> |
>> |    See
>> |
>> |        http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781
>> |
>> |    for details.
>>
>> so it is ok to put the __weak in the same file now.
>
> Cool, thanks for checking and for the ACK!

wait, we have some problem on systems that root bus is not exported via DSDT ...

one of my nehalem system that have uncore cpu devices are not exported via ACPI.

also there will be problem that system is booting with acpi=off.


+int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
+{
+       struct pci_sysdata *sd = bridge->bus->sysdata;
+       struct pci_root_info *info = container_of(sd, struct pci_root_info, sd);
+
+       ACPI_HANDLE_SET(&bridge->dev, info->bridge->handle);
+       return 0;
+}

will get wrong info...via sd... as their sd is standalone

Thanks

Yinghai
