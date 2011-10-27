Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab1J0IVt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 04:21:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:25402 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab1J0IVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 04:21:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="68446429"
Subject: Re: [PATCH v4] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <Barry.Song@csr.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        workgroup.linux@csr.com, Rongjun Ying <Rongjun.Ying@csr.com>,
        Jassi Brar <jaswinder.singh@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Barry Song <Baohua.Song@csr.com>
In-Reply-To: <1318907324-17046-1-git-send-email-Barry.Song@csr.com>
References: <1318907324-17046-1-git-send-email-Barry.Song@csr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Oct 2011 13:48:55 +0530
Message-ID: <1319703535.20054.30.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-17 at 20:08 -0700, Barry Song wrote:
> From: Rongjun Ying <Rongjun.Ying@csr.com>
> 
> Cc: Jassi Brar <jaswinder.singh@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>
> ---
>  -v4:
>  add error handler in probe;
>  free resource in remove;
>  add necessary comments in source codes;
>  fix the mismatch of license between file head and MODULE_LINCENSE;
>  define MACRO to replace magic number for xlen/dma_width boundary.
Barry,

You should _always_ run checkpatch before sending patches. It should
have 0 errors.

ERROR: trailing whitespace
#773: FILE: drivers/dma/sirf-dma.c:649:
+^I$


Also there are bunch of 80char warning, see if you can reduce/eliminate
them without sacrificing the code readability, and looking at them it
seems possible

Also, Please ensure you send patches which compile with ZERO warnings:
drivers/dma/sirf-dma.c: In function 'sirfsoc_dma_probe':
drivers/dma/sirf-dma.c:616: warning: assignment from incompatible pointer type
drivers/dma/sirf-dma.c:617: warning: assignment from incompatible pointer type
which comes from the fact that your prep_interleaved_dma does not have
last argument of flags.
On the second one you have not rebased to patch from Jassi which I
applied after converting direction stuff.

-- 
~Vinod

