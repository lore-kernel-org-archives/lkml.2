Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab2F3Dmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 23:42:42 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7406 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2F3Dmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 23:42:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 29 Jun 2012 20:42:40 -0700
Message-ID: <4FEE785C.306@nvidia.com>
Date: Sat, 30 Jun 2012 12:54:04 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com> <4FEDD222.7050905@wwwdotorg.org>
In-Reply-To: <4FEDD222.7050905@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2012 01:04 AM, Stephen Warren wrote:
 >> -	dev_dbg(&pdev->dev, "got pwm for backlight\n");
 >> -
 >
 > That seems like an unrelated change?

Dammit, I hoped that would have gone unnoticed. ;)

 >> +	pb->enable_gpio = -EINVAL;
 >> +	if (data->use_enable_gpio) {
 >> +		ret = devm_gpio_request_one(&pdev->dev, data->enable_gpio,
 >> +				GPIOF_OUT_INIT_HIGH, "backlight_enable");
 >> +		if (ret)
 >> +			dev_warn(&pdev->dev,
 >> +				"error %d requesting control gpio\n", ret);
 >
 > Shouldn't that be a hard error? If the user specified that some GPIO be
 > used, and the GPIO could not be requested, shouldn't the driver fail to
 > initialize?

Yes, you are right.

Thanks,
Alex.

