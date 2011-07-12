Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1GLLUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 07:20:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38134 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab1GLLUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 07:20:39 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbLg0+_2kpi4NizFj0fDWb6QPtkcKirKgoH+83vGD0O0A@mail.gmail.com>
References: <1310310203-12288-1-git-send-email-sundaram@ti.com>
	<CABb+yY1HJOR+QzmM4-ju4cs+8keoyUbMv+SpVoM6BW=DCMzmQQ@mail.gmail.com>
	<CACRpkdbLg0+_2kpi4NizFj0fDWb6QPtkcKirKgoH+83vGD0O0A@mail.gmail.com>
Date: Tue, 12 Jul 2011 16:50:37 +0530
Message-ID: <CABb+yY1RqHJ6jsMB2RqPNnBLff-bzhwaXG1U-hCD8CpME+a3aA@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: add dma_ctrl_cmd to pass buffer stride configuration
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sundaram Raju <sundaram@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, linux@arm.linux.org.uk,
        dan.j.williams@intel.com, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 3:33 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Jul 12, 2011 at 6:17 AM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
>
>> 1) Striding, in one form or other, is supported by other DMACs as well.
>>   The number will only increase in future.
>>   Are we to add  <VENDOR>_DMA_STRIDE_CONFIG for each case ?
>
> If we are sure about this and striding will work in a similar way on all
> then let's have the enum named DMA_STRIDE_CONFIG and move the
> passed-in struct to <linux/dmaengine.h) then?
>
> Would that be:
>
> struct dma_stride_config {
>    u32 read_bytes;
>    u32 skip_bytes;
> };
>
> Or something more complex?
Well, I am not sure if striding needs any special treatment at all.
Why not have client drivers prepare and submit sg-list.
Let the DMAC drivers interpret/parse the sg-list and program it
as strides if the h/w supports it.
If anything, we should make preparation and submission of sg-list
as efficient as possible.

>> 2) As Dan noted, client drivers are going to have ifdef hackery in
>> order to be common
>>  to other SoCs.
>
> Don't think so, why? This is a runtime config entirely, and I just illustrated
> in mail to Dan how that can be handled by falling back to a sglist I believe?
Runtime decision isn't neat either.
What if a client driver is common to 'N' SoCs each with different DMACs ?
We would need a switch construct !
