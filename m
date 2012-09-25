Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab2IYJ1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:27:44 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63624 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab2IYJ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:27:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAK9yfHzLVKph4ts-WdrLX_jftj8B4bf57nrA1ifK_hOCVOBOAQ@mail.gmail.com>
References: <1348556335-14686-1-git-send-email-sachin.kamat@linaro.org>
	<CAK7N6vph4eQssGrt0yK=scZuiq+v52o5jVcx3g98kxUKjpvF2g@mail.gmail.com>
	<CAK9yfHzLVKph4ts-WdrLX_jftj8B4bf57nrA1ifK_hOCVOBOAQ@mail.gmail.com>
Date: Tue, 25 Sep 2012 14:57:42 +0530
Message-ID: <CAK7N6vokMdeNGtPF=UgKRmXBxmz=b+QW9kObywmN7gwiBfKcAw@mail.gmail.com>
Subject: Re: [PATCH] extcon: Fix return value in extcon_register_interest()
From: anish singh <anish198519851985@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 2:50 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> On 25 September 2012 14:45, anish singh <anish198519851985@gmail.com> wrote:
>> On Tue, Sep 25, 2012 at 12:28 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>>> Return the value obtained from extcon_find_cable_index()
>>> instead of -ENODEV.
>>>
>>> Fixes the following smatch info:
>>> drivers/extcon/extcon-class.c:478 extcon_register_interest() info:
>>> why not propagate 'obj->cable_index' from extcon_find_cable_index()
>>> instead of -19?
>>>
>>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>>> ---
>>>  drivers/extcon/extcon-class.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
>>> index 946a318..e996800 100644
>>> --- a/drivers/extcon/extcon-class.c
>>> +++ b/drivers/extcon/extcon-class.c
>>> @@ -475,7 +475,7 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
>>>
>>>         obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
>>>         if (obj->cable_index < 0)
>>> -               return -ENODEV;
>>> +               return obj->cable_index;
>> I think ENODEV is right here as the function will return negative
>> value only when
>> there is no such device for which the user is trying to register the interest.
>> Is there any problem with that?
>
> extcon_find_cable_index() returns -EINVAL when it fails.
> Hence it is better to propagate the same error code instead of a different one.
but returning wrong value wouldn't make sense IMHO.In this case
the user just want to register the interest for a particular device and what the
original author intends to return is this: there is no such device.I
think logically
it makes sense but I am not too sure about it.
>
>>>
>>>         obj->user_nb = nb;
>>>
>>> --
>>> 1.7.4.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
> With warm regards,
> Sachin
