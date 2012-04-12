Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133Ab2DLHqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 03:46:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45632 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2DLHqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 03:46:53 -0400
Message-ID: <4F868866.6020206@monstr.eu>
Date: Thu, 12 Apr 2012 09:46:46 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120314 Thunderbird/10.0.3
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: microblaze-linux@lists.itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] microblaze: Do not select GENERIC_GPIO by default
References: <1333976744-9404-1-git-send-email-lars@metafoo.de> <CAHTX3dK4vzjtW+vvS5pokqrvmdbGYdj=TR3jwfkWW9xCk1QiXQ@mail.gmail.com> <4F842CB8.4070900@metafoo.de>
In-Reply-To: <4F842CB8.4070900@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 02:51 PM, Lars-Peter Clausen wrote:
> On 04/10/2012 02:37 PM, Michal Simek wrote:
>> Hi Lars,
>>
>> 2012/4/9 Lars-Peter Clausen<lars@metafoo.de<mailto:lars@metafoo.de>>
>>
>>      The microblaze architecture does not provide a native GPIO API
>>      implementation
>>      nor requires GPIOLIB, but still selects GENERIC_GPIO by default. As a
>>      result the
>>      following build error occurs, if GPIOLIB is not selected:
>>
>>             include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
>>             include/asm-generic/gpio.h:218: error: implicit declaration of
>>      function '__gpio_get_value'
>>             include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
>>             include/asm-generic/gpio.h:224: error: implicit declaration of
>>      function '__gpio_set_value'
>>
>>      This patch addresses the issue by not selecting GENERIC_GPIO by default.
>>      This
>>      causes the GPIO API to be stubbed out if no implementation is provided.
>>
>>      Signed-off-by: Lars-Peter Clausen<lars@metafoo.de<mailto:lars@metafoo.de>>
>>      Cc: stable@vger.kernel.org<mailto:stable@vger.kernel.org>
>>      ---
>>       arch/microblaze/Kconfig |    2 +-
>>       1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>
>> Sorry for taking so long. Can you please send me your .config file. I have
>> never seen that Microblaze has any problem with it.
>>
>
> Hi,
>
> basically any config which has CONFIG_GPIOLIB not set. I've attached my config.

Will add it to mainline.

Tested-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
