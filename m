Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab2IKIfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:35:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43232 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2IKIfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:35:15 -0400
Message-ID: <504EF7BC.8030605@linaro.org>
Date: Tue, 11 Sep 2012 14:05:08 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-kernel@vger.kernel.org, sachin.kamat@linaro.org, patches@linaro.org
Subject: Re: [PATCH] pwm: Fix compilation error when CONFIG_PWM is not defined
References: <1347343464-15417-1-git-send-email-tushar.behera@linaro.org> <20120911061901.GA24260@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120911061901.GA24260@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 11:49 AM, Thierry Reding wrote:
> On Tue, Sep 11, 2012 at 11:34:24AM +0530, Tushar Behera wrote:
>> As per Documentation/pwm.txt, PWM_LOOKUP and pwm_add_table are used in
>> board support files to add PWM chip entries. Currently these
>> definitions are protected within CONFIG_PWM macro in
>> include/linux/pwm.h.
>>
>> Otherwise, we have to add ifdef's in machine file to fix following
>> compilation error.
>>
>> error: array type has incomplete element type
>> error: implicit declaration of function ‘PWM_LOOKUP’ [-Werror=implicit-function-declaration]
>> error: implicit declaration of function ‘pwm_add_table’ [-Werror=implicit-function-declaration]
>> error: bit-field ‘<anonymous>’ width not an integer constant
> 
> I think it would make more sense to have the board's Kconfig option
> select PWM instead. After all if you're defining a lookup table you
> probably want to use it as well.
> 
> Eventually I was going to rework the pwm.h a bit to safely compile
> out if the PWM symbol is not selected, similar to how the GPIO or
> clock subsystems do this. Something like your patch will be part of
> that but more needs to be done. If you feel up to it, maybe you can
> take this patch further and provide dummies for all the remaining
> functions as well.
> 

Sure, I will extend the remaining APIs and resubmit.

> If you do that, one additional comment below.
> 
>> Reported-by: Sachin Kamat <sachin.kamat@linaro.org>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> ---
>>  include/linux/pwm.h |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
>> index 21d076c..87e7f45 100644
>> --- a/include/linux/pwm.h
>> +++ b/include/linux/pwm.h
>> @@ -124,6 +124,7 @@ struct pwm_device *pwm_request_from_chip(struct pwm_chip *chip,
>>  
>>  struct pwm_device *pwm_get(struct device *dev, const char *consumer);
>>  void pwm_put(struct pwm_device *pwm);
>> +#endif
>>  
>>  struct pwm_lookup {
>>  	struct list_head list;
>> @@ -141,8 +142,10 @@ struct pwm_lookup {
>>  		.con_id = _con_id,			\
>>  	}
>>  
>> +#ifdef CONFIG_PWM
>>  void pwm_add_table(struct pwm_lookup *table, size_t num);
>> -
>> +#else
>> +static void pwm_add_table(struct pwm_lookup *table, size_t num) {}
>>  #endif
> 
> This should be "static inline" and I prefer to have the {} on separate
> lines.
> 

Ok.

> Thierry
> 


-- 
Tushar Behera
