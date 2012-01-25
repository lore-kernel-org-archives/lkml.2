Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab2AYF46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 00:56:58 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:55940 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab2AYF44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 00:56:56 -0500
Message-ID: <4F1F99A5.1000206@kernel.org>
Date: Wed, 25 Jan 2012 00:56:53 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Guillaume Knispel <gknispel@proformatique.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Guillaume Knispel <gknispel@avencall.com>,
        Xavier Carcelle <xcarcelle@avencall.com>,
        =?ISO-8859-1?Q?No=E9_Rubinst?= =?ISO-8859-1?Q?ein?= 
	<nrubinstein@avencall.com>
Subject: Re: How to "register" a GSI for a non PCI non ISA device
References: <20120124184203.1b0878c2@xilun>
In-Reply-To: <20120124184203.1b0878c2@xilun>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2012 12:42 PM, Guillaume Knispel wrote:

> Hi,
> 
> I'm building a PC platform with additional non-PCI and non-ISA devices:
> they are basically simple telecom chipsets connected to an SPI and an
> old school parallel bus (Intel LEB bus) and GPIO pins that can be used
> as interrupts through the IO APIC which exposes 40 GSI. From the point
> of view of the software the SPI, LEB, and GPIO are provided by PCI
> devices (in reality they are embedded controllers in an Intel SoC
> 80579). Anyway I'm not sure the additional GSI are described anywhere
> in whatever black magic ACPI / legacy BIOS table they could be
> (but I've complete control over the FW, so I can had whatever is
>  needed when I know it).

What is the benefit of implementing ACPI on this custom system?

-Len

> But as my devices are neither PCI nor ISA, I don't know how i can get
> access to the custom GSI interrupt from a LKM. acpi_register_gsi() used
> to be exported but is not anymore and I guess this is mandatory that
> this function is called to prepare internal structures (maybe irq_desc)
> and most importantly to configure to level triggering active low.
> 
> So I'm thinking about writing black magic DSDT stuffs or whatever,
> which i might be able to sort of do after reading the fabulous ACPI
> specifications. Any feedback or pointer would be highly welcome.
> 
> BTW when Linux devs says that bios writers are writing shit, yeah, they
> do, and given the state of complexity of the PC platform, I'm at the
> risk to do it too because I'm not supposed to delay the production of
> our system by one additional year just to completely learn how the
> shitty PC "standards" are supposed to work. From a more personal
> point of view when I'm reading the ACPI or other related specs tainted
> by MS and their desire to put GUID everywhere and other terrible ideas,
> I would rather prefer being high to not endure that much pain.
> 
> As more and more x86 systems are directly designed to run Linux and
> only tested with it, with some of those (like our own) being built
> by people having complete control on the board and firmware (Coreboot),
> maybe it is time to define a legacy-free variant of the x86 plateform
> (especially on the FW/OS interface) for the free software and free
> hardware design world, so that we aren't restricted and slowed down by
> retro-compatible technologies dedicated at running MS-DOS and created
> with the explicit goal to be hard to use for anything else than
> Windows NT.
> 
> Cheers!


