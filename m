Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749Ab2GDPDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:03:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6845 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2GDPDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:03:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Jul 2012 08:03:08 -0700
Message-ID: <4FF45DDF.9000306@nvidia.com>
Date: Thu, 5 Jul 2012 00:14:39 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com> <20120704104840.GJ24458@pengutronix.de> <4FF43692.2040805@nvidia.com> <20120704130056.GC30009@pengutronix.de>
In-Reply-To: <20120704130056.GC30009@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 04 Jul 2012 10:00:56 PM JST, Sascha Hauer wrote:
>> That's very bad indeed. I assumed that the kernel would free
>> devm-allocated resources after probe returned -EPROBE_DEFER,
>
> It indeed does free devm allocated resources, but neither the gpio nor
> the pwm are devm allocated.

As far as I can tell the gpio is allocated through devm as well:

 > +		ret = devm_gpio_request_one(&pdev->dev, data->enable_gpio,
 > +				GPIOF_OUT_INIT_HIGH, "backlight_enable");

Thus if it is not reclaimed with probe returns with -EPROBE_DEFER, then 
I guess something is going wrong elsewhere. You are right that the PWM 
should be freed by the driver thought.

> Also please be aware that using a regulator in the pwm backlight will
> instantly break all existing users. That's hardly your fault though.

Sorry, I don't see why. Could you elaborate on this?

Thanks,
Alex.

