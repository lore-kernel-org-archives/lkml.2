Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2ICI2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:28:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59574 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab2ICI2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:28:43 -0400
MIME-Version: 1.0
In-Reply-To: <50439D65.4010708@yahoo.es>
References: <50439D65.4010708@yahoo.es>
Date: Mon, 3 Sep 2012 11:28:42 +0300
Message-ID: <CAHp75VdLkUZraD5AR5zT32Fs+Eh9vC+DT1BE3Ebd_QASAX+jEQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] avr32: at32ap700x: set DMA slave properties for
 MCI dw_dmac
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        viresh kumar <viresh.kumar@linaro.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        spear-devel <spear-devel@list.st.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 8:54 PM, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -1355,6 +1355,10 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
>                                 | DWC_CFGH_DST_PER(1));
>         slave->sdata.cfg_lo &= ~(DWC_CFGL_HS_DST_POL
>                                 | DWC_CFGL_HS_SRC_POL);
> +       /* Setup DMA controller: let source be master */
> +       slave->sdata.src_master = 1;
I don't know the details, but do you want to set up dst_master as well?

> +       /* Limit maximum transfer width to 32-bit */
> +       slave->sdata.max_mem_width = DW_MEM_WIDTH_32;
It's under question regarding to my comments on previous patch.

-- 
With Best Regards,
Andy Shevchenko
