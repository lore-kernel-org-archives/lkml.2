Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab2FRPpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:45:19 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:7557
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646Ab2FRPpR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:45:17 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zzbb2dI98dI9371I542M1432I4015Izz1202hzzz2fh95h668h839h944hd24hf0ah906i)
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] arm: zynq: Support GIC OF initialization
Date: Mon, 18 Jun 2012 09:45:10 -0600
In-Reply-To: <4FDF1ACC.2040208@monstr.eu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] arm: zynq: Support GIC OF initialization
Thread-Index: Ac1NS3HLku98WWtVRc2ow6MOhbu+2wAHb4xA
References: <1340017873-18170-1-git-send-email-monstr@monstr.eu> <4FDF19CF.8010303@gmail.com> <4FDF1ACC.2040208@monstr.eu>
From: John Linn <John.Linn@xilinx.com>
To: <monstr@monstr.eu>, Rob Herring <robherring2@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <arnd@arndb.de>
X-OriginalArrivalTime: 18 Jun 2012 15:45:11.0736 (UTC) FILETIME=[589F6B80:01CD4D69]
Message-ID: <4fb922e3-9501-4684-9b84-85aad0652dce@CH1EHSMHS021.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Michal Simek [mailto:monstr@monstr.eu]
> Sent: Monday, June 18, 2012 5:11 AM
> To: Rob Herring
> Cc: linux-kernel@vger.kernel.org;
linux-arm-kernel@lists.infradead.org;
> linux@arm.linux.org.uk; John Linn; arnd@arndb.de
> Subject: Re: [PATCH] arm: zynq: Support GIC OF initialization
> 
> On 06/18/2012 02:06 PM, Rob Herring wrote:
> > On 06/18/2012 06:11 AM, Michal Simek wrote:
> >> Zynq is OF driven platfrom which requires OF initialization.
> >>
> >> Signed-off-by: Michal Simek<monstr@monstr.eu>
> >> ---
> >>   arch/arm/mach-zynq/common.c |    7 ++++++-
> >>   1 files changed, 6 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-
> zynq/common.c
> >> index 17d68d6..7941544 100644
> >> --- a/arch/arm/mach-zynq/common.c
> >> +++ b/arch/arm/mach-zynq/common.c
> >> @@ -56,12 +56,17 @@ static void __init xilinx_init_machine(void)
> >>   	of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);
> >>   }
> >>
> >> +static const struct of_device_id zynq_dt_irq_match[] __initconst =
{
> >> +	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init },
> >> +	{ }
> >> +};
> >> +
> >>   /**
> >>    * xilinx_irq_init() - Interrupt controller initialization for
the
> GIC.
> >>    */
> >>   static void __init xilinx_irq_init(void)
> >>   {
> >> -	gic_init(0, 29, SCU_GIC_DIST_BASE, SCU_GIC_CPU_BASE);
> >
> > And delete the corresponding defines?
> 
> Agree, Will create v2.
> 
> BTW: Who is responsible for zynq? I think John Linn and who is
> maintainer I should ask for pulling.

In the past I've acked some patches and they were picked up by others
into the Soc tree I believe.

Thanks,
John

> 
> Thanks,
> Michal
> 
> 
> 
> 
> --
> Michal Simek, Ing. (M.Eng)
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel 2.6 Microblaze Linux -
> http://www.monstr.eu/fdt/
> Microblaze U-BOOT custodian


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


