Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034Ab2EBEAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 00:00:54 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57657 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab2EBEAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 00:00:52 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYHKR+oOD36RCUMobEwJj_Y9WDHTUY+UaHAx0YegMhXyg@mail.gmail.com>
References: <1335768768-10231-1-git-send-email-sachin.kamat@linaro.org>
	<CACRpkdYHKR+oOD36RCUMobEwJj_Y9WDHTUY+UaHAx0YegMhXyg@mail.gmail.com>
Date: Wed, 2 May 2012 09:30:51 +0530
Message-ID: <CAK9yfHz0v_ChjJqp0DpSFzgF+Nb638cqdLohHmzJ0sjVEZf_Fg@mail.gmail.com>
Subject: Re: [PATCH] gpio/exynos: Fix compiler warnings when non-exynos
 machines are selected
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Apr 30, 2012 at 8:52 AM, Sachin Kamat <sachin.kamat@linaro.org>
> wrote:
>
>> +#if defined(CONFIG_ARCH_EXYNOS4) || defined(CONFIG_ARCH_EXYNOS5)
>> +#endif
>> -static struct samsung_gpio_chip exynos4_gpios_1[] = {
>>  #ifdef CONFIG_ARCH_EXYNOS4
>> +static struct samsung_gpio_chip exynos4_gpios_1[] = {
>> -#endif
>> +#endif
>> -static struct samsung_gpio_chip exynos4_gpios_2[] = {
>>  #ifdef CONFIG_ARCH_EXYNOS4
>> +static struct samsung_gpio_chip exynos4_gpios_2[] = {
>> -#endif
>> +#endif
>> -static struct samsung_gpio_chip exynos4_gpios_3[] = {
>>  #ifdef CONFIG_ARCH_EXYNOS4
>> +static struct samsung_gpio_chip exynos4_gpios_3[] = {
>> -#endif
>> +#endif
>>  #ifdef CONFIG_ARCH_EXYNOS5
>> +#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS5250)
>> +#endif
>> +#if defined(CONFIG_CPU_EXYNOS4210) || defined(CONFIG_SOC_EXYNOS5250)
>> +#endif
>
> We really want to get rid of this kind of stuff from all drivers, #ifdefs
> are
> declared ugly already in Documentation/CodingStyle.

Yes, you are right. #Ifdefs should be avoided as far as possible and
more importantly to get a single zImage.

>
> Any chance you could solve this problem by reworking the driver to
> pass some flag in platform data tell which exynos it's for
> and jist adapt at runtime instead of the compile-time quirkiness?

No. I wouldn't be working on this, hence provided this patch to get
rid of the nasty compiler warnings until someone fixes the same
(compile-time to runtime adaptation).

>
> Besides looking better, it helps us to get to a single zImage for the
> exynoses too..

Definitely.



>
> Yours,
> Linus Walleij
>


-- 
With warm regards,
Sachin
