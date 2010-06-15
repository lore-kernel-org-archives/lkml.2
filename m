Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab0FON1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:27:11 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:47078 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab0FON1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:27:09 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Bernd Petrovitsch <bernd@sysprog.at>
Subject: Re: "ignoring host bridge windows from ACPI" in a recent laptop
Date: Tue, 15 Jun 2010 07:27:10 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <1276600703.31461.53.camel@thorin>
In-Reply-To: <1276600703.31461.53.camel@thorin>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006150727.10978.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 15, 2010 05:18:23 am Bernd Petrovitsch wrote:
> Hi!
> 
> I have a Sony Vaio VPCF11M1E since early this year. Looking through the
> output of `dmesg`, I noticed
> ----  snip  ----
> pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
> ----  snip  ----
> So I tried that.
> The laptop boots and works without problems so far. I attached a diff of
> the first approx. 630 lines of the `dmesg` outputs without and with the
> above parameter. It gets pretty messy afterwards because (at least) the
> USB and/or SATA initialization runs apparently in parallel.
> 
> After finding http://lkml.org/lkml/2010/2/12/174, it seems that we might
> need another quirk to activate that automatically.
> 
> At the end, I lost also dozens of
> ----  snip  ----
> name_count maxed, losing inode data: dev=00:07, inode=
> ----  snip  ----
> lines (which are also not in the attached diff). I don't know if that
> has something to do with the above.

Until the patch you mentioned above, Linux silently ignored window
information from ACPI.  On your machine, the only effect of the
patch was to print the new line you mentioned, which was only intended
as a hint that "if PCI devices don't work correctly, here's something
we can try."

If your devices *are* working correctly, you can just ignore the hint.

You mention the "name_count maxed" messages, and I think you meant
they go away when you use "pci=use_crs".  I don't see how that would
be connected, since that's from syscall auditing code that is several
layers removed from PCI device resource management.

Bjorn
