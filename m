Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1DSUEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:04:53 -0400
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:52808 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab1DSUEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:04:52 -0400
Message-ID: <4DADEAD8.4090203@ece.ntua.gr>
Date: Tue, 19 Apr 2011 23:04:40 +0300
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: Bob Tracy <rct@gherkin.frus.com>
CC: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: [BUG] DMA_ERROR_CODE undefined in radeon_gart.c
References: <20110419194222.GA23953@gherkin.frus.com>
In-Reply-To: <20110419194222.GA23953@gherkin.frus.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (ulysses.noc.ntua.gr [147.102.222.230]); Tue, 19 Apr 2011 23:04:42 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/04/2011 10:42 μμ, Bob Tracy wrote:
> Attempted to build 2.6.39-rc4 on an Alpha and got the following error:
>
>   CC [M]  drivers/gpu/drm/radeon/radeon_gart.o
> drivers/gpu/drm/radeon/radeon_gart.c: In function 'radeon_gart_bind':
> drivers/gpu/drm/radeon/radeon_gart.c:186: error: 'DMA_ERROR_CODE' undeclared (first use in this function)
> drivers/gpu/drm/radeon/radeon_gart.c:186: error: (Each undeclared identifier is reported only once
> drivers/gpu/drm/radeon/radeon_gart.c:186: error: for each function it appears in.)
> make[4]: *** [drivers/gpu/drm/radeon/radeon_gart.o] Error 1
> make[3]: *** [drivers/gpu/drm/radeon] Error 2
> make[2]: *** [drivers/gpu/drm] Error 2
> make[1]: *** [drivers/gpu] Error 2
> make: *** [drivers] Error 2
>
> It appears that "DMA_ERROR_CODE" is currently defined for several
> architectures in "arch/*/include/asm/dma-mapping.h", but not for "alpha"
Similar issue in this discussion [1].
They solved it by replacing DMA_ERROR_CODE with dma_mapping_error().
Probably this can work here too.

-- 
Stratos Psomadakis
<psomas@ece.ntua.gr>


