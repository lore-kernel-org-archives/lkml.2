Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669Ab2IELBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 07:01:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50443 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2IELBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 07:01:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 14/17] mfd: db8500-prcmu: use db8500 legacy services
Date: Wed, 5 Sep 2012 11:01:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Loic Pallardy <loic.pallardy-ext@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        "STEricsson_nomadik_linux" <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "LT ST-Ericsson" <st-ericsson@lists.linaro.org>
References: <1346839153-6465-1-git-send-email-loic.pallardy-ext@stericsson.com> <1346839153-6465-15-git-send-email-loic.pallardy-ext@stericsson.com>
In-Reply-To: <1346839153-6465-15-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209051101.02595.arnd@arndb.de>
X-Provags-ID: V02:K0:ag4c4Is79W9Ktecgwjz6SVSRdz3sKgFJpuYFGbnZzE7
 wpJpqVux7hOPFNqP84J9zn0DAfU7NEHAem/IW39U15wO/0vzVW
 ZfCn20vI+57ff8UH92ONa+LRaqeodcX8pdAqvDf4+amESo7/i5
 zL7uea4r7wdPK9vyb6e1JXbIn13L5qPUpu8KnJPWZI2RrheZdr
 2H4mrj1+9bKs78ZWXJHO6VZYC0swOtGdW18DqdWrDWRPGKitGp
 31bk/g0hlHnf9OhLv1HL+/XxiGbJNDp/UlV4n+xrppsCTHzEMK
 EwE0cK09T2oRFjHeYiq2g9Bs0SIEeIqWCIHY+uOvlDvKMZ7B8G
 ypn3rER6TzwJiULZ+cys=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 September 2012, Loic Pallardy wrote:
> This patch exposes db8500 legacy services which are
> now available to support new baseband.
> If different are needed, then services are overloaded.
> This allows to reduce duplicate code between projects.
> 
> Signed-off-by: Loic Pallardy <loic.pallardy@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/db8500-prcmu.c | 90 +++++++++++++++++++++++-----------------------
>  drivers/mfd/dbx500-prcmu.h | 71 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 116 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index 73c98e5..b39441f 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -327,12 +327,12 @@ int db8500_prcmu_set_display_clocks(void)
>         return 0;
>  }
>  
> -static u32 db8500_prcmu_read(unsigned int reg)
> +u32 db8500_prcmu_read(unsigned int reg)
>  {
>         return readl(_PRCMU_BASE + reg);
>  }

If these are common to both db8500 and dbx540, why not put the definitions
into the common dbx500.c file, rather than making dbx540 depend on the
db8500?

	Arnd
