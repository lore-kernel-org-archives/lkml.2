Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab2FSRB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 13:01:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38670 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2FSRBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 13:01:24 -0400
Message-ID: <4FE0B061.6070302@wwwdotorg.org>
Date: Tue, 19 Jun 2012 11:01:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: ccross@android.com, olof@lixom.net, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: apbio access using dma for tegra20 only
References: <1340085974-9623-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340085974-9623-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 12:06 AM, Laxman Dewangan wrote:
> The Tegra20 HW issue with accessing APBIO registers (such
> as fuse registers) directly from the CPU concurrently with
> APB DMA accesses has been fixed in Tegra30 and later chips.
> 
> Access these registers directly from the CPU on Tegra30
> and later, and apply the workaround only for Tegra20.

> +void tegra_apb_io_init(void)
> +{
> +	/* Need to use dma only when it is Tegra20 based platform */
> +	if (of_machine_is_compatible("nvidia,tegra20")) {

That tests only works when the system is booted using device tree. Can
you change this to:

if (of_machine_is_compatible("nvidia,tegra20") ||
    !of_have_populated_dt()) {

... and make sure you get the expected result when booting using a board
file (e.g. Harmony). Thanks.

> +		apbio_read = tegra_apb_readl_using_dma;
> +		apbio_write = tegra_apb_writel_using_dma;
> +	} else {
> +		apbio_read = tegra_apb_readl_direct;
> +		apbio_write = tegra_apb_writel_direct;
> +	}
> +}
