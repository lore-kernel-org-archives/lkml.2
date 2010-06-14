Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0FNTng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 15:43:36 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:18778 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0FNTne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 15:43:34 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -v2] x86, pci: Handle fallout pci devices with peer root bus
Date: Mon, 14 Jun 2010 13:43:32 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Yinghai Lu <yinghai.lu@oracle.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Graham Ramsey <ramsey.graham@ntlworld.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>, Jiri Slaby <jslaby@suse.cz>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <4BF40014.30303@ntlworld.com> <201006141234.17912.bjorn.helgaas@hp.com> <4C16777A.7060600@zytor.com>
In-Reply-To: <4C16777A.7060600@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141343.33513.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 14, 2010 12:39:54 pm H. Peter Anvin wrote:
> On 06/14/2010 11:34 AM, Bjorn Helgaas wrote:
> > 
> > I made the point there that an HT chain may contain multiple HT/PCI
> > host bridges, but you are stuck on the idea that "one HT chain == one
> > PCI root bus."
> > 
> > I have not found the "one PCI host bridge per HT chain" requirement
> > in the HT spec (if you find it, please point me to it).
> > 
> > If an HT chain may contain multiple HT/PCI host bridges, then it's
> > obvious that the HT host bridge registers read by amd_bus.c don't
> > contain enough information to correctly assign address space to the
> > PCI root buses.
> 
> A HT-to-PCI bridge appears as a PCI-to-PCI bridge (i.e. a Header Type 1
> device), not as a host bridge (a Header Type 0 device).
> 
> That is at least the software model as defined.

Certainly that's what the HT I/O Link spec (v3.10, sec 7.4) suggests,
and I think I saw hints that AMD chipsets do that.  I can't tell from
the HT I/O spec whether it would be an actual defect to use host bridges
instead of PCI-to-PCI bridges, and I can imagine why one might want to
leave an existing PCI host bridge design alone and merely glue on an
HT interface, rather than redesign the bridge register set.

In any case, the VIA chipset in Graham's machine does not have a
PCI-to-PCI bridge leading to bus 80 (see
https://bugzilla.kernel.org/show_bug.cgi?id=16007#c14).
However, ACPI *does* report a PCI host bridge leading to bus 80,
and the apertures it reports seem to be correct (see
https://bugzilla.kernel.org/show_bug.cgi?id=16007#c6).

Bjorn
