Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab0FNUUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:20:18 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:38954 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab0FNUUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:20:16 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -v2] x86, pci: Handle fallout pci devices with peer root bus
Date: Mon, 14 Jun 2010 14:20:15 -0600
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
References: <4BF40014.30303@ntlworld.com> <201006141400.22653.bjorn.helgaas@hp.com> <4C168C45.8060106@zytor.com>
In-Reply-To: <4C168C45.8060106@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141420.15799.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 14, 2010 02:08:37 pm H. Peter Anvin wrote:
> On 06/14/2010 01:00 PM, Bjorn Helgaas wrote:
> >>
> >> the host bridges is on AMD CPUs, 
> > 
> > Don't confuse the HT host bridge with the PCI host bridge.  The HT I/O spec
> > is quite clear that it uses "host bridge" to refer to the HT host bridge,
> > i.e., the interface between CPUs and a HyperTransport link.
> > 
> > I agree that the *HT host bridge* is indeed on the AMD CPU.  But that is
> > certainly not the same as the PCI host bridge that bridges between an HT
> > link and a PCI bus.
> > 
> > See sections 4.9.4 (HT host bridge) and 7.4 (HT/PCI host bridge), for
> > example.
> 
> From a software point of view the latter is [largely] a PCI-to-PCI
> bridge, though; it's not a root-level host bridge in the classical sense
> (as noted in section 7.4).

OK, but Graham's system doesn't have anything resembling a PCI-to-PCI
bridge leading to bus 80.  So while I agree that in an ideal world,
HT/PCI host bridges might always look like PCI-to-PCI bridges, it
seems this is not the case in practice.

> Incidentally, in my copy of HT 3.10b, section 7.4 is marked
> "HyperTransport Bridge Headers", and does not use the term "host bridge"
> to refer to a secondary PCI bus.  Section 4.9.4 is simply marked "Host
> Bridge".  As such, I think the HT spec is pretty consistent about
> unambiguously referring to the HT host bridge when using the term "host
> bridge".

Yes, absolutely.  My point is that what the HT spec means by "host bridge"
is not the same as what the PCI spec and Linux mean by "PCI host bridge".

Those are two completely separate functions, and I think Yinghai is
confusing them when he says "the host bridge is on the AMD CPU and
amd_bus.c uses its config to determine PCI root bus resources."

Bjorn
