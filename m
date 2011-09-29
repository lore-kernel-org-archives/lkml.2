Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab1I2OWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:22:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:51634 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827Ab1I2OWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:22:49 -0400
Subject: Re: [PATCH 3/4] p4080ds-dts: Add two rapidio ports and message units support
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1317263341-19010-3-git-send-email-Gang.Liu@freescale.com>
Date: Thu, 29 Sep 2011 09:22:52 -0500
Cc: <linuxppc-dev@lists.ozlabs.org>, Jin Qing <b24347@freescale.com>,
        r58472@freescale.com, r61911@freescale.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        B11780@freescale.com
Content-Transfer-Encoding: 8BIT
Message-Id: <7DB8223D-7300-4578-B0C0-22B52AFF306D@kernel.crashing.org>
References: <1317263341-19010-1-git-send-email-Gang.Liu@freescale.com> <1317263341-19010-3-git-send-email-Gang.Liu@freescale.com>
To: Liu Gang <Gang.Liu@freescale.com>
X-Mailer: Apple Mail (2.1244.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 28, 2011, at 9:29 PM, Liu Gang wrote:

> Add two message units and number of ports according to the p4080 reference manual.

Explain why range size increased.

> 
> Signed-off-by: Li Yang <leoli@freescale.com>
> Signed-off-by: Jin Qing <b24347@freescale.com>
> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> ---
> arch/powerpc/boot/dts/p4080ds.dts  |    4 +-
> arch/powerpc/boot/dts/p4080si.dtsi |   37 +++++++++++++++++++++++++++--------
> 2 files changed, 30 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/powerpc/boot/dts/p4080ds.dts b/arch/powerpc/boot/dts/p4080ds.dts
> index eb11098..94a0cd4 100644
> --- a/arch/powerpc/boot/dts/p4080ds.dts
> +++ b/arch/powerpc/boot/dts/p4080ds.dts
> @@ -101,9 +101,9 @@
> 		};
> 	};
> 
> -	rapidio0: rapidio@ffe0c0000 {
> +	rapidio: rapidio@ffe0c0000 {
> 		reg = <0xf 0xfe0c0000 0 0x20000>;
> -		ranges = <0 0 0xc 0x20000000 0 0x01000000>;
> +		ranges = <0 0 0xc 0x20000000 0 0x20000000>;
> 	};
> 
> 	localbus@ffe124000 {
> diff --git a/arch/powerpc/boot/dts/p4080si.dtsi b/arch/powerpc/boot/dts/p4080si.dtsi
> index b71051f..816a629 100644
> --- a/arch/powerpc/boot/dts/p4080si.dtsi
> +++ b/arch/powerpc/boot/dts/p4080si.dtsi
> @@ -69,8 +69,9 @@
> 		rtic_c = &rtic_c;
> 		rtic_d = &rtic_d;
> 		sec_mon = &sec_mon;
> +		rmu = &rmu;
> 
> -		rio0 = &rapidio0;
> +		rio = &rapidio;
> 	};
> 
> 	cpus {
> @@ -555,20 +556,38 @@
> 			interrupt-parent = <&mpic>;
> 			interrupts = <93 2 0 0>;
> 		};
> +
> +		rmu: rmu@d3000 {
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			compatible = "fsl,rmu";
> +			reg = <0xd3000 0x200>;
> +
> +			message-unit@0 {
> +				reg = <0x0 0x100>;
> +				interrupts = <
> +						60 2 0 0  /* msg1_tx_irq */
> +						61 2 0 0>;/* msg1_rx_irq */
> +			};
> +			message-unit@1 {

message-unit@100

> +				reg = <0x100 0x100>;
> +				interrupts = <
> +						62 2 0 0  /* msg2_tx_irq */
> +						63 2 0 0>;/* msg2_rx_irq */
> +			};
> +		};
> 	};
> 
> -	rapidio0: rapidio@ffe0c0000 {
> +	rapidio: rapidio@ffe0c0000 {
> 		#address-cells = <2>;
> 		#size-cells = <2>;
> 		compatible = "fsl,rapidio-delta";

change to 'fsl,srio' per comments on binding patch.

> 		interrupts = <
> -			16 2 1 11 /* err_irq */
> -			56 2 0 0  /* bell_outb_irq */
> -			57 2 0 0  /* bell_inb_irq */
> -			60 2 0 0  /* msg1_tx_irq */
> -			61 2 0 0  /* msg1_rx_irq */
> -			62 2 0 0  /* msg2_tx_irq */
> -			63 2 0 0>; /* msg2_rx_irq */
> +				16 2 1 11 /* err_irq */
> +				56 2 0 0  /* bell_outb_irq */
> +				57 2 0 0>;/* bell_inb_irq */
> +		fsl,rio-num-ports = <2>;
> +		rmu-handle = <&rmu>;
> 	};
> 
> 	localbus@ffe124000 {
> -- 
> 1.7.3.1
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

