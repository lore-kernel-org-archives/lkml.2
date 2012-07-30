Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab2G3Tum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:50:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53910 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2G3Tuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:50:40 -0400
MIME-Version: 1.0
In-Reply-To: <CANLzEktXNikod3Cj=a4hM85z2X29KZVptWWLVh7SMtjROxCx4w@mail.gmail.com>
References: <1343283113-16952-1-git-send-email-bleung@chromium.org>
	<20120730055009.GB5830@core.coreip.homeip.net>
	<CANLzEktXNikod3Cj=a4hM85z2X29KZVptWWLVh7SMtjROxCx4w@mail.gmail.com>
Date: Mon, 30 Jul 2012 12:50:39 -0700
X-Google-Sender-Auth: MQty0tWJ6lsDvhQxeu8D_Oj0-p0
Message-ID: <CANLzEkvN2SG+qrRyNYqKgNQUbK29LumxKkBsvzB015xd=pi85w@mail.gmail.com>
Subject: Re: [PATCH] Input: gpio_keys - Report wakeup events if device may wakeup
From: Benson Leung <bleung@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, I take it back. It doesn't look like it's necessary.

Benson

On Mon, Jul 30, 2012 at 12:28 PM, Benson Leung <bleung@chromium.org> wrote:
> Hi Dmitry,
>
> Yes I see Neil's changes. Thank you for letting me know.
>
> By the way, looking at Neil's changes, would it make sense to check
> for device_may_wakeup(dev) like in my patch so that the wakeup
> behavior can be turned off by setting power/wakeup to disabled?
>
> Benson
>
> On Sun, Jul 29, 2012 at 10:50 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>> Hi Benson,
>>
>> On Wed, Jul 25, 2012 at 11:11:53PM -0700, Benson Leung wrote:
>>> If a button is configured to wake the system, report a pm wakeup event.
>>>
>>
>> Thank you for your patch, however I applied more complete patch sent by
>> NeilBrown.
>>
>>> Signed-off-by: Benson Leung <bleung@chromium.org>
>>> ---
>>>  drivers/input/keyboard/gpio_keys.c |    4 ++++
>>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
>>> index cbb1add..15a80e2 100644
>>> --- a/drivers/input/keyboard/gpio_keys.c
>>> +++ b/drivers/input/keyboard/gpio_keys.c
>>> @@ -328,9 +328,13 @@ static void gpio_keys_gpio_report_event(struct gpio_button_data *bdata)
>>>  {
>>>       const struct gpio_keys_button *button = bdata->button;
>>>       struct input_dev *input = bdata->input;
>>> +     struct device *dev = input->dev.parent;
>>>       unsigned int type = button->type ?: EV_KEY;
>>>       int state = (gpio_get_value_cansleep(button->gpio) ? 1 : 0) ^ button->active_low;
>>>
>>> +     if (button->wakeup && device_may_wakeup(dev))
>>> +             pm_wakeup_event(dev, 0);
>>> +
>>>       if (type == EV_ABS) {
>>>               if (state)
>>>                       input_event(input, type, button->code, button->value);
>>> --
>>> 1.7.7.3
>>>
>>
>> --
>> Dmitry
>
>
>
> --
> Benson Leung
> Software Engineer, Chrom* OS
> bleung@chromium.org



-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
