Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063Ab1D3Ah2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:37:28 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51540 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761042Ab1D3Ah1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:37:27 -0400
Date: Fri, 29 Apr 2011 20:37:24 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Grant Likely <grant.likely@secretlab.ca>
cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 8/8] dt: add documentation of ARM dt boot interface
In-Reply-To: <20110429071608.12522.7764.stgit@ponder>
Message-ID: <alpine.LFD.2.00.1104292034450.24613@xanadu.home>
References: <20110429070135.12522.35745.stgit@ponder> <20110429071608.12522.7764.stgit@ponder>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011, Grant Likely wrote:

> diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
> index 50619a0..31d7e8a 100644
> --- a/Documentation/devicetree/booting-without-of.txt
> +++ b/Documentation/devicetree/booting-without-of.txt
[...]
> +1) Entry point for arch/arm
> +---------------------------
> +
> +   There is one single entry point to the kernel, at the start
> +   of the kernel image. That entry point supports two calling
> +   conventions.  A summary of the interface is described here.  A full
> +   description of the boot requirements is documented in
> +   Documentation/arm/Booting
> +
> +        a) ATAGS interface.  Minimal information is passed from firmware
> +        to the kernel with a tagged list of predefined parameters.
> +
> +                r0 : 0
> +
> +                r1 : Machine type number
> +
> +                r2 : Physical address of tagged list in system RAM
> +
> +        b) Entry with a flattened device-tree block.  Firmware loads the
> +        physical address of the flattened device tree block (dtb) into r2,
> +        r1 is not used, but it is considered good practise to use a valid
> +        machine number as described in Documentation/arm/Booting.
> +
> +                r0 : 0
> +
> +                r1 : Valid machine type number.  When using a device tree,
> +                a single machine type number will often be assigned to
> +                represent a class or family of SoCs.
> +
> +                r2 : physical pointer to the device-tree block
> +                (defined in chapter II) in RAM.  Device tree can be located
> +                anywhere in system RAM, but it should be aligned on a 64 bit
> +                boundary.
> +
> +   The kernel will differentiate between ATAGS and device tree booting by
> +   reading the memory pointed to by r1 and looking for either the flattened

s/r1/r2/


Nicolas
