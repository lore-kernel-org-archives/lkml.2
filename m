Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab2AYRXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 12:23:25 -0500
Received: from paperboy.avencall.com ([91.194.178.22]:46830 "EHLO
	mx1.corp.avencall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756226Ab2AYRXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 12:23:23 -0500
Date: Wed, 25 Jan 2012 18:23:14 +0100
From: Guillaume Knispel <gknispel@proformatique.com>
To: Len Brown <lenb@kernel.org>
Cc: Guillaume Knispel <gknispel@proformatique.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Xavier Carcelle <xcarcelle@avencall.com>,
        =?ISO-8859-1?Q?No=E9?= Rubinstein <nrubinstein@avencall.com>
Subject: Re: How to "register" a GSI for a non PCI non ISA device
Message-ID: <20120125182314.7834c75b@xilun>
In-Reply-To: <4F1F99A5.1000206@kernel.org>
References: <20120124184203.1b0878c2@xilun>
 <4F1F99A5.1000206@kernel.org>
Organization: Avencall
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012 00:56:53 -0500
Len Brown <lenb@kernel.org> wrote:

> On 01/24/2012 12:42 PM, Guillaume Knispel wrote:
> 
> > Hi,
> > 
> > I'm building a PC platform with additional non-PCI and non-ISA devices:
> > they are basically simple telecom chipsets connected to an SPI and an
> > old school parallel bus (Intel LEB bus) and GPIO pins that can be used
> > as interrupts through the IO APIC which exposes 40 GSI. From the point
> > of view of the software the SPI, LEB, and GPIO are provided by PCI
> > devices (in reality they are embedded controllers in an Intel SoC
> > 80579). Anyway I'm not sure the additional GSI are described anywhere
> > in whatever black magic ACPI / legacy BIOS table they could be
> > (but I've complete control over the FW, so I can had whatever is
> >  needed when I know it).
> 
> What is the benefit of implementing ACPI on this custom system?

For our short term project it seems to be more a necessity than a
benefit. ACPI is supported by the SoC, tables are already largely
provided by Coreboot, the whole x86 ecosystem including Linux is more
or less based around ACPI, and my whole interrogation comes from the
fact that *acpi*_register_gsi() seems to be necessary to configure a
GSI in the APIC but is not exported anymore, so my guess is that if I
can't call it explicitly from my LKM, there should better be a way to
make it be called when an ACPI thing is done, or maybe a legacy table
parsed.

As we first target an unmodified (if possible) 2.6.32 kernel from
Debian Squeeze, I can't just re-export acpi_register_gsi() and call it
a day. (If I've no other choice I'll obviously do it, but this would be
quite bad for future maintenance).

Now if we consider the long term / big picture and ask ourselves what
is the benefit of ACPI for x86 systems with completely free designs and
running exclusively free operating systems, I consider it more as a
huge hindrance than as a benefit... Who understands that mess to begin
with? If people dedicated at building only COTS motherboards with
proprietary designs and BIOSes don't get it and repetitively make buggy
DSDT, I doubt than I or other people building complete free systems
with hugely limited resources would do very much better. But to
leverage major Linux distributions that kind of hardware platform
builders can be inclined to target existing kernels, so if there is no
pre-built alternative in them the whole ACPI stack will continue to be
used.

So I'm both looking for pointers to how to configure custom GSI in
existing kernels and if I need to do that through ACPI I'm also
interested in pointers to alternatives in Linux on x86 systems where we
could put that kind of description of the hardware platform in future
kernels (device-tree maybe?), because we are very interested in
contributing upstream to try to make our life easier for our next
products using a modern kernel.

-- 
Guillaume Knispel
Avencall - 10 bis, rue Lucien Voilin - 92800 Puteaux
