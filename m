Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0G1Ru1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:50:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58011 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965Ab0G1RuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:50:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] arm: msm: Add System MMU support.
Date: Wed, 28 Jul 2010 19:50:20 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: stepanm@codeaurora.org, linux-arm-msm@vger.kernel.org,
        dwalker@codeaurora.org, linux-kernel@vger.kernel.org
References: <1280270466-13503-1-git-send-email-stepanm@codeaurora.org> <201007281039.44883.arnd@arndb.de> <ea4bbdecc271f7fa5749d09645f38c0d.squirrel@www.codeaurora.org>
In-Reply-To: <ea4bbdecc271f7fa5749d09645f38c0d.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007281950.20847.arnd@arndb.de>
X-Provags-ID: V02:K0:HPUJaNUI6nNzLeOBLbeRUD02+LHcPIOjNLxPoSOoJtj
 B3RiOW49+ZeeYoieKRFjYlzfLx42pgnrM3q1N5uwF/zAtlbMkD
 OYA187HKHdzXNtscHVcknBeV7e/zpJtMyRR7xV3McoA9OUSgyn
 fMUbtL5vdlxMnMP+ex1+71oLiZmlCsFRvEHWXWUd0GjiXzb60v
 dPzM2ZKn+HZqCRglrXI2w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 July 2010, stepanm@codeaurora.org wrote:
> > On Wednesday 28 July 2010 00:41:06 Stepan Moskovchenko wrote:
> >> Add support for the System MMUs found on the 8x60 and 8x72
> >> families of Qualcomm chips. These SMMUs allow virtualization
> >> of the address space used by most of the multimedia cores
> >> on these chips.
> >
> > How is this different from an IOMMU?
> >
> > From a very brief look, it seems that you should be using the
> > existing dma-mapping APIs here instead of making up your own.
> >
> > 	Arnd
> 
> 
> These are just SMMU APIs, and the DMA-mapping API is one layer above this.
> 
> We have our own SMMU API for the MSM SoCs because we have muliple IOMMUs,
> each one having multiple contexts, or even having multiple instances of
> the same context. Our usage model is also quite a bit different from how
> the DMA APIs are set up. I believe only two IOMMU drivers actually make
> use of the DMA API (Intel and AMD) and the other ones (OMAP and other
> SoCs) have their own APIs for their specific use cases.

The DMA API is extremely flexible, it works just fine with all the
IOMMUs that I've seen so far. Please take a look at
include/asm-generic/dma-mapping-common.h and its users to see how
to use multiple IOMMUs depending on the device.

If the OMAP developers got this wrong, that's not your problem :-)

	Arnd
