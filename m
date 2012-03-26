Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab2CZOTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:19:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406Ab2CZOTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:19:34 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] ACPI: Implement overriding of arbitrary ACPI tables via initrd
Date: Mon, 26 Mar 2012 16:19:31 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: eric.piel@tremplin-utc.net, vojcek@tlen.pl, dsdt@gaugusch.at,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Lin Ming <ming.m.lin@intel.com>, lenb@kernel.org,
        robert.moore@intel.com, Al Viro <viro@zeniv.linux.org.uk>
References: <1332512984-79664-1-git-send-email-trenn@suse.de> <201203260245.43177.trenn@suse.de> <4F6FC57D.3050404@zytor.com>
In-Reply-To: <4F6FC57D.3050404@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203261619.31766.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 26, 2012 03:25:17 AM H. Peter Anvin wrote:
> On 03/25/2012 05:45 PM, Thomas Renninger wrote:
> > Best would be if no distro specific mkinitrd magic is needed and it's
> > just as easy as it is:
> > cp DSDT.aml /boot/initrd-test
> > cat /boot/initrd >>/boot/initrd-test
> > and add a test boot entry to grub's menu.lst or whereever.
> > Then developers would not have to look at distro specific implementations
> > (which should not exist) about how to test a table quickly.
> 
> There is no distro-specific magic needed.  What I'm proposing is
> basically what you have above, except that your DSDT.aml would be
> wrapped in a cpio header.  What I would like to ask from you is if it
> makes sense to have kernel/acpi/DSDT, kernel/acpi/SSDT and so on, or
> just make it a single kernel/acpi member.
Do the names have to be fixed?
Then it would not make much sense. Possibly placeholder file names like:
table1.aml...table10.aml
could be defined.
Especially the possibility of several SSDTs makes a naming convention
rather ugly: SSDT1.aml, SSDT2.aml...
If there is a directory which (only) contains all ACPI table files that can
be scanned and the file names do not matter, it's rather nice to set it
up in userspace. I guess I have to do 2 iterations then:
  - Go through all files in this dir, validate each as a valid ACPI table
    and sum up the size of all these files -> Reserve "size of all files".
  - Then do a 2nd iteration and copy all these files into the reserved
    memory area.
  
If there is only one file where all ACPI table binaries are glued
together kernel/acpi_tables.binary.blob
my code should already work as good as unmodified.

Not sure what is best and whether anybody cares about how the tables
are layed out.

I guess I just wait until your functionality is in linux-next and
give it a closer look then and may come up with a new patch.

> By wrapping in a cpio container it becomes a generic mechanism.
> 
> >> By the way, if "relying on the bootloader" was an option in any way
> > 
> > Why exactly is a change in the bootloader not an option?
> > Not sure whether a version number is passed, but the magic number could be
> > changed for now.
> 
> There are a lot of bootloaders, and one of the most commonly used ones
> has a very adversarial relationship with the kernel maintainers.
> 
> > If the new magic number is passed, we get a linked list.
> 
> The linked list stuff is already supported.  This interface has been
> supported in the kernel since 2007.
Ok, got it. Thanks.

    Thomas
