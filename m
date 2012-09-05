Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084Ab2IERZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 13:25:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53232 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab2IERZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 13:25:32 -0400
Message-ID: <50478B07.4080708@wwwdotorg.org>
Date: Wed, 05 Sep 2012 11:25:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-fbdev@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v5 2/4] pwm_backlight: use power sequences
References: <1346412846-17102-1-git-send-email-acourbot@nvidia.com> <1346412846-17102-3-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1346412846-17102-3-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2012 05:34 AM, Alexandre Courbot wrote:
> Make use of the power sequences specified in the device tree or platform
> data to control how the backlight is powered on and off.

> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt

>  Optional properties:
> -  - pwm-names: a list of names for the PWM devices specified in the
> -               "pwms" property (see PWM binding[0])
> +  - pwm-names: name for the PWM device specified in the "pwms" property (see PWM
> +      binding[0]). Necessary if power sequences are used

So this implies that power sequence are completely optional in the pwm
binding...

> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig

>  config BACKLIGHT_PWM
>  	tristate "Generic PWM based Backlight Driver"
>  	depends on PWM
> +	select POWER_SEQ

... but that implies they're basically mandatory.

Briefly looking at the code, power sequences don't appear to be
optional, at least for the DT case, so perhaps you just need to update
the documentation to make "pwm-names" non-optional?
