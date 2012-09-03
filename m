Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab2ICIte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:49:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51845 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080Ab2ICItc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:49:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=bvzm1O4FAtsr3YpLg-w1Rp7RT-9ZuJBgVZRxVHnQO_g@mail.gmail.com>
References: <50439D44.3080100@yahoo.es>
	<CAHp75VcQOeVeKPg8z9u+fd8ia4QAyrq6UQn-D7Q-yO9+pLS6LQ@mail.gmail.com>
	<CAKohpo=bvzm1O4FAtsr3YpLg-w1Rp7RT-9ZuJBgVZRxVHnQO_g@mail.gmail.com>
Date: Mon, 3 Sep 2012 11:49:30 +0300
Message-ID: <CAHp75VcpzomoWb3+xOk=++BkUh5_cuXQTu8ZuDByjfX+pYmNCA@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] dw_dmac: max_mem_width limits value for
 SRC/DST_TR_WID register
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Hein Tibosch <hein_tibosch@yahoo.es>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 3, 2012 at 11:30 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 3 September 2012 13:55, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
>>> #define DW_MEM_WIDTH_64         0       /* default */
>>> #define DW_MEM_WIDTH_32         1       /* e.g. for avr32 */
>> There are 4 options: 32, 64, 128, and 256 bits. I would prefer to see
>> the value in conjunction with
>> real value in the register, namely 2 for 32, 3 - 64, 4 - 128, 5 - 256.
>
> Which register are you talking about? This configuration is outside of DMAC
> controller and i am not sure if dw DMAC controller can do 128 or 256
> bit transfers.
SRC_WIDTH & DST_WIDTH in CTLx. The field are 3 bit long. Acceptable
values from 0 to 5.
2 corresponds to 32 bit transfers.

>>> @@ -58,6 +58,9 @@ struct dw_dma_slave {
>>>         u32                     cfg_lo;
>>>         u8                      src_master;
>>>         u8                      dst_master;
>>> +#define        DW_MEM_WIDTH_64         0
>>> +#define        DW_MEM_WIDTH_32         1       /* e.g. for avr32 */
>>> +       u8                      max_mem_width;
>> Might be I missed something, but why is it slave configuration?
>> I think the controller (actually channel) structure is more suitable
>> to keep that field inside.
>
> @Hein: Even i missed it. How will you do memcpy transfers as we don't have
> this structure there. Probably you need to move this to DMA controller platform
> data filed.
>
> viresh



-- 
With Best Regards,
Andy Shevchenko
