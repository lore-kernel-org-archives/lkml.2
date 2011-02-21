Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1BUPGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 10:06:06 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:49537
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751608Ab1BUPGF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 10:06:05 -0500
X-SpamScore: -30
X-BigFish: VPS-30(zz542N1432N98dN4015L9371Pzz1202hzz8275dhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH V4 3/4] ARM: Xilinx: base header files and assembly macros
Date: Mon, 21 Feb 2011 08:04:38 -0700
In-Reply-To: <201102211548.36296.arnd@arndb.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V4 3/4] ARM: Xilinx: base header files and assembly macros
Thread-Index: AcvR1ptMe06Zsr34TamLqiu8JvUIPwAAR7Tw
References: <1298052881-14591-1-git-send-email-john.linn@xilinx.com><201102210936.42098.arnd@arndb.de><c3cdf33d-2163-4417-bc64-7637f5c211e0@VA3EHSMHS021.ehs.local> <201102211548.36296.arnd@arndb.de>
From: John Linn <John.Linn@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <jamie@jamieiles.com>, <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 21 Feb 2011 15:04:39.0883 (UTC) FILETIME=[A99AD9B0:01CBD1D8]
X-RCIS-Action: ALLOW
Message-ID: <6c1f68a4-997a-4a8d-882e-5840e8bdf7af@VA3EHSMHS004.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-
> kernel-bounces@lists.infradead.org] On Behalf Of Arnd Bergmann
> Sent: Monday, February 21, 2011 7:49 AM
> To: John Linn
> Cc: linux@arm.linux.org.uk; catalin.marinas@arm.com;
> glikely@secretlab.ca; linux-kernel@vger.kernel.org;
> jamie@jamieiles.com; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH V4 3/4] ARM: Xilinx: base header files and
assembly
> macros
> 
> On Monday 21 February 2011, John Linn wrote:
> > > It would be better if you could avoid introducing new uses of
> > > CLOCK_TICK_RATE, because that will have to be removed before we
can
> > > move to a real multi-platform kernel. For instance, you can put
> > > PERIPHERAL_CLOCK_RATE in a hardware specific header and put a
bogus
> > > definition for CLOCK_TICK_RATE into timex.h
> >
> > Hi Arnd,
> >
> > I can remove the use of it from my timer code, but I still see
> > CLOCK_TICK_RATE
> > being used in linux/jiffies.h.
> >
> > I tried removing it and got build errors.  Am I missing something
> there?
> >
> 
> You still need to have some definition for CLOCK_TICK_RATE to make
> the jiffies code compile, but the actual value no longer matters.

I see. Now that I re-read your last response I get that from it.

> 
> Traditionally, this was the i386-style PIT timer frequency of 11.93
MHz
> for some things and the actual timer frequency for other things.
> The timer code tries to correct the jiffies value based on difference
> between the intended HZ frequency (100, 250 or 1000) and the actual
> on (something very close to that, but not exact).
> 
> You can e.g. set it to (100 * HZ) to make something up that won't
> hurt in that calculation.
> 

Gotcha. I now understand to stay away from using CLOCK_TICK_RATE.

Sounds like it's worth a comment in mach/timex.h that says it's not 
really used as it seems a bit misleading for others.

Thanks,
John

> 	Arnd
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


