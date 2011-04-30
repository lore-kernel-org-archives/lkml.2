Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab1D3GaJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 02:30:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49695 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1D3GaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 02:30:07 -0400
Date: Sat, 30 Apr 2011 00:30:05 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 8/8] dt: add documentation of ARM dt boot interface
Message-ID: <20110430063005.GB3103@ponder.secretlab.ca>
References: <20110429070135.12522.35745.stgit@ponder>
 <20110429071608.12522.7764.stgit@ponder>
 <alpine.LFD.2.00.1104292034450.24613@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1104292034450.24613@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 08:37:24PM -0400, Nicolas Pitre wrote:
> On Fri, 29 Apr 2011, Grant Likely wrote:
> 
> > diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
> > index 50619a0..31d7e8a 100644
> > --- a/Documentation/devicetree/booting-without-of.txt
> > +++ b/Documentation/devicetree/booting-without-of.txt
> [...]
> > +1) Entry point for arch/arm
> > +---------------------------
> > +
> > +   There is one single entry point to the kernel, at the start
> > +   of the kernel image. That entry point supports two calling
> > +   conventions.  A summary of the interface is described here.  A full
> > +   description of the boot requirements is documented in
> > +   Documentation/arm/Booting
> > +
> > +        a) ATAGS interface.  Minimal information is passed from firmware
> > +        to the kernel with a tagged list of predefined parameters.
> > +
> > +                r0 : 0
> > +
> > +                r1 : Machine type number
> > +
> > +                r2 : Physical address of tagged list in system RAM
> > +
> > +        b) Entry with a flattened device-tree block.  Firmware loads the
> > +        physical address of the flattened device tree block (dtb) into r2,
> > +        r1 is not used, but it is considered good practise to use a valid
> > +        machine number as described in Documentation/arm/Booting.
> > +
> > +                r0 : 0
> > +
> > +                r1 : Valid machine type number.  When using a device tree,
> > +                a single machine type number will often be assigned to
> > +                represent a class or family of SoCs.
> > +
> > +                r2 : physical pointer to the device-tree block
> > +                (defined in chapter II) in RAM.  Device tree can be located
> > +                anywhere in system RAM, but it should be aligned on a 64 bit
> > +                boundary.
> > +
> > +   The kernel will differentiate between ATAGS and device tree booting by
> > +   reading the memory pointed to by r1 and looking for either the flattened
> 
> s/r1/r2/

Good catch. Thanks.

g.

