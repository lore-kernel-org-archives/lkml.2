Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2GET7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:59:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58434 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2GET7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:59:15 -0400
Message-ID: <4FF5F20F.2050005@wwwdotorg.org>
Date: Thu, 05 Jul 2012 13:59:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: swarren@nvidia.com, olof@lixom.net, ccross@android.com,
        linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        ldewangan@nvidia.com, arnd@arndb.de, grant.likely@secretlab.ca,
        cjb@laptop.org
Subject: Re: [PATCH 5/5] ARM: tegra: enable wireless in defconfig
References: <1341394488-13169-1-git-send-email-wni@nvidia.com> <1341394488-13169-6-git-send-email-wni@nvidia.com>
In-Reply-To: <1341394488-13169-6-git-send-email-wni@nvidia.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 03:34 AM, Wei Ni wrote:
> New options enabled:
> * WIRELESS: (dependency)
> * CFG80211: (dependency)
> * WLAN: (dependency)
> * BRCMFMAC: wlan driver, enable as module.

> diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig

> +CONFIG_BRCMFMAC=m

Why does this need to be a module? Everything else in tegra_defconfig is
built-in, and it'd be nice to be consistent here. Built-in makes
net-booting new kernels from U-Boot much easier, since there aren't any
modules to copy.

When I built a kernel with this series, I observed the following:

CONFIG_BRCMFMAC=m

* Neither Cardhu nor Ventana auto-load the module. When the module is
manually modprobe'd, I still see no wireless device being created.

CONFIG_BRCMFMAC=y

* Cardhu: No wireless device created. I do see some kernel spew such as
"mmc1: queuing unknown CIS tuple 0x80" which I believe is the SDIO
device being probed, but I don't see any Linux device being created.

* Ventana: There's a 60s hang during boot, I believe related to the BRCM
driver, since the hang doesn't occur without the series.

In summary, this series doesn't work at all for me. Can you please
explain what you tested and how? Are there any differences between the
various Cardhu and Ventana board revisions and/or the 2 different
wireless cards possible on Cardhu that'd explain this?

Thanks.
