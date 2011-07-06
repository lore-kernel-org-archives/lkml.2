Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab1GFPTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:19:16 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:58446 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965Ab1GFPTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:19:14 -0400
X-Sasl-enc: sD78nvB49Y3lvdwU9lC7fYDaMSh8Xm4kdaPdnRzBpqTI 1309965553
Date: Wed, 6 Jul 2011 08:12:44 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20110706151244.GC7465@kroah.com>
References: <20110706150249.f2c67b43.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706150249.f2c67b43.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 03:02:49PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/staging/brcm80211/brcmfmac/dhd_sdio.c:599:24: error: field 'tasklet' has incomplete type
> drivers/staging/brcm80211/brcmfmac/dhd_sdio.c: In function 'brcmf_sdbrcm_bus_stop':
> drivers/staging/brcm80211/brcmfmac/dhd_sdio.c:3068:3: error: implicit declaration of function 'tasklet_kill'
> drivers/staging/brcm80211/brcmfmac/dhd_sdio.c: In function 'brcmf_sdbrcm_probe':
> drivers/staging/brcm80211/brcmfmac/dhd_sdio.c:5376:3: error: implicit declaration of function 'tasklet_init'
> drivers/staging/brcm80211/brcmfmac/dhd_sdio.c: In function 'brcmf_sdbrcm_probe_attach':
> drivers/staging/brcm80211/brcmfmac/dhd_sdio.c:5505:14: warning: cast to pointer from integer of different size
> drivers/staging/brcm80211/brcmfmac/dhd_sdio.c: In function 'brcmf_sdbrcm_chip_recognition':
> drivers/staging/brcm80211/brcmfmac/dhd_sdio.c:6056:19: warning: cast from pointer to integer of different size
> drivers/staging/brcm80211/brcmfmac/dhd_sdio.c: In function 'brcmf_sdbrcm_dpc_tasklet':
> drivers/staging/brcm80211/brcmfmac/dhd_sdio.c:6593:4: error: implicit declaration of function 'tasklet_schedule'
> 
> Caused by commit a6b7a407865a ("net: remove interrupt.h inclusion from netdevice.h") from the net tree interacting with commit  ("") from the atsging tree.
> 
> I have applied the following merge fixup patch for today (it should be
> applicable to the staging tree directly).

Ok, I'll go queue this up right now so this doesn't cause a problem in
the future.

greg k-h
