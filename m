Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1J0Sje (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 14:39:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41984 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1J0Sjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 14:39:32 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF173E1B48D0@HQMAIL01.nvidia.com>
References: <1319662641-28416-1-git-send-email-marek.belisko@open-nandra.com>
	<74CDBE0F657A3D45AFBB94109FB122FF173E1B48D0@HQMAIL01.nvidia.com>
Date: Thu, 27 Oct 2011 20:39:31 +0200
Message-ID: <CAAfyv35wup69rvZ0yQpzYfqeE8r+1Rcimr53rFoaBF09X=tTTw@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinmux: Remove double pin validity check.
From: Belisko Marek <marek.belisko@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 6:37 PM, Stephen Warren <swarren@nvidia.com> wrote:
> Belisko Marek wrote at Wednesday, October 26, 2011 2:57 PM:
>> Function pin_is_valid just call pin_desc_get which is in pin_request
>> call some line below. Remove pin_is_valid() check.
> ...
>> @@ -112,16 +112,6 @@ static int pin_request(struct pinctrl_dev *pctldev,
>>
>>       dev_dbg(&pctldev->dev, "request pin %d for %s\n", pin, function);
>>
>> -     if (!pin_is_valid(pctldev, pin)) {
>> -             dev_err(&pctldev->dev, "pin is invalid\n");
>> -             return -EINVAL;
>> -     }
>
> So that makes sense.
>
>> -
>> -     if (!function) {
>> -             dev_err(&pctldev->dev, "no function name given\n");
>> -             return -EINVAL;
>> -     }
>
> But I don't think you want to remove that? Oh actually, perhaps removing
> that /is/ valid, since it's an internal function and can't be called with
> a NULL function parameter. But, you should mention why in the changelog
> so it doesn't look like a mistake.
Well it's not removed. It's moved below pin_desc_get call.
>
> --
> nvpublic
>
>

regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
