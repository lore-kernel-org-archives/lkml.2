Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab2J0N7V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 09:59:21 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:10036 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758323Ab2J0N7S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 09:59:18 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 8
X-BigFish: VPS8(zz9371I542M1dbaI1432I4015Izz1202h1d1ah1d2ahzz8275bhz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>,
        "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>
Subject: RE: [PATCH v4 4/5] ARM: annotate VMALLOC_END definition with _AC
Thread-Topic: [PATCH v4 4/5] ARM: annotate VMALLOC_END definition with _AC
Thread-Index: AQHNsiLT7JMbcxvGH06LPjyGiap5f5fNLQ2Q
Date: Sat, 27 Oct 2012 13:59:12 +0000
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200431.GE6713@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121024200431.GE6713@beefymiracle.amer.corp.natinst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.65]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <3c9e591c-a29f-446b-9256-bb23ff6d840d@TX2EHSMHS014.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> Sent: Wednesday, October 24, 2012 10:05 PM
> To: arm@kernel.org; Arnd Bergmann
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; John
> Linn; Nick Bowler; Michal Simek
> Subject: [PATCH v4 4/5] ARM: annotate VMALLOC_END definition with _AC
> 
> This makes the definition of VMALLOC_END suitable for use within assembly
> code.  This is necessary to allow the use of VMALLOC_END in defining where the
> early uart is mapped for use with DEBUG_LL.
> 
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/include/asm/pgtable.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
> index 08c1231..72904a2 100644
> --- a/arch/arm/include/asm/pgtable.h
> +++ b/arch/arm/include/asm/pgtable.h
> @@ -40,7 +40,7 @@
>   */
>  #define VMALLOC_OFFSET		(8*1024*1024)
>  #define VMALLOC_START		(((unsigned long)high_memory +
> VMALLOC_OFFSET) & ~(VMALLOC_OFFSET-1))
> -#define VMALLOC_END		0xff000000UL
> +#define VMALLOC_END		_AC(0xff000000,UL)

This shouldn't be the part of this series but should go to mainline through different tree.
Arnd, Olof: Can you take this patch to your arm-soc tree? 

I don't think it is a good workstyle to propose it to mainline through zynq soc tree.
What do you think?

Thanks,
Michal


