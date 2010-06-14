Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0FNUAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 16:00:24 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:16096 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab0FNUAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 16:00:22 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai.lu@oracle.com>
Subject: Re: [PATCH -v2] x86, pci: Handle fallout pci devices with peer root bus
Date: Mon, 14 Jun 2010 14:00:22 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Graham Ramsey <ramsey.graham@ntlworld.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       Joseph Chan <JosephChan@via.com.tw>, Jiri Slaby <jslaby@suse.cz>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <4BF40014.30303@ntlworld.com> <4C16777A.7060600@zytor.com> <4C167B30.2080307@oracle.com>
In-Reply-To: <4C167B30.2080307@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006141400.22653.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 14, 2010 12:55:44 pm Yinghai Lu wrote:
> On 06/14/2010 11:39 AM, H. Peter Anvin wrote:
> > On 06/14/2010 11:34 AM, Bjorn Helgaas wrote:
> >>
> >> I made the point there that an HT chain may contain multiple HT/PCI
> >> host bridges, but you are stuck on the idea that "one HT chain == one
> >> PCI root bus."
> 
> should be.
> 
> >> I have not found the "one PCI host bridge per HT chain" requirement
> >> in the HT spec (if you find it, please point me to it).
> 
> according to my experience with LinuxBIOS. AMD chipset, nvidia and serverworks (broadcom)

I'm afraid I'm still not convinced.

> >> If an HT chain may contain multiple HT/PCI host bridges, then it's
> >> obvious that the HT host bridge registers read by amd_bus.c don't
> >> contain enough information to correctly assign address space to the
> >> PCI root buses.
> 
> the host bridges is on AMD CPUs, 

Don't confuse the HT host bridge with the PCI host bridge.  The HT I/O spec
is quite clear that it uses "host bridge" to refer to the HT host bridge,
i.e., the interface between CPUs and a HyperTransport link.

I agree that the *HT host bridge* is indeed on the AMD CPU.  But that is
certainly not the same as the PCI host bridge that bridges between an HT
link and a PCI bus.

See sections 4.9.4 (HT host bridge) and 7.4 (HT/PCI host bridge), for
example.

Bjorn
