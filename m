Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab1EOIAm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 04:00:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44742 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1EOIAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 04:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HM3o+hGsVYnyvIJbF0rPdGRk4Fccs1ODBUhm5qdCqifbxY3AArZ0mduQB5hGp9ux+u
         ri6OGxYczJCSaj4zFPUoyK0rxcL81Kz0ubsY87DCo9gH5H4CGdNTK7ryKpKqaiM8Csx8
         y5upWP7FWJzaeyoHHq+6o/jVAsyGqcAqrG5yE=
Date: Sun, 15 May 2011 01:00:31 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mohan Pallaka <mpallaka@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.intradead.org, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, rmk@dyn-67.arm.linux.org.uk
Subject: Re: [PATCH 1/2] pwm: Add __weak attributed functions for pwm
 operations
Message-ID: <20110515080031.GA12911@core.coreip.homeip.net>
References: <1305290602-29859-1-git-send-email-mpallaka@codeaurora.org>
 <1305290602-29859-2-git-send-email-mpallaka@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305290602-29859-2-git-send-email-mpallaka@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 06:13:21PM +0530, Mohan Pallaka wrote:
> For chip drivers that support both pwm and non-pwm modes
> would encounter compilation errors if the platform doesn't
> have support for pwm though the chip is programmed to work
> in non-pwm mode. Add __weak attributed pwm functions to avoid
> compilation issues in these scenarios.
> 

Russell,

You seem to have authored pwm.h, do you have any objections to this
change?

Thanks!

> Change-Id: Ia507bf659d4d67d71f135012e7d919aca6c45c6c
> Signed-off-by: Mohan Pallaka <mpallaka@codeaurora.org>
> ---
>  include/linux/pwm.h |   12 +++++++-----
>  1 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/pwm.h b/include/linux/pwm.h
> index 7c77575..e0c8c3f 100644
> --- a/include/linux/pwm.h
> +++ b/include/linux/pwm.h
> @@ -3,29 +3,31 @@
>  
>  struct pwm_device;
>  
> +/* Add __weak functions to support PWM */
> +
>  /*
>   * pwm_request - request a PWM device
>   */
> -struct pwm_device *pwm_request(int pwm_id, const char *label);
> +struct pwm_device __weak *pwm_request(int pwm_id, const char *label);
>  
>  /*
>   * pwm_free - free a PWM device
>   */
> -void pwm_free(struct pwm_device *pwm);
> +void __weak pwm_free(struct pwm_device *pwm);
>  
>  /*
>   * pwm_config - change a PWM device configuration
>   */
> -int pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
> +int __weak pwm_config(struct pwm_device *pwm, int duty_ns, int period_ns);
>  
>  /*
>   * pwm_enable - start a PWM output toggling
>   */
> -int pwm_enable(struct pwm_device *pwm);
> +int __weak pwm_enable(struct pwm_device *pwm);
>  
>  /*
>   * pwm_disable - stop a PWM output toggling
>   */
> -void pwm_disable(struct pwm_device *pwm);
> +void __weak pwm_disable(struct pwm_device *pwm);
>  
>  #endif /* __LINUX_PWM_H */
> 
> -- 
> Sent by a consultant of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

-- 
Dmitry
