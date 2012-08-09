Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab2HILYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:24:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56602 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758023Ab2HILYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:24:35 -0400
Message-ID: <50239DEB.5080209@linaro.org>
Date: Thu, 09 Aug 2012 16:54:27 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, patches@linaro.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] ARM: EXYNOS: Use generic pwm driver in Origen board
References: <1344503035-18127-1-git-send-email-tushar.behera@linaro.org> <20120809091526.GA693@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120809091526.GA693@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ linux-kernel@vger.kernel.org
- linux-kernel@lists.infradead.org

On 08/09/2012 02:45 PM, Thierry Reding wrote:
> On Thu, Aug 09, 2012 at 02:33:55PM +0530, Tushar Behera wrote:
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> ---
>>  arch/arm/mach-exynos/mach-origen.c |   11 +++++++++++
>>  1 files changed, 11 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
>> index 5ca8030..4c4048d 100644
>> --- a/arch/arm/mach-exynos/mach-origen.c
>> +++ b/arch/arm/mach-exynos/mach-origen.c
> [...]
>> @@ -613,6 +614,10 @@ static struct platform_device origen_lcd_hv070wsa = {
>>  	.dev.platform_data	= &origen_lcd_hv070wsa_data,
>>  };
>>  
>> +static struct pwm_lookup origen_pwm_lookup[] = {
>> +	PWM_LOOKUP("s3c24xx-pwm.0", 0, "pwm-backlight.0", NULL),
>> +};
>> +
> 
> This might conflict with some other patches that Jingoo (Cc'ed) is
> working on. His patches were going to rework the Samsung PWM driver to
> register multiple PWM devices per chip. In that case the s3c24xx-pwm
> device should probably be modified to use .id = -1 and then the .0 can
> be dropped from the provider name above.
> 
> Otherwise this patch looks good to me.
> 
> Thierry
> 
Thanks for your review.

It was wrong for me to create s3c24xx-pwm platform device as it is
already created in samsung_bl_set(). Hence I would be dropping that.

However, dropping .0 from provider name results in following. (as the
device name is s3c24xx-pwm.N).

[    0.240000] pwm-backlight pwm-backlight.0: unable to request PWM,
trying legacy API

I will resubmit the patch with these changes.

-- 
Tushar Behera
