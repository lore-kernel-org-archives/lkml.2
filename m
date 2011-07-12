Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1GLKDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:03:25 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51870 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab1GLKDY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:03:24 -0400
MIME-Version: 1.0
In-Reply-To: <CABb+yY1HJOR+QzmM4-ju4cs+8keoyUbMv+SpVoM6BW=DCMzmQQ@mail.gmail.com>
References: <1310310203-12288-1-git-send-email-sundaram@ti.com>
	<CABb+yY1HJOR+QzmM4-ju4cs+8keoyUbMv+SpVoM6BW=DCMzmQQ@mail.gmail.com>
Date: Tue, 12 Jul 2011 12:03:22 +0200
Message-ID: <CACRpkdbLg0+_2kpi4NizFj0fDWb6QPtkcKirKgoH+83vGD0O0A@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride configuration
From: Linus Walleij <linus.walleij@linaro.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Sundaram Raju <sundaram@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        dan.j.williams@intel.com, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 6:17 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:

> 1) Striding, in one form or other, is supported by other DMACs as well.
>   The number will only increase in future.
>   Are we to add  <VENDOR>_DMA_STRIDE_CONFIG for each case ?

If we are sure about this and striding will work in a similar way on all
then let's have the enum named DMA_STRIDE_CONFIG and move the
passed-in struct to <linux/dmaengine.h) then?

Would that be:

struct dma_stride_config {
    u32 read_bytes;
    u32 skip_bytes;
};

Or something more complex?

> 2) As Dan noted, client drivers are going to have ifdef hackery in
> order to be common
>  to other SoCs.

Don't think so, why? This is a runtime config entirely, and I just illustrated
in mail to Dan how that can be handled by falling back to a sglist I believe?

We can *maybe* even put the fallback code into dmaengine, so that an
emulated sglist in place for the DMAengine is done automatically of the
DMA controller does not support striding.

> 3) TI may not have just one DMAC IP used in all the SoCs. So if you want
>  vendor specific defines anyway, please atleast also add DMAC version to it.
>  Something like
>>        DMA_SLAVE_CONFIG,
>>        FSLDMA_EXTERNAL_START,
>> +       TI_DMA_v1_STRIDE_CONFIG,

Yep unless we make it generic DMA_STRIDE_CONFIG simply, this makes
a lot of sense.

Linus Walleij
