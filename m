Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab1HPNvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:51:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64811 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab1HPNvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:51:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@nvidia.com>
Subject: Re: [RFC PATCH v2 06/13] docs/dt: Document nvidia,tegra20-pinmux binding
Date: Tue, 16 Aug 2011 15:51:31 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <1313440100-17131-1-git-send-email-swarren@nvidia.com> <1313440100-17131-7-git-send-email-swarren@nvidia.com>
In-Reply-To: <1313440100-17131-7-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161551.31389.arnd@arndb.de>
X-Provags-ID: V02:K0:pE8kmspZ0NWXM+Eub6naMyG/AvxYFmyhR49benmbrGc
 hyTXK2uZYO4A4YlL84EP2CtC1uOpHyb1VktxaQrW9nKEaZWN0t
 7N/15WUdJ3zC0K7qjNw4I0RRxuXqnSasJgbTfGUKTltUmUO/1l
 fPQ5/jCVTowitkdi+5z+R5jXqCdmmSJr5iohijblG3SEsl+1u4
 B46wyqozIhATHo51NIzjA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 August 2011, Stephen Warren wrote:
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  .../devicetree/bindings/pinmux/pinmux_nvidia.txt   |  294 ++++++++++++++++++++
>  1 files changed, 294 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
> 
> diff --git a/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt b/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
> new file mode 100644
> index 0000000..744e1b7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinmux/pinmux_nvidia.txt
> @@ -0,0 +1,294 @@
> +NVIDIA Tegra 2 pinmux controller
> +
> +Required properties:
> +- compatible : "nvidia,tegra20-pinmux"

Hmm, I think it would be much better in general if we could define
pinmux bindings in a way that is less specific to just one soc.
The contents of this file seem to be specific to even just one
version of the tegra chip, and might be completely different for
tegra30 and later, right?

Maybe Linus W can comment on this and say whether he thinks it can
be generalized enough to apply to other pinmux drivers.

> +Optional sub-nodes:
> +- nvidia,mux-groups : Mux group settings; see below.
> +- nvidia,drive-groups : Drive group settings; see below.
> +
> +nvidia,mux-groups sub-node:

These concepts seem general enough to me that they can apply to
other chips, and I would consequently drop the nvidia, prefix.

> +Each mux pin group is represented as a sub-node of the nvidia,mux-groups node.
> +The name of the sub-node should be the name of the mux pingroup. The following
> +names are valid:
> +
> +	ata
> +	atb
> +	atc
> +	atd
> +	ate
> +	cdev1
> +	cdev2
> ...

I noticed that each board you define has a complete list of these. Would
it be possible to move a generic list into a tegra20-pinmux.dtsi file and
just override the pins in the per-board .dts file that require some special
setup?


> +
> +optional subnode-properties:
> +- nvidia,pull-up : Boolean, apply Tegra's internal pull-up to the pin.
> +- nvidia,pull-down : Boolean, apply Tegra's internal pull-down to the pin.
> +- nvidia,tristate : Boolean, tristate the pin. Otherwise, drive it.
> +
> +If both nvidia,pull-up and nvidia,pull-down are specified, nvidia,pull-up
> +takes precedence.

These again seem generic enough to go into a general pinmux binding, without
the nvidia, prefix.

	Arnd
