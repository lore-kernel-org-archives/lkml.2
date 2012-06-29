Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab2F2Qii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 12:38:38 -0400
Received: from smtp-out-134.synserver.de ([212.40.185.134]:1038 "EHLO
	smtp-out-132.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755112Ab2F2Qih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 12:38:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 20396
Message-ID: <4FEDDAEF.5020609@metafoo.de>
Date: Fri, 29 Jun 2012 18:42:23 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lrg@ti.com" <lrg@ti.com>, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: snd_dmaengine: add common api for
 pcm_mmap
References: <1340866886-24432-1-git-send-email-ldewangan@nvidia.com> <4FEC3B70.5030902@metafoo.de> <s5hobo3zl79.wl%tiwai@suse.de> <20120628121816.GB21029@sirena.org.uk> <4FEC4E62.3020101@metafoo.de> <20120628122830.GJ28922@opensource.wolfsonmicro.com> <4FEC4FA9.20004@nvidia.com> <s5hlij7zja0.wl%tiwai@suse.de> <4FEC5642.9080908@nvidia.com> <s5hk3yrzhte.wl%tiwai@suse.de> <4FEC5DC7.5060600@nvidia.com> <s5hd34jzgs0.wl%tiwai@suse.de>
In-Reply-To: <s5hd34jzgs0.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 03:51 PM, Takashi Iwai wrote:
> At Thu, 28 Jun 2012 19:06:07 +0530,
> Laxman Dewangan wrote:
> [...]
> 
> But, still we need to be careful about this.  As mentioned, there is
> no flag to know the possibility of writecombine mmap beforehand.
> It'd be nice if we have either a compile-time or a run-time flag /
> function to check that.  Then the driver can also expose the mmap
> capability to user-space depending on the flag.
> 

If writecombine is not supported it will fallback to a "normal" mmap.
Here's an excerpt from the DMA mapping documentation:

DMA_ATTR_WRITE_COMBINE
----------------------

DMA_ATTR_WRITE_COMBINE specifies that writes to the mapping may be
buffered to improve performance.

Since it is optional for platforms to implement DMA_ATTR_WRITE_COMBINE,
those that do not will simply ignore the attribute and exhibit default
behavior.

- Lars
