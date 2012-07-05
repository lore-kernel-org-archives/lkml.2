Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab2GEHlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 03:41:37 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2967 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2GEHlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 03:41:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Jul 2012 00:38:06 -0700
Message-ID: <4FF5459F.5090201@nvidia.com>
Date: Thu, 5 Jul 2012 16:43:27 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com> <20120704104840.GJ24458@pengutronix.de> <4FF43692.2040805@nvidia.com> <20120704130056.GC30009@pengutronix.de> <4FF45DDF.9000306@nvidia.com> <20120704152451.GA7333@sirena.org.uk> <4FF4FDC0.8020405@nvidia.com> <20120705062011.GI30009@pengutronix.de> <4FF53368.6090805@nvidia.com> <20120705064742.GL30009@pengutronix.de>
In-Reply-To: <20120705064742.GL30009@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 03:47 PM, Sascha Hauer wrote:
>> I thought about just checking if devm_get_regulator returned -ENODEV
>> and happily continue if that was the case, assuming no regulator was
>> declared.
>
> And that's the problem. The get_regulator won't return -ENODEV. It will
> return -EPROBE_DEFER which tells you nothing about whether a regulator
> will ever be available or not.
>
> Having a flag in platform data would be fine with me, but I know other
> people think differently.
>
> BTW in devicetree this flag implicitely exists with the power-supply
> property.

One could actually question whether the whole regulator/gpio thing 
should be supported at all with platform data. The platform interface 
can use the function hooks in order to implement whatever behavior it 
wants when the light needs to be powered on and off. The reason for 
introducing optional regulator/gpio parameters is because the DT cannot 
use these. Since I have no plan to remove these function hooks, making 
the regulator/gpio option available in platform data might be redundant. 
Any thought about this?

> Right now the regulator core will just return -EPROBE_DEFER in both
> cases. This could easily be changed in the regulator core.

Could this be because the regulator core cannot make the difference 
between a not-yet-available regulator and a missing one?

Alex.
