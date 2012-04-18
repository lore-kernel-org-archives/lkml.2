Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2DRIhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:37:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54879 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2DRIh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:37:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v2 7/8] ARM: LPC32xx: DTS files for device tree conversion
Date: Wed, 18 Apr 2012 08:36:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        thierry.reding@avionic-design.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
References: <1334682507-15055-1-git-send-email-stigge@antcom.de> <1334682507-15055-8-git-send-email-stigge@antcom.de>
In-Reply-To: <1334682507-15055-8-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204180836.53268.arnd@arndb.de>
X-Provags-ID: V02:K0:g0f7ekUbzj/ifXmWqAxnHkK66xEIn2Ri9rBrbLY9r0R
 CP9uL/gVNUnc9DYEXY1thwzcpOpll6atvDDPXaG/CnU5lmtPY1
 1qKjM7sv7p43M1TxKxihsWZzpBz8NXc52F5LnfrkD7Nx7VmavO
 xGqBqb6Icvd8Duk4Fyg2NGwb5sLsVZMIdjjUIUA6aPNR8ezDrX
 e5p1mDq2j+ph4A7sx/X9vlxSlhGPU+zz44ZI3hQkK2PBCRjrLQ
 QoD3uVuCo9uYF4en52Z9okwrU3k8QI386Li/4bf80H0Fdll9c2
 Y3tGykmvUJdXAceKj1L5qfAUjatkjnDTAxDK81JNze19dU0qOw
 PlX+MnvMwst6SBZ70GH0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2012, Roland Stigge wrote:
> +	ahb {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		compatible = "simple-bus";
> +		ranges = <0x20000000 0x20000000 0x30000000>;
> +
> +		slc: flash@20020000 {
> +			compatible = "nxp,nand-slc";
> +			reg = <0x20020000 0x1000>;
> +			status = "disable";
> +		};
> +
> +		mlc: flash@200B0000 {
> +			compatible = "nxp,nand-mlc";
> +			reg = <0x200B0000 0x1000>;
> +			status = "disable";
> +		};

You have the flash chips in here, which seem right, but I would expect
to see the phy3250 file pick this up again and define partitions in
it, at least if there is a well-defined partition layout for that
board.

> +
> +	chosen {
> +		bootargs = "console=ttyS0,115200n81 root=/dev/ram0";
> +	};

I think in general it's better not to list a command line like this,
it should instead get set by the boot loader or using ARM_ATAG_DTB_COMPAT.

	Arnd
