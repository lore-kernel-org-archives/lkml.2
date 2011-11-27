Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab1K0Lfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 06:35:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39940 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852Ab1K0Lfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 06:35:32 -0500
Date: Sun, 27 Nov 2011 11:35:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Avoid potential NULL dereference in
 reg_fixed_voltage_probe()
Message-ID: <20111127113529.GG2896@opensource.wolfsonmicro.com>
References: <1322360030.6779.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322360030.6779.1.camel@phoenix>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 10:13:50AM +0800, Axel Lin wrote:

> -	if (pdev->dev.of_node)
> +	if (pdev->dev.of_node) {
>  		config = of_get_fixed_voltage_config(&pdev->dev);
> +		if (!config)
> +			return -ENOMEM;
> +	}

Looking at this I'm thinking it's better to just drop the check for
of_node entirely and just let of_get_fixed_voltage_config() fail to find
what it needs.
