Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab2K0BLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 20:11:12 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43197 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab2K0BLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 20:11:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com>
References: <097501cdca7b$7e303890$7a90a9b0$@lucidpixels.com>
	<20121126224245.248f0901@neptune.home>
	<CAErSpo7Y7m9o2u36ghiW1UDkwweSCG1ZGBx167Anfw4wXTYrCg@mail.gmail.com>
Date: Mon, 26 Nov 2012 17:11:09 -0800
Message-ID: <CAA9_cmcodVC84-fxN__+=A3nvUgVFv8yuuVvT7W7tH=Qa59Dag@mail.gmail.com>
Subject: Re: Supermicro X9SRL-F - channel enumeration error & ACPI/firmware
 bug question
From: Dan Williams <dan.j.williams@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, support@supermicro.com,
        linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        "dave.jiang" <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 4:56 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> The "channel error register unreachable" message indicates that
> pci_read_config_dword() failed.  The register in question
> (IOAT_PCI_CHANERR_INT_OFFSET) is at 0x180, so possibly we don't have
> PCI config accessors for the extended config space (0x100-0xfff).  A
> complete dmesg log should show that.

Yes, this happens when extended pci configuration space is not
reachable.  Although the need to access this register has been found
to no longer be needed.  So, it appears this patch [1] from Dave
should be modified to just stop touching that register altogether and
then go to -stable.

--
Dan

[1]: http://marc.info/?l=linux-kernel&m=135310841032707&w=2
