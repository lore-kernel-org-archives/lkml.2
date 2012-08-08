Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997Ab2HHTPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:15:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57532 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab2HHTOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:14:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 11/11] pm/drivers: fix use of SIMPLE_DEV_PM_OPS
Date: Wed, 8 Aug 2012 17:26:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de> <201208081622.29777.arnd@arndb.de> <s5hwr19fi6h.wl%tiwai@suse.de>
In-Reply-To: <s5hwr19fi6h.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201208081726.21878.arnd@arndb.de>
X-Provags-ID: V02:K0:sGpDBc4Dk1sBPsrslX3ZIy5nFSlvytaPeuJbD+NiD3e
 xypF+3C71sssrQa9CIIE1JJP37gD4xqAgQqch55KoVgvTVOtmp
 xIhV2yvaKDn+Ao4Due6f3oFTrvqt9grltpXxDk35LPm45AlcYF
 yvtccFgZMmHG1g9pF9Ikym3yTAzsWGXWhcv53rU5S7omrHy+l3
 TrEnnYhnwjQX/AZzCm+K1k7NBNL3BjLarV6WLZmZVhLqsyklsB
 DnIsYyUuxQIf78juqEe/DpDPs1KH34YUfENC+UVPrBImrvfXsR
 Zl22uRpGVtn43XDLLJtvjvLPGetk3mTXChiC8ei5F4SwyaCM1M
 86MD68ZqwlRuQjHeQTfg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2012, Takashi Iwai wrote:
> At Wed, 8 Aug 2012 16:22:29 +0000,
> Arnd Bergmann wrote:
> > > Laxman already posted a patch for this, which I'm hoping will make it
> > > into 3.6, through the I2C tree.
> > > 
> > > http://www.spinics.net/lists/linux-i2c/msg09359.html
> > 
> > Ok, dropping this one then.
> 
> I'm going to fix the similar errors in sound tree tomorrow, too.
> 

Ok. this leaves the omap-rng driver, and my patch comes down to the below.
Thanks!

	Arnd

8<----

>From d83e9e0e5c0e41a0ee2ba6293c8be21e54988f99 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Sat, 4 Aug 2012 07:11:34 +0000
Subject: [PATCH] omap-rng: fix use of SIMPLE_DEV_PM_OPS

omap_rng_suspend and omap_rng_resume are unused if CONFIG_PM is enabled
but CONFIG_PM_SLEEP is disabled. I found this while building all defconfig
files on ARM. It's not clear to me if this is the right solution, but
at least it makes the code consistent again.

Without this patch, building omap1_defconfig results in:

drivers/char/hw_random/omap-rng.c:165:12: warning: 'omap_rng_suspend' defined but not used [-Wunused-function]
drivers/char/hw_random/omap-rng.c:171:12: warning: 'omap_rng_resume' defined but not used [-Wunused-function]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index d706bd0e..4fbdceb 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -160,7 +160,7 @@ static int __exit omap_rng_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
 static int omap_rng_suspend(struct device *dev)
 {

