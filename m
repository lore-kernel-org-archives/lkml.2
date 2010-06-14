Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0FNSka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 14:40:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43299 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab0FNSk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 14:40:29 -0400
Message-ID: <4C16777A.7060600@zytor.com>
Date: Mon, 14 Jun 2010 11:39:54 -0700
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
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH -v2] x86, pci: Handle fallout pci devices with peer root
 bus
References: <4BF40014.30303@ntlworld.com> <4C12C189.50201@oracle.com> <4C166B4F.90308@oracle.com> <201006141234.17912.bjorn.helgaas@hp.com>
In-Reply-To: <201006141234.17912.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 11:34 AM, Bjorn Helgaas wrote:
> 
> I made the point there that an HT chain may contain multiple HT/PCI
> host bridges, but you are stuck on the idea that "one HT chain == one
> PCI root bus."
> 
> I have not found the "one PCI host bridge per HT chain" requirement
> in the HT spec (if you find it, please point me to it).
> 
> If an HT chain may contain multiple HT/PCI host bridges, then it's
> obvious that the HT host bridge registers read by amd_bus.c don't
> contain enough information to correctly assign address space to the
> PCI root buses.
> 

A HT-to-PCI bridge appears as a PCI-to-PCI bridge (i.e. a Header Type 1
device), not as a host bridge (a Header Type 0 device).

That is at least the software model as defined.

	-hpa
