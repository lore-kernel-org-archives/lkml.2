Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2CVRZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:25:10 -0400
Received: from mail.fuel7.com ([74.222.0.51]:56409 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab2CVRZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:25:08 -0400
X-Greylist: delayed 1505 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2012 13:25:08 EDT
Message-ID: <4F6B5A90.6030808@fuel7.com>
Date: Thu, 22 Mar 2012 12:00:00 -0500
From: Kyle Manna <kyle.manna@fuel7.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Stefano Babic <sbabic@denx.de>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>, Kevin Hilman <khilman@ti.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: OMAP: Add support for AM35xx UART4/ttyO3
References: <1318963661-27755-1-git-send-email-kyle.manna@fuel7.com> <4F6B4D4A.2040103@denx.de>
In-Reply-To: <4F6B4D4A.2040103@denx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 11:03 AM, Stefano Babic wrote:
> On 18/10/2011 20:47, Kyle Manna wrote:
>> Add hwmod support to enable access to UART4 of the AM35xx series of
>> chips.  The UART4 device referenced from the TRM will show up as ttyO3.
>>
>> This was tested on an AM3505.
>>
>> Signed-off-by: Kyle Manna<kyle.manna@fuel7.com>
>> ---
> Hi Kyle,
>
>>   arch/arm/mach-omap2/clock3xxx_data.c       |   11 ++++++
>>   arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |   52 ++++++++++++++++++++++++++++
>>   arch/arm/mach-omap2/prcm-common.h          |    2 +
>>   arch/arm/plat-omap/include/plat/irqs.h     |    2 +-
>>   arch/arm/plat-omap/include/plat/serial.h   |    1 +
>>   5 files changed, 67 insertions(+), 1 deletions(-)
> Can I gently ask you which pinmux setup do you use to test your patch ?
>
> I am trying to make uart4 working on a am3517 with mainline kernel
> (3.3+, your patch is merged). However, on my board the uart4 pins are
> shared with the camera, and not with SD, as maybe is more common. I set
> the pinmux to switch the pins (gpio_95 / gpio_96 / gpio_97 /gpio_98) to
> the uart4, and ttyO3 is registered and available, and thanks your patch
> both clocks iclk and fclk are active. However, I cannot see activity on
> the tx line if I try to send some characters.
>
> Maybe do you use the same pinmux and am I forgetting something else ?

My pin mux is configured in u-boot and is as follows:

     /* CCDC_FIELD: gpio_95, uP-TXD4 */ \
     MUX_VAL(CP(CCDC_FIELD),     (IDIS | PTD | DIS | M2)) \
     /* CCDC_HD: gpio_96, uP-RTS4# */ \
     MUX_VAL(CP(CCDC_HD),        (IDIS | PTD | DIS | M2)) \
     /* CCDC_VD: gpio_97, uP-CTS4# */ \
     MUX_VAL(CP(CCDC_VD),        (IEN  | PTD | EN  | M2)) \
     /* CCDC_WEN: gpio_98, uP-RXD4 */ \
     MUX_VAL(CP(CCDC_WEN),       (IEN  | PTD | DIS | M2)) \

I've just validated my AM3505 board does in fact toggle the TX line and 
writes valid data.  The running kernel is based on a linux-omap-3.1 and 
was the source for that patch.

Since it sounds like you have the same pinmux, perhaps something changed 
elsewhere in the kernel?  Have you tried validating that your hardware 
can toggle the pin as a GPIO first to eliminate any possibility of shorts?

- Kyle
