Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1CJM0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 07:26:33 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50753 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1CJM0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 07:26:31 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6280"; a="79123959"
Message-ID: <4D78C3B0.4050806@codeaurora.org>
Date: Thu, 10 Mar 2011 17:57:28 +0530
From: Mohan Pallaka <mpallaka@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mohan Pallaka <mpallaka@codeaurora.org>
CC: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk
Subject: Re: [PATCH 1/2] pwm: Add __weak attributed functions for pwm operations
References: <1299496182-26177-1-git-send-email-mpallaka@codeaurora.org> <1299496182-26177-2-git-send-email-mpallaka@codeaurora.org>
In-Reply-To: <1299496182-26177-2-git-send-email-mpallaka@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/2011 4:39 PM, Mohan Pallaka wrote:
> For chip drivers that support both pwm and non-pwm modes
> would encounter compilation errors if the platform doesn't
> have support for pwm though the chip is programmed to work
> in non-pwm mode. Add __weak attributed pwm functions to avoid
> compilation issues in these scenarios.
> 
> Signed-off-by: Mohan Pallaka <mpallaka@codeaurora.org>
> ---
>  include/linux/pwm.h |   21 ++++++++++++++++-----
>  1 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 7c77575..3a8c3df 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -3,29 +3,40 @@
>  
>  struct pwm_device;
>  
> +/* Add __weak functions to support PWM */
> +
>  /*
>   * pwm_request - request a PWM device
>   */
> -struct pwm_device *pwm_request(int pwm_id, const char *label);
> +struct pwm_device __weak *pwm_request(int pwm_id, const char *label)
> +{
> +	return NULL;
> +}
>  
>  /*
>   * pwm_free - free a PWM device
>   */
> -void pwm_free(struct pwm_device *pwm);
> +void __weak pwm_free(struct pwm_device *pwm) { }
>  
>  /*
>   * pwm_config - change a PWM device configuration
>   */
> -int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
> +int __weak pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns)
> +{
> +	return -ENODEV;
> +}
>  
>  /*
>   * pwm_enable - start a PWM output toggling
>   */
> -int pwm_enable(struct pwm_device *pwm);
> +int __weak pwm_enable(struct pwm_device *pwm)
> +{
> +	return -EINVAL;
> +}
>  
>  /*
>   * pwm_disable - stop a PWM output toggling
>   */
> -void pwm_disable(struct pwm_device *pwm);
> +void __weak pwm_disable(struct pwm_device *pwm) { }
>  
>  #endif /* __LINUX_PWM_H */
> 

Ping.

Please spend sometime to review this.

Thanks,
Mohan.

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
