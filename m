Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab2HPNQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:16:28 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50590 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932235Ab2HPNQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:16:25 -0400
Message-ID: <1345122983.26882.9.camel@joe2Laptop>
Subject: Re: [PATCH] net: add new QCA alx ethernet driver
From: Joe Perches <joe@perches.com>
To: cjren@qca.qualcomm.com
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com,
        Xiong Huang <xiong@qca.qualcomm.com>,
        "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 16 Aug 2012 06:16:23 -0700
In-Reply-To: <1345053189-10326-1-git-send-email-cjren@qca.qualcomm.com>
References: <1345053189-10326-1-git-send-email-cjren@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 01:53 +0800, cjren@qca.qualcomm.com wrote:
> From: Cloud Ren <cjren@qca.qualcomm.com>
> 
> This driver support two new ethernet chipsets:
> 1969:1091 - AR8161 Gigabit Ethernet
> 1969:1090 - AR8162 Fast Ethernet

[]

> diff --git a/drivers/net/ethernet/atheros/alx/alx_main.c b/drivers/net/ethernet/atheros/alx/alx_main.c
[]
> +/*
> + * alx_hw_printk
> + */
> +void alx_hw_printk(const char *level, const struct alx_hw *hw,
> +		   const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	va_start(args, fmt);
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	if (hw && hw->adpt && hw->adpt->netdev)
> +		__netdev_printk(level, hw->adpt->netdev, &vaf);

Hi Cloud.  Please convert this to

		netdev_printk(level, hw->adpt->netdev, "%pV", &vaf);

I will submit a patch soon to make the __netdev_printk variant static.


