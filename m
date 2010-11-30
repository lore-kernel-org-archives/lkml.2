Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689Ab0K3LwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 06:52:04 -0500
Received: from www.tglx.de ([62.245.132.106]:60585 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab0K3LwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 06:52:01 -0500
Message-ID: <4CF4E54D.5040403@linutronix.de>
Date: Tue, 30 Nov 2010 12:51:41 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Mitch Bradley <wmb@firmworks.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, sodaville@linutronix.de,
        x86@kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>	<1290706801-7323-4-git-send-email-bigeasy@linutronix.de>	<1290808645.32570.158.camel@pasglop>	<20101128160449.GC30784@www.tglx.de>	<1290984809.32570.208.camel@pasglop>	<20101129130720.7d060e1c@udp111988uds.am.freescale.net> <1291061128.32570.298.camel@pasglop> <4CF40DF4.9060204@firmworks.com>
In-Reply-To: <4CF40DF4.9060204@firmworks.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mitch Bradley wrote:
> Here are the properties for PCI and ISA on the OLPC XO-1.5
> platform (Via C7 x86 CPU with Via VX855 IO chip):
> 
> ok dev /pci/isa
> ok .properties
> reg                      00008800 00000000 00000000 00000000 00000000

> Note that the PCI node has no reg property.  On a system with multiple independent PCI buses at the top level, it would be necessary to distinguish them with reg properties reflecting their different addresses in the root address space.  PC-style architectures typically (always?) have a single top-level PCI domain, so I've never never needed to do that in x86 land.  It used to be pretty common on PPC "big iron".

My PCI node does not have a reg property but its child nodes.
In x86_of_pci_init() [0] I walk through the PCI child nodes, read the reg
property of each node  which gives me the devfn of the device. I pass this
pci_get_slot() and get the pci_dev struct where I attach the of_node. So
it can by used by the pci driver.

How do I create the PCI device <-> OF node mapping with this? I think your
isa node has this as well. 00008800 is the devfn and I simply forgot the
four blocks of zeros.

[0] http://lkml.org/lkml/2010/11/25/294

Sebastian
