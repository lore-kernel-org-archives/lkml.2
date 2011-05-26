Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab1EZLb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:31:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3719 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab1EZLbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:31:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6357"; a="93793699"
Message-ID: <4DDE3A01.7010100@codeaurora.org>
Date: Thu, 26 May 2011 17:01:13 +0530
From: Mohan Pallaka <mpallaka@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Mohan Pallaka <mpallaka@codeaurora.org>, dmitry.torokhov@gmail.com,
        linux@arm.linux.org.uk, rmk+kernel@arm.linux.org.uk
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/2] pwm: Add stubs for pwm operations
References: <1305867584-31929-1-git-send-email-mpallaka@codeaurora.org> <4DD7CC83.1020700@codeaurora.org> <4DDB90D9.1020902@codeaurora.org>
In-Reply-To: <4DDB90D9.1020902@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Russell, please let me know if this patch looks okay for you.

Thanks, Mohan.

On 5/24/2011 4:34 PM, Mohan Pallaka wrote:
>  Ping.
>
> Hi Russell, please take sometime to review this patch.
>
> Thanks, Mohan.
>
> On 5/21/2011 8:00 PM, Mohan Pallaka wrote:
>>  On 5/20/2011 10:29 AM, Mohan Pallaka wrote:
>>> Chip drivers that support both pwm and non-pwm modes
>>> would encounter compilation errors if the platform doesn't
>>> have support for pwm, even though the chip is programmed
>>> to work in non-pwm mode. Add stubs for pwm functions to
>>> avoid compilation errors in these scenarios.
>>>
>>> Signed-off-by: Mohan Pallaka<mpallaka@codeaurora.org>
>>> ---
>>>   include/linux/pwm.h |   23 +++++++++++++++++++++++
>>>   1 files changed, 23 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
>>> index 7c77575..54877f6 100644
>>> --- a/include/linux/pwm.h
>>> +++ b/include/linux/pwm.h
>>> @@ -3,6 +3,7 @@
>>>
>>>   struct pwm_device;
>>>
>>> +#if defined(CONFIG_HAVE_PWM)
>>>   /*
>>>    * pwm_request - request a PWM device
>>>    */
>>> @@ -28,4 +29,26 @@ int pwm_enable(struct pwm_device *pwm);
>>>    */
>>>   void pwm_disable(struct pwm_device *pwm);
>>>
>>> +#else
>>> +
>>> +struct pwm_device *pwm_request(int pwm_id, const char *label)
>>> +{
>>> +    return NULL;
>>> +}
>>> +
>>> +void pwm_free(struct pwm_device *pwm) { }
>>> +
>>> +int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
>>> +{
>>> +    return -EINVAL;
>>> +}
>>> +
>>> +int pwm_enable(struct pwm_device *pwm)
>>> +{
>>> +    return -EINVAL;
>>> +}
>>> +
>>> +void pwm_disable(struct pwm_device *pwm) { }
>>> +
>>> +#endif /* CONFIG_HAVE_PWM */
>>>   #endif /* __LINUX_PWM_H */
>>> -- 
>>> Sent by a consultant of the Qualcomm Innovation Center, Inc.
>>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
>>> Forum.
>> Hi Russell, please review this patch.
>>
>> --Mohan
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-arm-msm" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

