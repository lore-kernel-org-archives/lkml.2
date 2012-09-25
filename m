Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab2IYKoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 06:44:11 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54840 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2IYKoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 06:44:08 -0400
MIME-Version: 1.0
In-Reply-To: <5061882D.2080804@samsung.com>
References: <1348556335-14686-1-git-send-email-sachin.kamat@linaro.org>
	<5061882D.2080804@samsung.com>
Date: Tue, 25 Sep 2012 16:14:07 +0530
Message-ID: <CAK9yfHwJ5LASrheAuW4CLm8feceS6891tzsnAsBENNkzMzNJ+A@mail.gmail.com>
Subject: Re: [PATCH] extcon: Fix return value in extcon_register_interest()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2012 16:02, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> On 09/25/2012 03:58 PM, Sachin Kamat wrote:
>
>> Return the value obtained from extcon_find_cable_index()
>> instead of -ENODEV.
>>
>> Fixes the following smatch info:
>> drivers/extcon/extcon-class.c:478 extcon_register_interest() info:
>> why not propagate 'obj->cable_index' from extcon_find_cable_index()
>> instead of -19?
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/extcon/extcon-class.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
>> index 946a318..e996800 100644
>> --- a/drivers/extcon/extcon-class.c
>> +++ b/drivers/extcon/extcon-class.c
>> @@ -475,7 +475,7 @@ int extcon_register_interest(struct extcon_specific_cable_nb *obj,
>>
>>       obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
>>       if (obj->cable_index < 0)
>> -             return -ENODEV;
>> +             return obj->cable_index;
>>
>>       obj->user_nb = nb;
>>
>
>
> I agree.
> But, if extcon_register_interest() return directly 'obj-cable_index' value
> when extcon_find_cable_index() return -EINVAL, it would spoil readability
> of extcon_register_interest() function. So, I think we can make it as
> following
> patch  a little better.

Ok. I will re-send this with this change.

>
> ---
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index 936580b..078e6a5 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -468,7 +468,7 @@ int extcon_register_interest(struct
> extcon_specific_cable_nb *obj,
>
>         obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
>         if (obj->cable_index < 0)
> -               return -ENODEV;
> +               return -EINVAL;
>
>         obj->user_nb = nb;
>
>
>
> Thanks,
> Chanwoo Choi



-- 
With warm regards,
Sachin
