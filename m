Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab0KJPBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:01:34 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:21268 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509Ab0KJPBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:01:33 -0500
X-Greylist: delayed 661 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Nov 2010 10:01:32 EST
X-RZG-AUTH: :IW0NeWC7b/q2i6W/qstXb1SBUuFnrGohavlCkce+Ub5QXMSOpHp3KRgmmO6F
X-RZG-CLASS-ID: mo05
From: Stefan Roese <sr@denx.de>
To: linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] ppc44x:PHY fixup for USB on canyonlands board
Date: Wed, 10 Nov 2010 15:50:15 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35.7-sr; KDE/4.5.1; i686; ; )
Cc: Rupjyoti Sarmah <rsarmah@amcc.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, rsarmah@apm.com
References: <201011101137.oAABbFoc015547@amcc.com>
In-Reply-To: <201011101137.oAABbFoc015547@amcc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201011101550.16093.sr@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 November 2010 12:37:15 Rupjyoti Sarmah wrote:
> This fix is a reset for USB PHY that requires some amount of time for power
> to be stable on Canyonlands.
> 
> Signed-off-by: Rupjyoti Sarmah <rsarmah@apm.com>
> ---
>  arch/powerpc/boot/dts/canyonlands.dts     |   11 ++++
>  arch/powerpc/platforms/44x/44x.h          |    5 ++
>  arch/powerpc/platforms/44x/Kconfig        |    7 ++
>  arch/powerpc/platforms/44x/Makefile       |    1 +
>  arch/powerpc/platforms/44x/ppc44x_fixup.c |   90
> +++++++++++++++++++++++++++++ 5 files changed, 114 insertions(+), 0
> deletions(-)
>  create mode 100644 arch/powerpc/platforms/44x/ppc44x_fixup.c
> 
> diff --git a/arch/powerpc/boot/dts/canyonlands.dts
> b/arch/powerpc/boot/dts/canyonlands.dts index a303703..d6e9ba2 100644
> --- a/arch/powerpc/boot/dts/canyonlands.dts
> +++ b/arch/powerpc/boot/dts/canyonlands.dts
> @@ -171,6 +171,11 @@
>  				      0x5 0x4>;     /* AHBDMA */
>  		};
> 
> +		CPLD: cpld@e1000000 {
> +			compatible = "apm, ppc460ex-bcsr";
> +			reg = <4 0xe1000000 0x9>;
> +		};

This node should be moved to the EBC section. It would look something like 
this then (note the reg property change here):

				CPLD: cpld@2,0 {
					...
					reg = <2 0x0 0x9>;
				};

Cheers,
Stefan
