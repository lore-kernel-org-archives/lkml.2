Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab2JSWn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:43:59 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38275 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997Ab2JSWn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:43:56 -0400
MIME-Version: 1.0
In-Reply-To: <5081D0B3.2060204@gmail.com>
References: <507DF099.1010504@gmail.com> <CACRpkdbgrDZ+mzy4YaGtyHTm-P2nsEL6bwB7WS=OsZ1VF4crmQ@mail.gmail.com>
 <5081D0B3.2060204@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 19 Oct 2012 23:43:35 +0100
X-Google-Sender-Auth: ik9JOMv84qPkpW0pKlR3V61bxw4
Message-ID: <CACxGe6u8f86ShKiLy4j=PUWB6cOuxy1V4KAyOEqcBZ8Nzg8bRg@mail.gmail.com>
Subject: Re: [RFC PATCH] gpiolib: Refactor gpio_export
To: Ryan Mallon <rmallon@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 11:14 PM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 19/10/12 21:07, Linus Walleij wrote:
>
>> On Wed, Oct 17, 2012 at 1:41 AM, Ryan Mallon <rmallon@gmail.com> wrote:
>>
>>> The gpio_export function uses nested if statements and the status
>>> variable to handle the failure cases. This makes the function logic
>>> difficult to follow. Refactor the code to abort immediately on failure
>>> using goto. This makes the code slightly longer, but significantly
>>> reduces the nesting and number of split lines and makes the code easier
>>> to read.
>>>
>>> Signed-off-by: Ryan Mallon
>>
>> Very good initiative!
>>
>>> +++ b/drivers/gpio/gpiolib.c
>>> @@ -702,68 +702,74 @@ int gpio_export(unsigned gpio, bool direction_may_change)
>>>  {
>>>         unsigned long           flags;
>>>         struct gpio_desc        *desc;
>>> -       int                     status = -EINVAL;
>>> +       int                     status;
>>>         const char              *ioname = NULL;
>>> +       struct device           *dev;
>>>
>>>         /* can't export until sysfs is available ... */
>>>         if (!gpio_class.p) {
>>>                 pr_debug("%s: called too early!\n", __func__);
>>> -               return -ENOENT;
>>> +               status = -ENOENT;
>>> +               goto fail;
>>
>> Why bother with all the goto:s here since there are no resources
>> to clean up? Just pr_debug() and return -ENOENT; is good enough.
>>
>> I don't quite see the point.
>
> I did it this way just so that there would be a single exit point.
> I don't mind either way, so I'll update the ones without any
> clean up to simply return.

Single exit points are overrated. The code is shorter and easier to
read to return immediately if there isn't any unwinding to do.

g.
