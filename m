Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab2GFDUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 23:20:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9408 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab2GFDUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 23:20:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 05 Jul 2012 20:20:07 -0700
Subject: Re: [PATCH 5/5] ARM: tegra: enable wireless in defconfig
From: Wei Ni <wni@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Marc Dietrich <marvin24@gmx.de>, Stephen Warren <swarren@nvidia.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "ccross@android.com" <ccross@android.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "cjb@laptop.org" <cjb@laptop.org>
In-Reply-To: <4FF5FC39.3090402@wwwdotorg.org>
References: <1341394488-13169-1-git-send-email-wni@nvidia.com>
	 <1341394488-13169-6-git-send-email-wni@nvidia.com>
	 <4FF5F20F.2050005@wwwdotorg.org> <2114579.sqTp7XiW3H@ax5200p>
	 <4FF5FC39.3090402@wwwdotorg.org>
Date: Fri, 6 Jul 2012 11:19:44 +0800
Message-ID: <1341544784.3484.44.camel@tegra-chromium-2>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 04:42 +0800, Stephen Warren wrote:
> On 07/05/2012 02:35 PM, Marc Dietrich wrote:
> > On Thursday 05 July 2012 13:59:11 Stephen Warren wrote:
> >> On 07/04/2012 03:34 AM, Wei Ni wrote:
> >>> New options enabled:
> >>> * WIRELESS: (dependency)
> >>> * CFG80211: (dependency)
> >>> * WLAN: (dependency)
> >>> * BRCMFMAC: wlan driver, enable as module.
> >>>
> >>> diff --git a/arch/arm/configs/tegra_defconfig
> >>> b/arch/arm/configs/tegra_defconfig
> >>>
> >>> +CONFIG_BRCMFMAC=m
> >>
> >> Why does this need to be a module? Everything else in tegra_defconfig is
> >> built-in, and it'd be nice to be consistent here. Built-in makes
> >> net-booting new kernels from U-Boot much easier, since there aren't any
> >> modules to copy.
> > 
> > network drivers (especially wifi) are often modules because they need firmwares. 
> 
> So I certainly see that WiFi modules may need firmware.
> 
> But I don't see why that should imply they must be modules; they should
> be able to defer their firmware loading until the firmware is available.

The wifi driver will try to load the firmware form the filesystem in its
initialization. In some board, the filesystem is on the SD/MMC card, and
if the wifi card is initialized before that SD/MMC card, it can't read
the filesystem and can't get the firmware, since the SD/MMC card doesn't
be initialized yet. then the wifi driver's initialization will be
failed.
So the wifi driver are often built as modules.

> 
> > I'm not sure if the kernel can compile them in every case. Our RT2x00 is an 
> > example (which also needs a defconfig entry btw) but brcmfmac also needs it as 
> > modinfo shows. Beside that, I don't think you want to netboot using wifi and u-
> > boot because this needs a huge wireless framework which u-boot doesn't have.
> 
> I net-boot using a USB wired Ethernet adapter. The issue isn't that I
> want to use wireless from U-Boot, but rather than it's easy to download
> the zImage and .dtb using U-Boot since they're just copied to RAM, but
> getting a bunch of modules into a filesystem on the target before
> booting the kernel is more painful.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


