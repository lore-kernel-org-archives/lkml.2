Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab2KVTYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:24:15 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56495 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab2KVTYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:24:13 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: Have of_device_add call platform_device_add rather than device_add
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
In-Reply-To: <20121121181430.GE6406@obsidianresearch.com>
References: <20121121072448.GG19837@obsidianresearch.com> <20121121155104.726B83E0AE2@localhost> <20121121174453.GD6406@obsidianresearch.com> <CACxGe6u2Kfm+x5KsFzNPt7voyeD0x_4V6EO4add=tBwMKJ6VWQ@mail.gmail.com> <20121121181430.GE6406@obsidianresearch.com>
Date: Thu, 22 Nov 2012 15:36:21 +0000
Message-Id: <20121122153621.452CA3E129E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2012 11:14:30 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> On Wed, Nov 21, 2012 at 06:07:46PM +0000, Grant Likely wrote:
> 
> > > Which is nesting the generic gpio driver under a larger region..
> > 
> > Try two sibling nodes with overlapping addresses. There are powerpc
> > device trees doing that even though it isn't legal by the ofw and
> > epapr specs.
> 
> Both my examples were using sibling nodes in the OF tree.
> 
> 	pex@e0000000 {
> 		device_type = "pci";
> 		ranges = <0x02000000 0x00000000 0x00000000  0xe0000000  0x0 0x8000000>;
> 		bus-range = <0x0 0xFF>;
> 		chip@0 {
> 			ranges = <0x02000000 0x00000000 0x00000000  0x02000000 0x00000000 0x00000000  0x0 0x8000000>;
> 			chip_control@0 {
> 				compatible = "orc,chip,control";
> 				assigned-addresses = <0x02000000 0x0 0x0  0x0 4096>;
> 			};
> 
> 			gpio3: chip_gpio@8 {
> 			        #gpio-cells = <2>;
> 				compatible = "linux,basic-mmio-gpio";
> 				gpio-controller;
> 				reg-names = "dat", "set", "dirin";
> 				assigned-addresses = <0x02000000 0x0 0x8  0x0 4>,
> 				                     <0x02000000 0x0 0xc  0x0 4>,
> 				                     <0x02000000 0x0 0x10  0x0 4>;
> 			};
> 
> Non-conformant yes, but it is the simplest way to get linux to bind
> two drivers to the same memory space.

Hmm... I've not tried it with assigned-address. I tried with two sibling
platform devices using just the 'reg' property. That the kernel will
complain about. For powerpc-only, the patch I posted allows the device
to get registered anyway even though the range incorrectly overlaps.

g.
