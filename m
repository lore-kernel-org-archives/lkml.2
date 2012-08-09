Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2HIMfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 08:35:12 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5233 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2HIMfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 08:35:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 09 Aug 2012 05:35:09 -0700
Message-ID: <5023AAE5.90603@nvidia.com>
Date: Thu, 9 Aug 2012 17:49:49 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 3/3] regulator: add MAX8907 driver
References: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org> <1344460727-6243-3-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1344460727-6243-3-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2012 02:48 AM, Stephen Warren wrote:
> From: Gyungoh Yoo<jack.yoo@maxim-ic.com>
>
> The MAX8907 is an I2C-based power-management IC containing voltage
> regulators, a reset controller, a real-time clock, and a touch-screen

> +       for (i = 0; i<  MAX8907_NUM_REGULATORS; i++) {
> +               config.dev = pdev->dev.parent;
> +               if (pdata)
> +                       idata = pdata->init_data[i];
> +               else
> +                       idata = max8907_matches[i].init_data;

Can we check whether idata is valid or not?
There may be possibility that some of regulator node is not populated 
and that case, the idata will be NULL and hence regulator registration 
can be bypass for that regulator.

