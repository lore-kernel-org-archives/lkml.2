Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2J1Vm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 17:42:58 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35607 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2J1Vm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 17:42:56 -0400
Message-ID: <508DA6DC.4070601@gmail.com>
Date: Sun, 28 Oct 2012 22:42:52 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Li Li <li.li@canonical.com>,
        Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/3] clk: mvebu: add armada-370-xp specific clocks
References: <1350303499-30868-1-git-send-email-gregory.clement@free-electrons.com> <1350303499-30868-2-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1350303499-30868-2-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 02:18 PM, Gregory CLEMENT wrote:
> Add Armada 370/XP specific clocks: core clocks and CPU clocks.
>
> The CPU clocks are only for Armada XP for the SMP mode.
>
> ...
> +static struct core_clk_fn armada_370_clk_fn = {
> +	.get_tclk_freq = armada_370_get_tclk_freq,
> +	.get_pck_freq = armada_370_get_pck_freq,
> +	.get_fab_freq_opt = armada_370_get_fab_freq_opt,
> +};
> +
> +static struct core_clk_fn armada_xp_clk_fn = {
> +	.get_tclk_freq = armada_xp_get_tclk_freq,
> +	.get_pck_freq = armada_xp_get_pck_freq,
> +	.get_fab_freq_opt = armada_xp_get_fab_freq_opt,
> +};
> +
> +static const __initconst struct of_device_id clk_match[] = {
> +	{
> +	 .compatible = "marvell,armada-370-core-clockctrl",
> +	 .data =&armada_370_clk_fn,
> +	 },
> +
> +	{
> +	 .compatible = "marvell,armada-xp-core-clockctrl",
> +	 .data =&armada_xp_clk_fn,
> +	 },
> +	{
> +	 /* sentinel */
> +	 }
> +};

Gregory,

armada_370_clk_fn and armada_xp_clk_fn cause section mismatches
as they are referenced within __initconst.

You should either rename them to armada_xp_clk_ops or annotate them
with the appropriate attribute.

Sebastian
