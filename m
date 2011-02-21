Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab1BUASa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 19:18:30 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:5326 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754725Ab1BUAS3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 19:18:29 -0500
X-SpamScore: -30
X-BigFish: VPS-30(zz542N1432N98dN1fa4L9371Pzz1202hzz8275bhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V4 3/4] ARM: Xilinx: base header files and assembly macros
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Sun, 20 Feb 2011 17:18:14 -0700
In-Reply-To: <201102202237.47327.arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V4 3/4] ARM: Xilinx: base header files and assembly macros
Thread-Index: AcvRRnNE5YbD7uX5TLa/xrV3qIiKEQAFe/7g
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com> <1298052881-14591-3-git-send-email-john.linn@xilinx.com> <42efee69-aca1-446b-a997-f0063e113877@VA3EHSMHS009.ehs.local> <201102202237.47327.arnd@arndb.de>
From: John Linn <John.Linn@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>
X-OriginalArrivalTime: 21 Feb 2011 00:18:13.0730 (UTC) FILETIME=[D42FF420:01CBD15C]
X-RCIS-Action: ALLOW
Message-ID: <c170bbf2-ac0a-4c55-b2a7-0215c7a79635@VA3EHSMHS032.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Sunday, February 20, 2011 2:38 PM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org;
> linux@arm.linux.org.uk; catalin.marinas@arm.com; glikely@secretlab.ca;
> jamie@jamieiles.com
> Subject: Re: [PATCH V4 3/4] ARM: Xilinx: base header files and
assembly
> macros
> 
> On Friday 18 February 2011, John Linn wrote:
> > +
> > +/* IO address mapping macros, nothing special at this time but
> required */
> > +
> > +#ifdef __ASSEMBLER__
> > +#define IOMEM(x)               (x)
> > +#else
> > +#define IOMEM(x)               ((void __force __iomem *)(x))
> > +#endif
> > +
> > +#define __io(a)                        __typesafe_io(a)
> > +#define __mem_pci(a)           (a)
> 
> Are you planning to support PCI or PCMCIA? If so, the __io definition
> will have to
> change so it points to the PIO register window.

No immediate plans for PCI or PCMCIA.  Makes sense.

> 
> > diff --git a/arch/arm/mach-xilinx/include/mach/timex.h
> b/arch/arm/mach-xilinx/include/mach/timex.h
> > new file mode 100644
> > index 0000000..4ebc0a6
> > --- /dev/null
> > +++ b/arch/arm/mach-xilinx/include/mach/timex.h
> > +#ifndef __MACH_TIMEX_H__
> > +#define __MACH_TIMEX_H__
> > +
> > +#define PERIPHERAL_CLOCK_RATE  2500000
> > +
> > +#define CLOCK_TICK_RATE        (PERIPHERAL_CLOCK_RATE / 32)
> > +
> > +#endif
> 
> I thought we were at the point where CLOCK_TICK_RATE is no longer
used.

The timer code in these patches is using it, no other comments on it so
far.

> Did the patches not make it in yet?
> 

I haven't heard they made them in yet, just waiting and hoping for an
ack.

> The rest looks fine to me.

Great, appreciate the review and your time.

-- John

> 
> 	Arnd


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


