Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab2GEA54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 20:57:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14797 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2GEA5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 20:57:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 04 Jul 2012 17:57:38 -0700
Message-ID: <4FF4E679.10909@nvidia.com>
Date: Thu, 5 Jul 2012 06:27:29 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rajendra Nayak <rnayak@ti.com>
CC: "mturquette@ti.com" <mturquette@ti.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>, <swarren@nvidia.com>
Subject: Re: [PATCH] clk: fix parent validation in __clk_set_parent()
References: <1341313938-17861-1-git-send-email-rnayak@ti.com>
In-Reply-To: <1341313938-17861-1-git-send-email-rnayak@ti.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 July 2012 04:42 PM, Rajendra Nayak wrote:
> The below commit introduced a bug in __clk_set_parent()
> which could cause it to *skip* the parent validation
> which makes sure the parent passed to the api is a valid
> one.

Need this fix for Tegra too.

>      commit 7975059db572eb47f0fb272a62afeae272a4b209
>      Author: Rajendra Nayak<rnayak@ti.com>
>      Date:   Wed Jun 6 14:41:31 2012 +0530
>
>          clk: Allow late cache allocation for clk->parents
>
> This was identified by the following compiler warning..
>
>      drivers/clk/clk.c: In function '__clk_set_parent':
>      drivers/clk/clk.c:1083:5: warning: 'i' may be used uninitialized in this function [-Wuninitialized]
>
> .. as reported by Marc Kleine-Budde.
>
> There were various options discussed on how to fix this, one
> being initing 'i' to clk->num_parents, but the below approach
> was found to be more appropriate as it also makes the 'parent
> validation' code simpler to read.
>
> Reported-by: Marc Kleine-Budde<mkl@pengutronix.de>
> Signed-off-by: Rajendra Nayak<rnayak@ti.com>
>

