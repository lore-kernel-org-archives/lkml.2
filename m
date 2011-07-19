Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1GSX6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 19:58:43 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:58023 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab1GSX6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 19:58:42 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
In-Reply-To: <1311115617-9697-2-git-send-email-achew@nvidia.com>
References: <1311115617-9697-1-git-send-email-achew@nvidia.com>
	<1311115617-9697-2-git-send-email-achew@nvidia.com>
Date: Tue, 19 Jul 2011 16:58:40 -0700
Message-ID: <CAOesGMjKpzG6epJN70TDyvynon81Hr7e8Swh+VG1F7Pd-U818A@mail.gmail.com>
Subject: Re: [PATCH 2/3] dt: tegra20: Add ehci host controller nodes.
From: Olof Johansson <olof@lixom.net>
To: achew@nvidia.com
Cc: grant.likely@secretlab.ca, swarren@nvidia.com, dwillemsen@nvidia.com,
        rklein@nvidia.com, mogantyv@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 19, 2011 at 3:46 PM,  <achew@nvidia.com> wrote:
> From: Andrew Chew <achew@nvidia.com>
>
> These values were derived from various headers in arch/arm/mach-tegra.
>
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra20.dtsi |   52 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 52 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
> index 83fedf3..a0353bb 100644
> --- a/arch/arm/boot/dts/tegra20.dtsi
> +++ b/arch/arm/boot/dts/tegra20.dtsi
> @@ -160,5 +160,57 @@
>                interrupts = < 63 >;
>                status = "disabled";
>        };
> +
> +       ehci@c5000000 {
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               compatible = "nvidia,tegra20-ehci";
> +               reg = <0xc5000000 0x4000>;
> +               interrupts = < 52 >;
> +               mode = < 1 >;
> +               power_down_on_bus_suspend;
> +               type = "utmi";
> +               hssync_start_delay = < 0 >;
> +               idle_wait_delay = < 17 >;
> +               elastic_limit = < 16 >;
> +               term_range_adj = < 6 >;
> +               xcvr_setup = < 15 >;
> +               xcvr_lsfslew = < 2 >;
> +               xcvr_lsrslew = < 2 >;
> +               status = "disabled";

These are mostly phy related settings, maybe do a phy subnode with
them? That way the usb_phy code can probe on that.


-Olof
