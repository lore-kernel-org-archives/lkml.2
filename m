Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1IVKa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 06:30:26 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:37084
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752710Ab1IVKaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 06:30:25 -0400
Message-ID: <4E7B0E35.5010607@compulab.co.il>
Date: Thu, 22 Sep 2011 13:30:13 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: pxa/cm-x300: properly set bt_reset pin
References: <1316268934.16763.2.camel@phoenix>
In-Reply-To: <1316268934.16763.2.camel@phoenix>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On 09/17/11 17:15, Axel Lin wrote:
> Fix below build warning and properly set bt_reset pin.
> 
>   CC      arch/arm/mach-pxa/cm-x300.o
> arch/arm/mach-pxa/cm-x300.c: In function 'cm_x300_init_wi2wi':
> arch/arm/mach-pxa/cm-x300.c:779: warning: unused variable 'wlan_en'
> arch/arm/mach-pxa/cm-x300.c:795: warning: 'bt_reset' may be used uninitialized in this function

What a shame...
My patch 5a009df1f200efa49658b0e9c7ad056d59fbefe4
(ARM: pxa/cm-x300: GPIO cleanup) was f*cked up, sorry...
I should have not send it in a rush and I admit,
I had no possibility to test it. Sorry again...

> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks for spotting this.

Acked-by: Igor Grinberg <grinberg@compulab.co.il>

Also, this patch fixes a real regression since
5a009df1f200efa49658b0e9c7ad056d59fbefe4 (ARM: pxa/cm-x300: GPIO cleanup)
- Wifi and Bluetooth do not work without it, so please:

Cc: <stable@kernel.org> [3.0.x]

> ---
>  arch/arm/mach-pxa/cm-x300.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/cm-x300.c b/arch/arm/mach-pxa/cm-x300.c
> index 0f00e01..0e18eb9 100644
> --- a/arch/arm/mach-pxa/cm-x300.c
> +++ b/arch/arm/mach-pxa/cm-x300.c
> @@ -776,7 +776,6 @@ static struct gpio cm_x300_wi2wi_gpios[] __initdata = {
>  
>  static void __init cm_x300_init_wi2wi(void)
>  {
> -	int bt_reset, wlan_en;
>  	int err;
>  
>  	if (system_rev < 130) {
> @@ -792,12 +791,11 @@ static void __init cm_x300_init_wi2wi(void)
>  	}
>  
>  	udelay(10);
> -	gpio_set_value(bt_reset, 0);
> +	gpio_set_value(cm_x300_wi2wi_gpios[1].gpio, 0);
>  	udelay(10);
> -	gpio_set_value(bt_reset, 1);
> +	gpio_set_value(cm_x300_wi2wi_gpios[1].gpio, 1);
>  
> -	gpio_free(wlan_en);
> -	gpio_free(bt_reset);
> +	gpio_free_array(ARRAY_AND_SIZE(cm_x300_wi2wi_gpios));
>  }
>  
>  /* MFP */

-- 
Regards,
Igor.
