Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1CUMkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:40:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56212 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab1CUMkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 08:40:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 0/5] make sdhci device drivers self registered
Date: Mon, 21 Mar 2011 13:39:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, sameo@linux.intel.com, grant.likely@secretlab.ca
References: <1300694823-8300-1-git-send-email-shawn.guo@linaro.org>
In-Reply-To: <1300694823-8300-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103211339.45305.arnd@arndb.de>
X-Provags-ID: V02:K0:kQ0HL717DMaLJ8WNWNE9lKIYmyQLDRVmaritr3moe6j
 9giY5W6tz/k60znRKzIuPF8gOZBiPYLwhvN2k1u4GE+MhgBGag
 CPHrMRQdjP9oPu1xuhT0nIqNx4Zia2xTXYVdQ4gFj3PXpHdKj+
 0sQHJQkxgJMjdTlvDupy+5QcnEak1R5b0Mc5z0hP+ykknWivtt
 SHv8U7xDuiLsvnLFlHyxg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 March 2011, Shawn Guo wrote:
> This patch set is to take sdhci device driver specific things out
> from sdhci-pltfm.c and make them self registered. Here are the
> differences it makes.
> 
>  * Get the sdhci device driver follow the Linux trend that driver
>    take the registration by its own
>  * sdhci-pltfm.c becomes significantly simpler and only has common
>    support functions there
>  * All sdhci device specific stuff are going back its own driver
>  * The dt and non-dt support share the same pair of .probe and
>    .remove hooks.
> 
> The first one patch adds common support function into sdhci-pltfm.c
> when changing sdhci-esdhc-imx driver, while the last one cleans up
> sdhci-pltfm.c when changing sdhci-tegra driver.
> 
> Only the patch of sdhci-esdhc-imx are tested on hardware, and others
> are just build tested.  And it is based on the tree below.
> 
>   git://git.secretlab.ca/git/linux-2.6.git devicetree/test
> 
> Comments are welcomed and appreciated.

Hi Shawn,

The changes you make look very nice, great work there!

I think the split of the series into five patches is not ideal
because you have more interdependencies than necessary, and it's
not clear that the series can be safely bisected, especially
with the way you do all the Kconfig/Makefile updates at the
end.

A nicer way to partition the series would be

1.   Add sdhci_pltfm_init helper
2-5. Convert each of the users, including the respective
     Kconfig/Makefile changes
6.   remove obsolete code from sdhci-pltfm.c

As I said, that's just a detail and the end result is the same.
If you don't get any other feedback and Chris is happy with the
changes, I wouldn't expect you to reshuffle all the patches just
for this.

Acked-by: Arnd Bergmann <arnd@arndb.de>
