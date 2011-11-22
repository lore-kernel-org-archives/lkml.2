Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab1KVVQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:16:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:56452 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab1KVVQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:16:55 -0500
Message-ID: <1321996600.14573.0.camel@pasglop>
Subject: Re: powerpc: dts: Fix canyonlands EMAC interrupt map
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Wed, 23 Nov 2011 08:16:40 +1100
In-Reply-To: <1321945877-22802-1-git-send-email-tinamdar@apm.com>
References: <1321945877-22802-1-git-send-email-tinamdar@apm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 12:41 +0530, Tanmay Inamdar wrote:
> Fixing interrupt mapping of EMAC for canyonlands

The previous stuff was odd .... but was it broken ?

It was done this way because the EMAC actually has more interrupts than
that which are routed to different UICs, and so doing a local map this
way allows to target multiple parents.

Cheers,
Ben.

> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
>  arch/powerpc/boot/dts/canyonlands.dts |   16 ++++++----------
>  1 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/powerpc/boot/dts/canyonlands.dts b/arch/powerpc/boot/dts/canyonlands.dts
> index 3dc75de..c76bbcd 100644
> --- a/arch/powerpc/boot/dts/canyonlands.dts
> +++ b/arch/powerpc/boot/dts/canyonlands.dts
> @@ -360,13 +360,11 @@
>  			EMAC0: ethernet@ef600e00 {
>  				device_type = "network";
>  				compatible = "ibm,emac-460ex", "ibm,emac4sync";
> -				interrupt-parent = <&EMAC0>;
> -				interrupts = <0x0 0x1>;
> -				#interrupt-cells = <1>;
> +				interrupt-parent = <&UIC2>;
>  				#address-cells = <0>;
>  				#size-cells = <0>;
> -				interrupt-map = </*Status*/ 0x0 &UIC2 0x10 0x4
> -						 /*Wake*/   0x1 &UIC2 0x14 0x4>;
> +				interrupts = </*Status*/0x10 0x4
> +						/*Wake*/0x14 0x4>;
>  				reg = <0xef600e00 0x000000c4>;
>  				local-mac-address = [000000000000]; /* Filled in by U-Boot */
>  				mal-device = <&MAL0>;
> @@ -390,13 +388,11 @@
>  			EMAC1: ethernet@ef600f00 {
>  				device_type = "network";
>  				compatible = "ibm,emac-460ex", "ibm,emac4sync";
> -				interrupt-parent = <&EMAC1>;
> -				interrupts = <0x0 0x1>;
> -				#interrupt-cells = <1>;
> +				interrupt-parent = <&UIC2>;
>  				#address-cells = <0>;
>  				#size-cells = <0>;
> -				interrupt-map = </*Status*/ 0x0 &UIC2 0x11 0x4
> -						 /*Wake*/   0x1 &UIC2 0x15 0x4>;
> +				interrupts = </*Status*/0x11 0x4
> +						/*Wake*/0x15 0x4>;
>  				reg = <0xef600f00 0x000000c4>;
>  				local-mac-address = [000000000000]; /* Filled in by U-Boot */
>  				mal-device = <&MAL0>;


