Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab2KQI0O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 03:26:14 -0500
Received: from londo.lunn.ch ([80.238.139.98]:36629 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab2KQI0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 03:26:13 -0500
Date: Sat, 17 Nov 2012 09:26:02 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] clk: mvebu: armada 370/XP add clock gating control
 provider for DT
Message-ID: <20121117082602.GF24569@lunn.ch>
References: <1353014906-31566-6-git-send-email-andrew@lunn.ch>
 <1353088920-17458-1-git-send-email-gregory.clement@free-electrons.com>
 <1353088920-17458-2-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353088920-17458-2-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory

Nice work

On Fri, Nov 16, 2012 at 07:01:59PM +0100, Gregory CLEMENT wrote:
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  .../bindings/clock/mvebu-gated-clock.txt           |   43 ++++++++++++++
>  arch/arm/mach-mvebu/Kconfig                        |    1 +
>  drivers/clk/mvebu/clk-gating-ctrl.c                |   61 ++++++++++++++++++++
>  3 files changed, 105 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt b/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt
> index 7497cc0..9dbcdd9 100644
> --- a/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt
> +++ b/Documentation/devicetree/bindings/clock/mvebu-gated-clock.txt
> @@ -6,6 +6,49 @@ the clock ID in its "clocks" phandle cell. The clock ID is directly mapped to
>  the corresponding clock gating control bit in HW to ease manual clock lookup
>  in datasheet.
>  
> +The following is a list of provided IDs for Armada XP:

Should that the 370, not XP?

> +ID	Clock	Peripheral
> +-----------------------------------
> +0	Audio	AC97 Cntrl
> +1	pex0_en	PCIe 0 Clock out
> +2	pex1_en	PCIe 1 Clock out
> +3	ge1	Gigabit Ethernet 1
> +4	ge0	Gigabit Ethernet 0
> +5	pex0	PCIe Cntrl 0
> +9	pex1	PCIe Cntrl 1
> +15	sata0	SATA Host 0
> +17	sdio	SDHCI Host
> +25	tdm	Time Division Mplx
> +28	ddr	DDR Cntrl
> +30	sata1	SATA Host 0

Not many clocks there. USB? XOR? Crypto?

What is the ddr clock for? Does bad things happen if you turn it off?
Kirkwood has a similar clock, dunit, which i decided not to export,
since when you turn it off, the whole SoC locks up.

Thanks
      Andrew
