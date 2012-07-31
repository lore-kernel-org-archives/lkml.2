Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab2GaPWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:22:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40144 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755040Ab2GaPWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:22:04 -0400
Date: Tue, 31 Jul 2012 17:22:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: wei_wang@realsil.com.cn
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        cjb@laptop.org, arnd@arndb.de, aaron.lu@amd.come
Subject: Re: [PATCH 3/3] drivers/mmc/host: Add realtek sdmmc interface driver
Message-ID: <20120731152204.GA4563@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, wei_wang@realsil.com.cn,
	gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	cjb@laptop.org, arnd@arndb.de, aaron.lu@amd.come
References: <1343720576-22181-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1343720576-22181-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 03:42:56PM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Realtek SD/MMC card interface driver is used to access
> SD/MMC card, with the help of Realtek card reader adapter driver.

Yep,

it builds and boots fine with latest Linus tree.

When I put the card in, the kernel says:

[ 1162.197980] rtsx_core: MMC/SD card detected in socket 0:0
[ 1162.302571] rtsx_sdmmc: Realtek SDMMC controller found
[ 1163.202172] mmc0: new ultra high speed SDR50 SDHC card at address e624
[ 1163.237151] mmcblk0: mmc0:e624 SU16G 14.8 GiB
[ 1163.263627]  mmcblk0: p1

Then when I format the card it says:

[ 1284.457681] DMA: Out of SW-IOMMU space for 524288 bytes at device 0000:03:00.0
[ 1284.475972] DMA: Out of SW-IOMMU space for 368640 bytes at device 0000:03:00.0

which doesn't look too kosher to me. It comes from
swiotlb.c:swiotlb_full() and it says that in both cases map_single fails
mapping those 524Kb and 368K buffers.

It looks from here as if the driver is trying to map too big buffers
which the swiotlb can't handle? But I'm just stabbing in the dark here.

Accessing the card seems ok, I'll play with it for a while and keep you
posted.

Thanks.

-- 
Regards/Gruss,
Boris.
