Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1HVAbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 20:31:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43804 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab1HVAbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 20:31:15 -0400
Message-ID: <4E51A34C.6060207@gmail.com>
Date: Mon, 22 Aug 2011 10:31:08 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: axel.lin@gmail.com
CC: linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-fbdev@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] video: ep93xx-fb: add missing include of linux/module.h
References: <1313937545.13671.5.camel@phoenix> <4E5197B8.8020608@gmail.com> <4E519AC7.3030001@gmail.com> <CAF+7xWkezyMrnt-_0EVtNWtAB2v7pceATB8HEbdC8oqOY0camw@mail.gmail.com>
In-Reply-To: <CAF+7xWkezyMrnt-_0EVtNWtAB2v7pceATB8HEbdC8oqOY0camw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/11 10:06, Axel Lin wrote:
> 2011/8/22 Ryan Mallon<rmallon@gmail.com>:
>> On 22/08/11 09:41, Ryan Mallon wrote:
>>> On 22/08/11 00:39, Axel Lin wrote:
>>>> ep93xx-fb.c uses interfaces from linux/module.h,
>>>> so it should include that file.  This patch fixes below build errors.
>>> What actually changed to make these files broken? Did some other header
>>> previously include module.h for us? How many other drivers are broken?
>>>
>>> Anyway, the change is okay.
>>>
>>> Acked-by: Ryan Mallon<rmallon@gmail.com>
>> Actually, having a second look at this it does not look right.
>>
>> drivers/video/ep93xx-fb.c includes linux/platform.h (as its first include),
>> which includes linux/driver.h, which includes linux/module.h.
>>
>> Just tested on Linus' latest tree and both this driver and the ep93xx
>> backlight driver build fine. What kernel version are you using?
>>
>> ~Ryan
> hi Ryan,
>
> The patch is against linux-next tree.
> I got build error for ep93xx-fb.c and ep93xx_bl.c on linux-next tree.
> ( next-20110819 )

Ok, I see now. The change which caused the breakage is fdb697c: 
"include: replace linux/module.h with "struct module" wherever 
possible". How many other drivers got broken now that device.h does not 
include module.h?

~Ryan


>>>>    CC      drivers/video/ep93xx-fb.o
>>>> drivers/video/ep93xx-fb.c:120: error: expected ')' before 'int'
>>>> drivers/video/ep93xx-fb.c:122: error: expected ')' before string constant
>>>> drivers/video/ep93xx-fb.c:409: error: 'THIS_MODULE' undeclared here (not
>>>> in a function)
>>>> drivers/video/ep93xx-fb.c:645: error: expected declaration specifiers or
>>>> '...' before string constant
>>>> drivers/video/ep93xx-fb.c:645: warning: data definition has no type or
>>>> storage class
>>>> drivers/video/ep93xx-fb.c:645: warning: type defaults to 'int' in
>>>> declaration of 'MODULE_DESCRIPTION'
>>>> drivers/video/ep93xx-fb.c:645: warning: function declaration isn't a
>>>> prototype
>>>> drivers/video/ep93xx-fb.c:646: error: expected declaration specifiers or
>>>> '...' before string constant
>>>> drivers/video/ep93xx-fb.c:646: warning: data definition has no type or
>>>> storage class
>>>> drivers/video/ep93xx-fb.c:646: warning: type defaults to 'int' in
>>>> declaration of 'MODULE_ALIAS'
>>>> drivers/video/ep93xx-fb.c:646: warning: function declaration isn't a
>>>> prototype
>>>> drivers/video/ep93xx-fb.c:647: error: expected declaration specifiers or
>>>> '...' before string constant
>>>> drivers/video/ep93xx-fb.c:647: warning: data definition has no type or
>>>> storage class
>>>> drivers/video/ep93xx-fb.c:647: warning: type defaults to 'int' in
>>>> declaration of 'MODULE_AUTHOR'
>>>> drivers/video/ep93xx-fb.c:647: warning: function declaration isn't a
>>>> prototype
>>>> drivers/video/ep93xx-fb.c:649: error: expected declaration specifiers or
>>>> '...' before string constant
>>>> drivers/video/ep93xx-fb.c:649: warning: data definition has no type or
>>>> storage class
>>>> drivers/video/ep93xx-fb.c:649: warning: type defaults to 'int' in
>>>> declaration of 'MODULE_LICENSE'
>>>> drivers/video/ep93xx-fb.c:649: warning: function declaration isn't a
>>>> prototype
>>>> make[2]: *** [drivers/video/ep93xx-fb.o] Error 1
>>>> make[1]: *** [drivers/video] Error 2
>>>> make: *** [drivers] Error 2
>>>>
>>>> Signed-off-by: Axel Lin<axel.lin@gmail.com>
>>>> ---
>>>>   drivers/video/ep93xx-fb.c |    1 +
>>>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/video/ep93xx-fb.c b/drivers/video/ep93xx-fb.c
>>>> index 40e5f17..8133a9d 100644
>>>> --- a/drivers/video/ep93xx-fb.c
>>>> +++ b/drivers/video/ep93xx-fb.c
>>>> @@ -17,6 +17,7 @@
>>>>    *
>>>>    */
>>>>
>>>> +#include<linux/module.h>
>>>>   #include<linux/platform_device.h>
>>>>   #include<linux/dma-mapping.h>
>>>>   #include<linux/slab.h>
>>

