Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab0ICJmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:42:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53757 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0ICJmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:42:03 -0400
Date: Fri, 3 Sep 2010 10:42:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Changhwan Youn <chaos.youn@samsung.com>, lrg@slimlogic.co.uk
Subject: Re: [PATCH] regulators: add support max8952 regulator
Message-ID: <20100903094200.GC8381@sirena.org.uk>
References: <1283476524-12820-1-git-send-email-kgene.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283476524-12820-1-git-send-email-kgene.kim@samsung.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 10:15:24AM +0900, Kukjin Kim wrote:

> +	ret2 = max8649_reg_read(info->i2c, MAX8649_CHIP_ID2);
> +	if (ret2 < 0) {
> +		dev_err(info->dev, "Failed to detect ID of %s:%d\n",
> +			id->name, ret2);
>  		goto out;
>  	}

If the read fails you'll not set an error code when you jump to out so
the probe will report success.  It might be clearer to have separate id
variables which you store the read values into if they're OK, just from
a legibility point of view.

> -	dev_info(info->dev, "Detected MAX8649 (ID:%x)\n", ret);
> +	dev_info(info->dev, "Detected %s (ID:%x %x)\n", id->name, ret, ret2);
> +
> +	info->type = id->driver_data;

It'd be nice to check that the type that was supplied matches the ID
read from the chip in case the user got things wrong, just for
defensiveness.
