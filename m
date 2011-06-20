Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1FTTUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:20:46 -0400
Received: from relais.videotron.ca ([24.201.245.36]:15086 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1FTTUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:20:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 20 Jun 2011 15:20:44 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Stern <stern@rowland.harvard.edu>,
        gregkh@suse.de, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Rabin Vincent <rabin@rab.in>,
        Alexander Holler <holler@ahsoftware.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] USB: ehci: use packed,
 aligned(4) instead of removing the packed attribute
In-reply-to: <20110620190240.GJ26089@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.00.1106201515050.2142@xanadu.home>
References: <Pine.LNX.4.44L0.1106201240240.2113-100000@iolanthe.rowland.org>
 <201106201858.45624.arnd@arndb.de>
 <20110620190240.GJ26089@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Russell King - ARM Linux wrote:

> On Mon, Jun 20, 2011 at 06:58:45PM +0200, Arnd Bergmann wrote:
> > A recent change in gcc changed the default behaviour when compiling the
> > ehci driver on ARM, but the behaviour was already nondeterministic
> > because the definition of the readl/writel macros on ARM relies on
> > unspecified behaviour (cast to pointer with larger aligment).
> 
> It's unspecified behaviour period.  If you pass a pointer to readl/writel
> which is not word aligned, what you get back is anyones guess.

The pointer _is_ aligned.  The problem is that it comes from the address 
of a structure member, which structure is marked __packed.

Older GCC would see the cast to unsigned int applied to that pointer 
within the ARM's readl()/writel() implementation and ignore that the 
source of the address is marked __packed, which __packed implies an 
alignment of 1.  REcent GCC versions would honnor the alignment of 1 and 
perform the unsigned int * access using byte sized loads/stores.


Nicolas
