Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab1BNOmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:42:00 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:20263
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753636Ab1BNOl5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:41:57 -0500
X-SpamScore: -23
X-BigFish: VPS-23(zz542N1432N98dN9371Pc8kzz1202hzzz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V2 1/4] ARM: Xilinx: Adding Xilinx board support
Date: Mon, 14 Feb 2011 07:41:47 -0700
In-Reply-To: <20110212121320.GH15616@n2100.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V2 1/4] ARM: Xilinx: Adding Xilinx board support
Thread-Index: AcvKrkhLFeYaed0AQpmisnvnMF37PwBptGFA
References: <1297270845-18802-1-git-send-email-john.linn@xilinx.com> <0e8b21c6-60ff-4f82-a8e6-5c2a0fe80372@VA3EHSMHS005.ehs.local> <20110212121320.GH15616@n2100.arm.linux.org.uk>
From: John Linn <John.Linn@xilinx.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <catalin.marinas@arm.com>, <glikely@secretlab.ca>
X-OriginalArrivalTime: 14 Feb 2011 14:41:51.0998 (UTC) FILETIME=[5163E9E0:01CBCC55]
X-RCIS-Action: ALLOW
Message-ID: <3c99c5b6-61cd-4049-9461-04c60fceaa7b@VA3EHSMHS028.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
> Sent: Saturday, February 12, 2011 5:13 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org; catalin.marinas@arm.com;
> glikely@secretlab.ca
> Subject: Re: [PATCH V2 1/4] ARM: Xilinx: Adding Xilinx board support
> 
> On Wed, Feb 09, 2011 at 10:00:42AM -0700, John Linn wrote:
> > +/* arch/arm/mach-xilinx/board_ep107.c
> > + *
> > + * This file contains code specific to the Xilinx EP107 board.
> > + *
> > + *  Copyright (C) 2011 Xilinx
> > + *
> > + * based on /arch/arm/mach-realview/core.c
> > + *
> > + *  Copyright (C) 1999 - 2003 ARM Limited
> > + *  Copyright (C) 2000 Deep Blue Solutions Ltd
> > + *
> > + * This program is free software; you can redistribute it and/or
modify
> > + * it under the terms of the GNU General Public License as
published by
> > + * the Free Software Foundation; either version 2 of the License,
or
> > + * (at your option) any later version.
> > + *
> > + * You should have received a copy of the GNU General Public
License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
02111-1307  USA
> 
> You probably don't want to include this paragraph - their address
keeps
> changing, so will require files to be constantly updated.

Makes sense. Easy to fix.

> 
> > + */
> > +
> > +#include <linux/platform_device.h>
> > +#include <asm/mach-types.h>
> > +#include <asm/mach/arch.h>
> > +#include <mach/xilinx_soc.h>
> > +#include <mach/irqs.h>
> > +#include <linux/clkdev.h>
> 
> Please group linux/ includes together, then asm/ includes, lastly
mach/
> includes.
> 
> > @@ -0,0 +1,113 @@
> > +/* arch/arm/mach-xilinx/common.c
> ...
> > +/**
> > + * system_init - System specific initialization, intended to be
called from
> > + *			board specific initialization.
> > + *
> > + **/
> > +void __init system_init(void)
> 
> Is there a better name for this - maybe prefixing it with xilinx_ ?

Sure, that's easy.

> 
> > +{
> > +#ifdef CONFIG_CACHE_L2X0
> > +	/*
> > +	 * 64KB way size, 8-way associativity, parity disabled
> > +	 */
> > +	l2x0_init(PL310_L2CC_BASE, 0x02060000, 0xF0F0FFFF);
> > +#endif
> > +}
> > +
> > +/**
> > + * irq_init - Interrupt controller initialization for the GIC.
> > + *
> > + **/
> > +void __init irq_init(void)
> 
> Ditto.

Same thing, easy.

> 
> > +/**
> > + * map_io - Create memory mappings needed for early I/O.
> > + *
> > + **/
> > +void __init map_io(void)
> 
> Ditto.

Yep.


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


