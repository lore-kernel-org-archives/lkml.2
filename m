Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab1BUOhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:37:05 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:59278
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754619Ab1BUOhC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:37:02 -0500
X-SpamScore: -30
X-BigFish: VPS-30(zz542N1432N98dN4015L9371Pzz1202hzz8275bhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V4 3/4] ARM: Xilinx: base header files and assembly macros
Date: Mon, 21 Feb 2011 07:36:56 -0700
In-Reply-To: <201102210936.42098.arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V4 3/4] ARM: Xilinx: base header files and assembly macros
Thread-Index: AcvRooF8NqsvHGEFSzKazeLwU/RfNgAMBe+w
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com> <201102202237.47327.arnd@arndb.de> <c170bbf2-ac0a-4c55-b2a7-0215c7a79635@VA3EHSMHS032.ehs.local> <201102210936.42098.arnd@arndb.de>
From: John Linn <John.Linn@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>
X-OriginalArrivalTime: 21 Feb 2011 14:36:56.0696 (UTC) FILETIME=[CA44A780:01CBD1D4]
X-RCIS-Action: ALLOW
Message-ID: <c3cdf33d-2163-4417-bc64-7637f5c211e0@VA3EHSMHS021.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Monday, February 21, 2011 1:37 AM
> To: John Linn
> Cc: linux-arm-kernel@lists.infradead.org;
linux-kernel@vger.kernel.org;
> linux@arm.linux.org.uk; catalin.marinas@arm.com; glikely@secretlab.ca;
> jamie@jamieiles.com
> Subject: Re: [PATCH V4 3/4] ARM: Xilinx: base header files and
assembly
> macros
> 
> On Monday 21 February 2011, John Linn wrote:
> > > > diff --git a/arch/arm/mach-xilinx/include/mach/timex.h
> > > b/arch/arm/mach-xilinx/include/mach/timex.h
> > > > new file mode 100644
> > > > index 0000000..4ebc0a6
> > > > --- /dev/null
> > > > +++ b/arch/arm/mach-xilinx/include/mach/timex.h
> > > > +#ifndef __MACH_TIMEX_H__
> > > > +#define __MACH_TIMEX_H__
> > > > +
> > > > +#define PERIPHERAL_CLOCK_RATE  2500000
> > > > +
> > > > +#define CLOCK_TICK_RATE        (PERIPHERAL_CLOCK_RATE / 32)
> > > > +
> > > > +#endif
> > >
> > > I thought we were at the point where CLOCK_TICK_RATE is no longer
> > used.
> >
> > The timer code in these patches is using it, no other comments on it
> so
> > far.
> >
> > > Did the patches not make it in yet?
> > >
> >
> > I haven't heard they made them in yet, just waiting and hoping for
an
> > ack.
> 
> I meant the patches removing CLOCK_TICK_RATE from common code, not
your
> patches, sorry for being vague.

Ahh... understand.  No problem, wishful thinking on my part :)

> 
> It would be better if you could avoid introducing new uses of
> CLOCK_TICK_RATE, because that will have to be removed before we can
> move to a real multi-platform kernel. For instance, you can put
> PERIPHERAL_CLOCK_RATE in a hardware specific header and put a bogus
> definition for CLOCK_TICK_RATE into timex.h

Hi Arnd,

I can remove the use of it from my timer code, but I still see
CLOCK_TICK_RATE 
being used in linux/jiffies.h.

I tried removing it and got build errors.  Am I missing something there?

Thanks,
John

> 
> 	Arnd


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


