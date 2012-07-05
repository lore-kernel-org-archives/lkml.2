Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab2GEUmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:42:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40200 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2GEUmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:42:38 -0400
Message-ID: <4FF5FC39.3090402@wwwdotorg.org>
Date: Thu, 05 Jul 2012 14:42:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Marc Dietrich <marvin24@gmx.de>
CC: Wei Ni <wni@nvidia.com>, swarren@nvidia.com, olof@lixom.net,
        ccross@android.com, linux@arm.linux.org.uk,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ldewangan@nvidia.com, arnd@arndb.de,
        grant.likely@secretlab.ca, cjb@laptop.org
Subject: Re: [PATCH 5/5] ARM: tegra: enable wireless in defconfig
References: <1341394488-13169-1-git-send-email-wni@nvidia.com> <1341394488-13169-6-git-send-email-wni@nvidia.com> <4FF5F20F.2050005@wwwdotorg.org> <2114579.sqTp7XiW3H@ax5200p>
In-Reply-To: <2114579.sqTp7XiW3H@ax5200p>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 02:35 PM, Marc Dietrich wrote:
> On Thursday 05 July 2012 13:59:11 Stephen Warren wrote:
>> On 07/04/2012 03:34 AM, Wei Ni wrote:
>>> New options enabled:
>>> * WIRELESS: (dependency)
>>> * CFG80211: (dependency)
>>> * WLAN: (dependency)
>>> * BRCMFMAC: wlan driver, enable as module.
>>>
>>> diff --git a/arch/arm/configs/tegra_defconfig
>>> b/arch/arm/configs/tegra_defconfig
>>>
>>> +CONFIG_BRCMFMAC=m
>>
>> Why does this need to be a module? Everything else in tegra_defconfig is
>> built-in, and it'd be nice to be consistent here. Built-in makes
>> net-booting new kernels from U-Boot much easier, since there aren't any
>> modules to copy.
> 
> network drivers (especially wifi) are often modules because they need firmwares. 

So I certainly see that WiFi modules may need firmware.

But I don't see why that should imply they must be modules; they should
be able to defer their firmware loading until the firmware is available.

> I'm not sure if the kernel can compile them in every case. Our RT2x00 is an 
> example (which also needs a defconfig entry btw) but brcmfmac also needs it as 
> modinfo shows. Beside that, I don't think you want to netboot using wifi and u-
> boot because this needs a huge wireless framework which u-boot doesn't have.

I net-boot using a USB wired Ethernet adapter. The issue isn't that I
want to use wireless from U-Boot, but rather than it's easy to download
the zImage and .dtb using U-Boot since they're just copied to RAM, but
getting a bunch of modules into a filesystem on the target before
booting the kernel is more painful.
