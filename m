Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab1FTT3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:29:47 -0400
Received: from relais.videotron.ca ([24.201.245.36]:45913 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1FTT3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:29:45 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 20 Jun 2011 15:29:44 -0400 (EDT)
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
Message-id: <alpine.LFD.2.00.1106201521250.2142@xanadu.home>
References: <Pine.LNX.4.44L0.1106201240240.2113-100000@iolanthe.rowland.org>
 <201106201858.45624.arnd@arndb.de>
 <20110620190240.GJ26089@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jun 2011, Russell King - ARM Linux wrote:

> On Mon, Jun 20, 2011 at 06:58:45PM +0200, Arnd Bergmann wrote:
> > We are also going to change the ARM implementation to always do 32 bit
> > accesses in readl/writel, but the patch that went into the ehci driver
> > was correct nonetheless.
> 
> Not without someone doing a comparitively large amount of work to analyze
> the effect of any change there and make sure that it doesn't have a
> negative impact to drivers.

This thread prompted me to investigate a bit.  I have vague memories for 
the reasons why we decided to use plain C for the IO accessors as the 
inline assembly version didn't produce nearly the same code quality.  It 
seems that GCC improved quite a bit there, and from a quick 
investigation, it looks like comparable code is being generated with the 
C and the inline asm versions with a recent enough GCC.  This is 
certainly the case with the version causing issues with packed 
structures.


Nicolas
