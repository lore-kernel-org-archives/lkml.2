Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab0FOB5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 21:57:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34206 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab0FOB5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 21:57:36 -0400
Message-ID: <4C16DDC1.30006@zytor.com>
Date: Mon, 14 Jun 2010 18:56:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Yinghai Lu <yinghai.lu@oracle.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Graham Ramsey <ramsey.graham@ntlworld.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>, Jiri Slaby <jslaby@suse.cz>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Myron Stowe <myron.stowe@hp.com>
Subject: Re: [PATCH -v2] x86, pci: Handle fallout pci devices with peer root
 bus
References: <4BF40014.30303@ntlworld.com> <201006141420.15799.bjorn.helgaas@hp.com> <4C169ABC.1090406@zytor.com> <201006141949.51674.bjorn.helgaas@hp.com>
In-Reply-To: <201006141949.51674.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 06:49 PM, Bjorn Helgaas wrote:

>>
>> Invisible PCI bridges have been known to occur in pure PCI space, too.
> 
> Are you talking about PCI host bridges that don't appear in PCI config
> space?  I suppose those could be described as "invisible," but since
> host bridges aren't architected and their primary interface isn't PCI,
> it seems only natural that we'd discover them by a non-PCI mechanism.
> They're invisible in PCI terms, but obviously perfectly discoverable
> and configurable via ACPI.

I mean invisible PCI-PCI bridges.  Yes, they exist.

> If you ask me, it's weird that most x86 chipsets put PCI host bridge
> configuration in PCI config space -- it may be convenient in some ways,
> but still architecturally strange.

It is only strange because they are non-bridge devices.  PCI-Express
fixes that to some degree with the whole "root complex" notion, but
really a PCI host bridge should have been a bridge device from the start.

> I suppose one could argue that there's a non-standard P2P bridge
> from bus 00 to bus 80, but I can't imagine anybody doing that.

Ah, ye of little imagination.

> An OS would have to have vendor-specific code just to do PCI
> resource management, and that really misses the point of PCI.

This really misses the point of HT...

> It seems more likely to me that one of the VIA host bridges leads
> to bus 80.  PCI host bridges are not architected, so if this bridge
> lives on HT chain 00, and we can think of HT as "not quite PCI,"
> then it seems natural that the host bridge would be VIA-specific,
> just like it was in pre-HT days.

I think the best word for it is "incompetent braindamage", but that's
just me...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

