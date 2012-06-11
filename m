Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2FKLKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 07:10:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53807 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2FKLKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 07:10:48 -0400
Date: Mon, 11 Jun 2012 12:10:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com
Subject: Re: [PATCH 4/14] ARM: LPC32xx: Add DMA configuration to platform
	data
Message-ID: <20120611111029.GF11168@n2100.arm.linux.org.uk>
References: <1339412537-24485-1-git-send-email-stigge@antcom.de> <1339412537-24485-5-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339412537-24485-5-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 01:02:07PM +0200, Roland Stigge wrote:
> +static int pl08x_get_signal(struct pl08x_dma_chan *ch)
> +{
> +	return ch->cd->min_signal;
> +}
> +
> +static void pl08x_put_signal(struct pl08x_dma_chan *ch)
> +{
> +}

These change in my unstable/dma-pl08x branch, patches have been posted
already, but I don't deem them to be totally stable yet.  Waiting on
OMAP people to get their mainline kernel restored to a buildable state
so I can continue my DMA engine work.

> +
>  static struct pl08x_platform_data pl08x_pd = {
> +	.slave_channels = &pl08x_slave_channels[0],
> +	.num_slave_channels = ARRAY_SIZE(pl08x_slave_channels),
> +	.get_signal = &pl08x_get_signal,
> +	.put_signal = &pl08x_put_signal,

No need to take the address of a function here.
