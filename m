Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab2AYTEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 14:04:47 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:63294 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab2AYTEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 14:04:44 -0500
Date: Wed, 25 Jan 2012 14:02:14 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Guillaume Knispel <gknispel@proformatique.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Xavier Carcelle <xcarcelle@avencall.com>,
        =?iso-8859-1?B?Tm/p?= Rubinstein <nrubinstein@avencall.com>
Subject: Re: How to "register" a GSI for a non PCI non ISA device
Message-ID: <20120125190214.GC18606@phenom.dumpdata.com>
References: <20120124184203.1b0878c2@xilun>
 <4F1F99A5.1000206@kernel.org>
 <20120125182314.7834c75b@xilun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120125182314.7834c75b@xilun>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F205242.0033,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 06:23:14PM +0100, Guillaume Knispel wrote:
> On Wed, 25 Jan 2012 00:56:53 -0500
> Len Brown <lenb@kernel.org> wrote:
> 
> > On 01/24/2012 12:42 PM, Guillaume Knispel wrote:
> > 
> > > Hi,
> > > 
> > > I'm building a PC platform with additional non-PCI and non-ISA devices:
> > > they are basically simple telecom chipsets connected to an SPI and an
> > > old school parallel bus (Intel LEB bus) and GPIO pins that can be used
> > > as interrupts through the IO APIC which exposes 40 GSI. From the point
> > > of view of the software the SPI, LEB, and GPIO are provided by PCI
> > > devices (in reality they are embedded controllers in an Intel SoC
> > > 80579). Anyway I'm not sure the additional GSI are described anywhere
> > > in whatever black magic ACPI / legacy BIOS table they could be
> > > (but I've complete control over the FW, so I can had whatever is
> > >  needed when I know it).
> > 
> > What is the benefit of implementing ACPI on this custom system?
> 
> For our short term project it seems to be more a necessity than a
> benefit. ACPI is supported by the SoC, tables are already largely
> provided by Coreboot, the whole x86 ecosystem including Linux is more
> or less based around ACPI, and my whole interrogation comes from the
> fact that *acpi*_register_gsi() seems to be necessary to configure a
> GSI in the APIC but is not exported anymore, so my guess is that if I

Hm, isn't it __acpi_register_gsi?

> can't call it explicitly from my LKM, there should better be a way to
> make it be called when an ACPI thing is done, or maybe a legacy table
> parsed.

Can you do it the way xen does? Look in arch/x86/xen/pci.c
> 
> As we first target an unmodified (if possible) 2.6.32 kernel from
> Debian Squeeze, I can't just re-export acpi_register_gsi() and call it
> a day. (If I've no other choice I'll obviously do it, but this would be
> quite bad for future maintenance).

Oh wow. That is ancient. 3.2?
