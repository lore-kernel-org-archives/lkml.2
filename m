Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1J0GNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 02:13:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41252 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1J0GNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 02:13:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110261405400.23111@chino.kir.corp.google.com>
References: <1319662641-28416-1-git-send-email-marek.belisko@open-nandra.com>
	<1319662641-28416-2-git-send-email-marek.belisko@open-nandra.com>
	<alpine.DEB.2.00.1110261405400.23111@chino.kir.corp.google.com>
Date: Thu, 27 Oct 2011 08:13:04 +0200
Message-ID: <CAAfyv35KsspWGAkmZmZOaDw5v3tngKuV8YqQ_fvZU4azHCUtYA@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinmux: Unify pin type from signed to unsigned.
From: Belisko Marek <marek.belisko@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: swarren@nvidia.com, linus.walleij@linaro.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 11:06 PM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 26 Oct 2011, Marek Belisko wrote:
>
>> diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
>> index 3605e94..34c33c7 100644
>> --- a/include/linux/pinctrl/pinctrl.h
>> +++ b/include/linux/pinctrl/pinctrl.h
>> @@ -112,7 +112,7 @@ struct pinctrl_desc {
>>  extern struct pinctrl_dev *pinctrl_register(struct pinctrl_desc *pctldesc,
>>                               struct device *dev, void *driver_data);
>>  extern void pinctrl_unregister(struct pinctrl_dev *pctldev);
>> -extern bool pin_is_valid(struct pinctrl_dev *pctldev, int pin);
>> +extern bool pin_is_valid(struct pinctrl_dev *pctldev, unsigned int pin);
>>  extern void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
>>                               struct pinctrl_gpio_range *range);
>>  extern void pinctrl_remove_gpio_range(struct pinctrl_dev *pctldev,
>> @@ -123,7 +123,7 @@ extern void *pinctrl_dev_get_drvdata(struct pinctrl_dev *pctldev);
>>
>>
>>  /* Sufficiently stupid default function when pinctrl is not in use */
>> -static inline bool pin_is_valid(struct pinctrl_dev *pctldev, int pin)
>> +static inline bool pin_is_valid(struct pinctrl_dev *pctldev, unsigned int pin)
>>  {
>>       return pin >= 0;
>>  }
>
>
> So this would just become return true, right?
Right I've overlooked it. Will send update version.
>

thanks,

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
