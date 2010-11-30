Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab0K3Cuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 21:50:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:44481 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab0K3Cut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 21:50:49 -0500
Subject: Re: [PATCH 03/11] x86/dtb: Add a device tree for CE4100
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mitch Bradley <wmb@firmworks.com>, Scott Wood <scottwood@freescale.com>,
        sodaville@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101129234735.4ce3a933@lxorguk.ukuu.org.uk>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
	 <1290706801-7323-4-git-send-email-bigeasy@linutronix.de>
	 <1290808645.32570.158.camel@pasglop> <20101128160449.GC30784@www.tglx.de>
	 <1290984809.32570.208.camel@pasglop>
	 <20101129130720.7d060e1c@udp111988uds.am.freescale.net>
	 <1291061128.32570.298.camel@pasglop> <4CF40DF4.9060204@firmworks.com>
	 <1291063470.32570.312.camel@pasglop>
	 <20101129234735.4ce3a933@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 13:50:11 +1100
Message-ID: <1291085411.32570.320.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 23:47 +0000, Alan Cox wrote:
> 
> That may not be wise. Your real bus heirarchy may not be architecturally
> defined on some systems so you can't incorporate it into code, nor is it
> necessarily a heirarchy - eg some of the Geodes. 

Ok, so I'd suggest doing something like:

 - pci is below the corresponding atom node
 - isa is a child of pci

The later is a useful representation even if it doesn't correspond to
reality. From an address representation perspective, ISA can be
considered somewhat as a substractive decoding child of PCI (again even
if that's not 100% true), which simplifies the representation in the
device-tree a bit, and allows to still have things like VGA devices on
the PCI segment that decode IO ports in the ISA range.

Cheers,
Ben.


