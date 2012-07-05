Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2GEGXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 02:23:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15900 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab2GEGXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 02:23:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 04 Jul 2012 23:23:51 -0700
Message-ID: <4FF53368.6090805@nvidia.com>
Date: Thu, 5 Jul 2012 15:25:44 +0900
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
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com> <20120704104840.GJ24458@pengutronix.de> <4FF43692.2040805@nvidia.com> <20120704130056.GC30009@pengutronix.de> <4FF45DDF.9000306@nvidia.com> <20120704152451.GA7333@sirena.org.uk> <4FF4FDC0.8020405@nvidia.com> <20120705062011.GI30009@pengutronix.de>
In-Reply-To: <20120705062011.GI30009@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2012 03:20 PM, Sascha Hauer wrote:
>> Oh, that is a mistake of mine then. Driver probe should continue if
>> no regulator is declared (but should fail if some other error
>> occured). I want to maintain backward compatibility with current
>> users of the driver, so regulator/gpio specification should be
>> optional.
>
> I think the only way doing this is to add a flag to platform_data. I
> don't know if that's accepted though.

I thought about just checking if devm_get_regulator returned -ENODEV and 
happily continue if that was the case, assuming no regulator was declared.

But anyway with the power sequences specification this problem becomes 
null, since regulators will have to be explicitly declared anyway. I 
might be flamed for putting a parser and interpreter into a backlight 
driver, but I'll take my chances. :)

Alex.
