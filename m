Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab2GDMZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 08:25:08 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15075 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2GDMZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 08:25:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 04 Jul 2012 05:25:05 -0700
Message-ID: <4FF43692.2040805@nvidia.com>
Date: Wed, 4 Jul 2012 21:26:58 +0900
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
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com> <20120704104840.GJ24458@pengutronix.de>
In-Reply-To: <20120704104840.GJ24458@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On 07/04/2012 07:48 PM, Sascha Hauer wrote:>> +
 >> +	pb->power_reg = devm_regulator_get(&pdev->dev, "power");
 >> +	if (IS_ERR(pb->power_reg))
 >> +		return PTR_ERR(pb->power_reg);
 >
 > This looses several resources allocated earlier, like the enable gpio
 > and the pwm. This is really bad here since I have no regulator specified
 > and devm_regulator_get returns with -EPROBE_DEFER. Next time the core
 > tries to probe the driver the driver bails out because the gpio and the
 > pwm is already requested.

That's very bad indeed. I assumed that the kernel would free 
devm-allocated resources after probe returned -EPROBE_DEFER, so that 
probe could reallocate them the next time it is called. Apparently that 
was wrong. Do you know what would the right approach be in this case? 
Does the kernel preserve the device structure and its associated data 
between the two calls to probe? If so, I could just check whether the 
private data has already been constructed to know which state we are in 
and continue from there.

Thanks,
Alex.
