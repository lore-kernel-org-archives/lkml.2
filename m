Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab2GCQ3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 12:29:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41427 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755336Ab2GCQ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 12:29:52 -0400
Message-ID: <4FF31DFC.8030708@wwwdotorg.org>
Date: Tue, 03 Jul 2012 10:29:48 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux@arm.linux.org.uk, ccross@android.com, olof@lixom.net,
        pdeschrijver@nvidia.com
Subject: Re: [PATCH v2 0/6] Port Tegra to generic clk framework
References: <1341313761-22118-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1341313761-22118-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 05:09 AM, Prashant Gaikwad wrote:
> This patch set ports Tegra clock code to generic clock framework.
> 
> Depends on
> [PATCH v3 0/9] Add clk_prepare/clk_unprepare series
> [PATCH] ARM: tegra: Remove second instance of uart clk
> [PATCH] dma: tegra: add clk_prepare/clk_unprepare
> [PATCH] ARM: tegra: dma: rename driver name for clock to "tegra-apbdma"
> 
> Tested on Ventana and Cardhu
> 
> v2:
>  - Rebased on Tegra's for-3.6/common-clk

OK, this applies to for-3.6/common-clk without issue now. However, there
are still runtime problems:

On Tegra20(Ventana), running Tegra's for-next branch with these patches
merged in, if I play audio, the sound is much too low a pitch; the I2S
clock must be being set too low. Also, if I play the same file twice,
once encoded as 48KHz once encoded as 44.1KHz, the pitch is different.

On Tegra20(Ventana), running next-20120703 plus a few local patches for
regulators plus these common clock patches, then I see the same
segfaults during boot that I mentioned before. It seems something in
linux-next not in Tegra's for-next branch is breaking the common clock
code for us.

Neither problem is seen on Cardhu with the same kernels.

Can you please investigate and fix these issues? Thanks.
