Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab2IYJUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 05:20:51 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52771 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2IYJUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 05:20:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAK7N6vph4eQssGrt0yK=scZuiq+v52o5jVcx3g98kxUKjpvF2g@mail.gmail.com>
References: <1348556335-14686-1-git-send-email-sachin.kamat@linaro.org>
	<CAK7N6vph4eQssGrt0yK=scZuiq+v52o5jVcx3g98kxUKjpvF2g@mail.gmail.com>
Date: Tue, 25 Sep 2012 14:50:49 +0530
Message-ID: <CAK9yfHzLVKph4ts-WdrLX_jftj8B4bf57nrA1ifK_hOCVOBOAQ@mail.gmail.com>
Subject: Re: [PATCH] extcon: Fix return value in extcon_register_interest()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: anish singh <anish198519851985@gmail.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 September 2012 14:45, anish singh <anish198519851985@gmail.com> wrote:
> On Tue, Sep 25, 2012 at 12:28 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
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
>>         obj->cable_index = extcon_find_cable_index(obj->edev, cable_name);
>>         if (obj->cable_index < 0)
>> -               return -ENODEV;
>> +               return obj->cable_index;
> I think ENODEV is right here as the function will return negative
> value only when
> there is no such device for which the user is trying to register the interest.
> Is there any problem with that?

extcon_find_cable_index() returns -EINVAL when it fails.
Hence it is better to propagate the same error code instead of a different one.

>>
>>         obj->user_nb = nb;
>>
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With warm regards,
Sachin
