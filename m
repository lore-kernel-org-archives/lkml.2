Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1DRH3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 03:29:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60266 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab1DRH3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 03:29:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2 cache
Date: Mon, 18 Apr 2011 09:29:33 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, Ramesh Gupta <grgupta@ti.com>,
        Hari Kanigeri <h-kanigeri2@ti.com>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com> <20110414223036.GA7335@n2100.arm.linux.org.uk>
In-Reply-To: <20110414223036.GA7335@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104180929.33569.arnd@arndb.de>
X-Provags-ID: V02:K0:AYEf+koebSFW0cF6H4y/ojmCa197WaS1xCDFaKecj5T
 9TZ/u5q7U56jYf0IsKg3Q5/AU26s5QsA/ZyFVkoAdX0zkwjau7
 02BkTIWb5ZZdOtxgWiCzrw2dlwpwc2+IEf9FFwJHsNlojDVzoa
 eQW5jF0q2Zi2Eti6vunTx3ABwPCGQTxtJhrb4NDdU+wir/6RCN
 MFOIzI3GGBLkeEk1Ivsdg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 April 2011, Russell King - ARM Linux wrote:
> On Thu, Apr 14, 2011 at 04:52:48PM -0500, Fernando Guzman Lugo wrote:
> > From: Ramesh Gupta <grgupta@ti.com>
> > 
> > This patch is to flush the iommu page table entries from L1 and L2
> > caches using dma_map_single. This also simplifies the implementation
> > by removing the functions  flush_iopgd_range/flush_iopte_range.
> 
> No.  This usage is just wrong.  If you're going to use the DMA API then
> unmap it, otherwise the DMA API debugging will go awol.


It's also completely upside-down: The iommu support should provide interfaces
using the dma-mapping API, not use that API to provide a machine specific
version of the generic interface.

As far as I can tell, nothing actually uses these drivers, maybe we should just
remove them before we get any code in the mainline kernel that depends on it.

	Arnd
