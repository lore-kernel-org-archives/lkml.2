Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab2IFGxD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 02:53:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48450 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab2IFGxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 02:53:01 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Subject: RE: [PATCH] pwm: pwm-tiecap: Disable APWM mode after configure
Thread-Topic: [PATCH] pwm: pwm-tiecap: Disable APWM mode after configure
Thread-Index: AQHNgP8kuVYEOTnfR0yB/Olh6HGaUZd85oBw
Date: Thu, 6 Sep 2012 06:51:53 +0000
Deferred-Delivery: Thu, 6 Sep 2012 06:51:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E99B4C1@DBDE01.ent.ti.com>
References: <1345705186-10543-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1345705186-10543-1-git-send-email-avinashphilip@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

If you do not have any comments, could you please accept it?

Thanks
Avinash

On Thu, Aug 23, 2012 at 12:29:46, Philip, Avinash wrote:
> APWM mode is enabled while configuring PWM device. This was done to
> handle shadow & immediate mode update of period and compare registers.
> However, leaving it enabled after configuring will cause APWM output on
> PWM pin even before enabling PWM device.
> Fix the same by disabling APWM mode after configuring if PWM device is
> not running.
> 
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> ---
> :100644 100644 0b66d0f... 4b66889... M	drivers/pwm/pwm-tiecap.c
>  drivers/pwm/pwm-tiecap.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pwm/pwm-tiecap.c b/drivers/pwm/pwm-tiecap.c
> index 0b66d0f..4b66889 100644
> --- a/drivers/pwm/pwm-tiecap.c
> +++ b/drivers/pwm/pwm-tiecap.c
> @@ -100,6 +100,13 @@ static int ecap_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>  		writel(period_cycles, pc->mmio_base + CAP3);
>  	}
>  
> +	if (!test_bit(PWMF_ENABLED, &pwm->flags)) {
> +		reg_val = readw(pc->mmio_base + ECCTL2);
> +		/* Disable APWM mode to put APWM output Low */
> +		reg_val &= ~ECCTL2_APWM_MODE;
> +		writew(reg_val, pc->mmio_base + ECCTL2);
> +	}
> +
>  	pm_runtime_put_sync(pc->chip.dev);
>  	return 0;
>  }
> -- 
> 1.7.1
> 
> 

