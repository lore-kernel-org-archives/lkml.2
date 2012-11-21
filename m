Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab2KUSOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:14:33 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:36447 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab2KUSOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:14:32 -0500
Date: Wed, 21 Nov 2012 11:14:30 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] of: Have of_device_add call platform_device_add rather
 than device_add
Message-ID: <20121121181430.GE6406@obsidianresearch.com>
References: <20121121072448.GG19837@obsidianresearch.com>
 <20121121155104.726B83E0AE2@localhost>
 <20121121174453.GD6406@obsidianresearch.com>
 <CACxGe6u2Kfm+x5KsFzNPt7voyeD0x_4V6EO4add=tBwMKJ6VWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6u2Kfm+x5KsFzNPt7voyeD0x_4V6EO4add=tBwMKJ6VWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 06:07:46PM +0000, Grant Likely wrote:

> > Which is nesting the generic gpio driver under a larger region..
> 
> Try two sibling nodes with overlapping addresses. There are powerpc
> device trees doing that even though it isn't legal by the ofw and
> epapr specs.

Both my examples were using sibling nodes in the OF tree.

	pex@e0000000 {
		device_type = "pci";
		ranges = <0x02000000 0x00000000 0x00000000  0xe0000000  0x0 0x8000000>;
		bus-range = <0x0 0xFF>;
		chip@0 {
			ranges = <0x02000000 0x00000000 0x00000000  0x02000000 0x00000000 0x00000000  0x0 0x8000000>;
			chip_control@0 {
				compatible = "orc,chip,control";
				assigned-addresses = <0x02000000 0x0 0x0  0x0 4096>;
			};

			gpio3: chip_gpio@8 {
			        #gpio-cells = <2>;
				compatible = "linux,basic-mmio-gpio";
				gpio-controller;
				reg-names = "dat", "set", "dirin";
				assigned-addresses = <0x02000000 0x0 0x8  0x0 4>,
				                     <0x02000000 0x0 0xc  0x0 4>,
				                     <0x02000000 0x0 0x10  0x0 4>;
			};

Non-conformant yes, but it is the simplest way to get linux to bind
two drivers to the same memory space.

Jason
