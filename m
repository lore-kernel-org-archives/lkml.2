Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab2AXRvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 12:51:15 -0500
Received: from paperboy.avencall.com ([91.194.178.22]:55784 "EHLO
	mx1.corp.avencall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755100Ab2AXRvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 12:51:13 -0500
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jan 2012 12:51:13 EST
Date: Tue, 24 Jan 2012 18:42:03 +0100
From: Guillaume Knispel <gknispel@proformatique.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, Guillaume Knispel <gknispel@avencall.com>,
        Xavier Carcelle <xcarcelle@avencall.com>,
        =?ISO-8859-1?Q?No=E9?= Rubinstein <nrubinstein@avencall.com>
Subject: How to "register" a GSI for a non PCI non ISA device
Message-ID: <20120124184203.1b0878c2@xilun>
Organization: Avencall
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm building a PC platform with additional non-PCI and non-ISA devices:
they are basically simple telecom chipsets connected to an SPI and an
old school parallel bus (Intel LEB bus) and GPIO pins that can be used
as interrupts through the IO APIC which exposes 40 GSI. From the point
of view of the software the SPI, LEB, and GPIO are provided by PCI
devices (in reality they are embedded controllers in an Intel SoC
80579). Anyway I'm not sure the additional GSI are described anywhere
in whatever black magic ACPI / legacy BIOS table they could be
(but I've complete control over the FW, so I can had whatever is
 needed when I know it).

But as my devices are neither PCI nor ISA, I don't know how i can get
access to the custom GSI interrupt from a LKM. acpi_register_gsi() used
to be exported but is not anymore and I guess this is mandatory that
this function is called to prepare internal structures (maybe irq_desc)
and most importantly to configure to level triggering active low.

So I'm thinking about writing black magic DSDT stuffs or whatever,
which i might be able to sort of do after reading the fabulous ACPI
specifications. Any feedback or pointer would be highly welcome.

BTW when Linux devs says that bios writers are writing shit, yeah, they
do, and given the state of complexity of the PC platform, I'm at the
risk to do it too because I'm not supposed to delay the production of
our system by one additional year just to completely learn how the
shitty PC "standards" are supposed to work. From a more personal
point of view when I'm reading the ACPI or other related specs tainted
by MS and their desire to put GUID everywhere and other terrible ideas,
I would rather prefer being high to not endure that much pain.

As more and more x86 systems are directly designed to run Linux and
only tested with it, with some of those (like our own) being built
by people having complete control on the board and firmware (Coreboot),
maybe it is time to define a legacy-free variant of the x86 plateform
(especially on the FW/OS interface) for the free software and free
hardware design world, so that we aren't restricted and slowed down by
retro-compatible technologies dedicated at running MS-DOS and created
with the explicit goal to be hard to use for anything else than
Windows NT.

Cheers!
-- 
Guillaume Knispel
Avencall - 10 bis, rue Lucien Voilin - 92800 Puteaux

