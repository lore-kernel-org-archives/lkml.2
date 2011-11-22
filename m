Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab1KVLaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:30:52 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40433 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1KVLau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:30:50 -0500
MIME-Version: 1.0
In-Reply-To: <1321945877-22802-1-git-send-email-tinamdar@apm.com>
References: <1321945877-22802-1-git-send-email-tinamdar@apm.com>
Date: Tue, 22 Nov 2011 06:30:49 -0500
Message-ID: <CA+5PVA7BD9jNoV9LrXjk2+UPBW8MSTPkwpYPFj2y-CNkXCrAhA@mail.gmail.com>
Subject: Re: powerpc: dts: Fix canyonlands EMAC interrupt map
From: Josh Boyer <jwboyer@gmail.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 2:11 AM, Tanmay Inamdar <tinamdar@apm.com> wrote:
> Fixing interrupt mapping of EMAC for canyonlands
>
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>

As far as I can tell, your changes aren't really changing anything
just making it a bit clearer, correct?  If so, do you mind if I change
the commit log to "clear up" instead of fix?

josh

> ---
>  arch/powerpc/boot/dts/canyonlands.dts |   16 ++++++----------
>  1 files changed, 6 insertions(+), 10 deletions(-)
>
> diff --git a/arch/powerpc/boot/dts/canyonlands.dts b/arch/powerpc/boot/dts/canyonlands.dts
> index 3dc75de..c76bbcd 100644
> --- a/arch/powerpc/boot/dts/canyonlands.dts
> +++ b/arch/powerpc/boot/dts/canyonlands.dts
> @@ -360,13 +360,11 @@
>                        EMAC0: ethernet@ef600e00 {
>                                device_type = "network";
>                                compatible = "ibm,emac-460ex", "ibm,emac4sync";
> -                               interrupt-parent = <&EMAC0>;
> -                               interrupts = <0x0 0x1>;
> -                               #interrupt-cells = <1>;
> +                               interrupt-parent = <&UIC2>;
>                                #address-cells = <0>;
>                                #size-cells = <0>;
> -                               interrupt-map = </*Status*/ 0x0 &UIC2 0x10 0x4
> -                                                /*Wake*/   0x1 &UIC2 0x14 0x4>;
> +                               interrupts = </*Status*/0x10 0x4
> +                                               /*Wake*/0x14 0x4>;
>                                reg = <0xef600e00 0x000000c4>;
>                                local-mac-address = [000000000000]; /* Filled in by U-Boot */
>                                mal-device = <&MAL0>;
> @@ -390,13 +388,11 @@
>                        EMAC1: ethernet@ef600f00 {
>                                device_type = "network";
>                                compatible = "ibm,emac-460ex", "ibm,emac4sync";
> -                               interrupt-parent = <&EMAC1>;
> -                               interrupts = <0x0 0x1>;
> -                               #interrupt-cells = <1>;
> +                               interrupt-parent = <&UIC2>;
>                                #address-cells = <0>;
>                                #size-cells = <0>;
> -                               interrupt-map = </*Status*/ 0x0 &UIC2 0x11 0x4
> -                                                /*Wake*/   0x1 &UIC2 0x15 0x4>;
> +                               interrupts = </*Status*/0x11 0x4
> +                                               /*Wake*/0x15 0x4>;
>                                reg = <0xef600f00 0x000000c4>;
>                                local-mac-address = [000000000000]; /* Filled in by U-Boot */
>                                mal-device = <&MAL0>;
> --
> 1.6.1.rc3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
