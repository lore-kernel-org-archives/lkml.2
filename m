Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0G1Lz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 07:55:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53861 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0G1Lz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 07:55:56 -0400
Date: Wed, 28 Jul 2010 12:55:43 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC][PATCH] PCI / PCIe: Ask BIOS for control of all native
	services simultaneously
Message-ID: <20100728115543.GA11697@srcf.ucam.org>
References: <201007250105.23610.rjw@sisk.pl> <4C4FA663.9090204@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4FA663.9090204@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 12:39:15PM +0900, Hidetoshi Seto wrote:
> Hi,
> 
> (2010/07/25 8:05), Rafael J. Wysocki wrote:
> > It turns out that asking ACPI BIOS, through _OSC, for control of each
> > PCIe port native service individually sometimes confuses the BIOS if
> > one sevice is requested while the others are not (eg. requesting
> > control of the native PCIe PME without requesting control of the
> > native PCIe hot-plug at the same time leads to interrupt storms on
> > some systems).
> 
> Then why not invent quirks or something for such systems?

Because we'll have a quirk table with dozens of entries and it won't be 
comprehensive.

> IMHO it sounds like a BIOS bug since it should grant PME control to
> OS only when both of PME and pciehp (plus PCIe caps) are requested
> at same time.

We're in the business of writing an operating system that's able to 
drive the hardware that exists, not just the hardware that follows the 
specs completely. It's implausible that we'll get every broken BIOS 
fixed, and it's implausible that we'll be able to work out a list of 
every broken computer.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
