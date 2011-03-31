Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab1CaMwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:52:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46543 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab1CaMwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:52:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RwfIk2p81vRM3bh1Yfds5kyLT14VbcoslD4FrJyoc3CLCW+4uh8RNp4UQ4mVZELheP
         hJsVBB1Sx5q3r1j8Pnr7up68J4FEsDzcBOUb40spRbvkmyHXfNaFQ1tNsAUu0CdZpBEp
         J1DBNZ6zVnztr1eqkdiCdhdYQLoDA2xMLTuK0=
Date: Thu, 31 Mar 2011 14:52:17 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Tvrtko Ursulin <tvrtko@ursulin.net>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: 2.6.38 hangs on boot until key is pressed
Message-ID: <20110331125217.GB14693@alberich.amd.com>
References: <1301253485.2500.2.camel@deuteros>
 <20110330155350.GA31845@alberich.amd.com>
 <1301509097.2538.4.camel@deuteros>
 <20110331124352.GA14693@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331124352.GA14693@alberich.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 02:43:52PM +0200, Andreas Herrmann wrote:
> On Wed, Mar 30, 2011 at 07:18:17PM +0100, Tvrtko Ursulin wrote:
> > On Wed, 2011-03-30 at 17:53 +0200, Andreas Herrmann wrote:
> > > On Sun, Mar 27, 2011 at 08:18:05PM +0100, Tvrtko Ursulin wrote:
> > > > 
> > > > Hi all,
> > > > 
> > > > It always happens at the same spot. 2.6.37 is fine with almost
> > > > identical .config. Dmesg and config attached.
> > > 
> > > 
> > > Hi,
> > > 
> > > can you please send dmesg when 2.6.37 is booted.
> > > Also output of "lspci -nnxxxx" would be of interest.
> 
> Sorry, forgot to say that lspci -nnxxxx should also be run as root.
> (To get complete PCI config space.)
> 
> > > dmidecode (as root) would also help.
> > 
> > Attached.
> 
> Thanks.
> 
> > > Does it help to disable C1e in your BIOS (if there is such an option)?
> > > If there is no such option please try to boot 2.6.38.1 with idle=mwait
> > > on the command line.
> > 
> > Both tests (on their own) booted without hanging.
> 
> Ok.
> 
> This reminds me on some Gigabyte mainboards (for which we couldn't
> root cause the problem). The workaround for those boards was to boot
> with acpi_skip_timer_override.
> 
> The Gigabyte mainboards had some odd lapic_id settings and yours too:
> 
> > [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> > [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> > [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> > [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> > [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)   <====
> > [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)   <====
> > [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> > [    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
> 
> This should rather look like

Sorry, forget this statement. You have a quad-core and not a six-core
CPU so this setting seems to be ok. (But it's still worth to try the
acpi_skip_timer_override option.)


Andreas
