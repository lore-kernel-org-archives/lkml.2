Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab2J0NjJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 09:39:09 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:33760
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758292Ab2J0NjG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 09:39:06 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 9
X-BigFish: VPS9(zz9371I542M1432I4015Izz1202h1d1ah1d2ahzz8275bhz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>,
        "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>
Subject: RE: [PATCH v4 1/5] zynq: use GIC device tree bindings
Thread-Topic: [PATCH v4 1/5] zynq: use GIC device tree bindings
Thread-Index: AQHNsiKfdYDo+gun80qPdhWl+8WGNZfNK75w
Date: Sat, 27 Oct 2012 13:39:00 +0000
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200310.GB6713@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121024200310.GB6713@beefymiracle.amer.corp.natinst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.65]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <0d1c4cf8-70d8-4d12-bd77-393009d32b22@CH1EHSMHS001.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh,

> -----Original Message-----
> From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> Sent: Wednesday, October 24, 2012 10:03 PM
> To: arm@kernel.org; Arnd Bergmann
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; John
> Linn; Nick Bowler; Michal Simek
> Subject: [PATCH v4 1/5] zynq: use GIC device tree bindings
>
> The Zynq uses the cortex-a9-gic.  This eliminates the need to hardcode register
> addresses.
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Cc: John Linn <john.linn@xilinx.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/boot/dts/zynq-ep107.dts           | 8 +++++---
>  arch/arm/mach-zynq/common.c                | 7 ++++++-
>  arch/arm/mach-zynq/include/mach/zynq_soc.h | 2 --
>  3 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/boot/dts/zynq-ep107.dts b/arch/arm/boot/dts/zynq-
> ep107.dts
> index 37ca192..7bfff4a 100644
> --- a/arch/arm/boot/dts/zynq-ep107.dts
> +++ b/arch/arm/boot/dts/zynq-ep107.dts
> @@ -36,10 +36,12 @@
>               ranges;
>
>               intc: interrupt-controller@f8f01000 {
> +                     compatible = "arm,cortex-a9-gic";
> +                     #interrupt-cells = <3>;

If you change git to 3 cells format you should also change it for uart below.

Also will be the best to remove this dts entirely and replace it by existing
Platform.

Thanks,
Michal


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


