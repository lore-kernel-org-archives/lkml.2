Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab2IZFxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 01:53:39 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54285 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2IZFxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 01:53:38 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbA8Uiy2ed5DJ99Aoztp=VOSL_2t9VGNi2bC3264LE7Hg@mail.gmail.com>
References: <1347624124-27535-1-git-send-email-sachin.kamat@linaro.org>
	<CACRpkdbA8Uiy2ed5DJ99Aoztp=VOSL_2t9VGNi2bC3264LE7Hg@mail.gmail.com>
Date: Wed, 26 Sep 2012 11:23:37 +0530
Message-ID: <CAK9yfHy7xCTo8Xzt3-LAcYiTM+k9W8MLKJB_ucoPVNeaeu4Fig@mail.gmail.com>
Subject: Re: [PATCH 1/1] pinctrl: Samsung: Fix return value
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thomas Abraham <thomas.ab@samsung.com>, linux-kernel@vger.kernel.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Please provide your review comments.

On 14 September 2012 19:37, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Sep 14, 2012 at 2:02 PM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
>
>> Return the value obtained from of_property_count_strings()
>> instead of -EINVAL.
>>
>> Silences the following smatch warning:
>> drivers/pinctrl/pinctrl-samsung.c:529 samsung_pinctrl_parse_dt_pins()
>> info: why not propagate '*npins' from of_property_count_strings()
>> instead of -22?
>>
>> Cc: Thomas Abraham <thomas.ab@samsung.com>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>>  drivers/pinctrl/pinctrl-samsung.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
>> index 8a24223..824fda9 100644
>> --- a/drivers/pinctrl/pinctrl-samsung.c
>> +++ b/drivers/pinctrl/pinctrl-samsung.c
>> @@ -526,7 +526,7 @@ static int __init samsung_pinctrl_parse_dt_pins(struct platform_device *pdev,
>>         *npins = of_property_count_strings(cfg_np, "samsung,pins");
>>         if (*npins < 0) {
>>                 dev_err(dev, "invalid pin list in %s node", cfg_np->name);
>> -               return -EINVAL;
>> +               return *npins;
>>         }
>
> Thomas, please check this ...
>
> Yours,
> Linus Walleij



-- 
With warm regards,
Sachin
