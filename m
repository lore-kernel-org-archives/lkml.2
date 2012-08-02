Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab2HBKTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:19:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34866 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436Ab2HBKTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:19:54 -0400
Date: Thu, 2 Aug 2012 11:19:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [NEW DRIVER V1 5/7] DA9058 GPIO driver
Message-ID: <20120802101952.GG29157@opensource.wolfsonmicro.com>
References: <201208020849.q728nhU3007824@latitude.olech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208020849.q728nhU3007824@latitude.olech.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 09:48:57AM +0100, Anthony Olech wrote:

> +	mutex_lock(&gpio->lock);
> +	ret = da9058_reg_read(da9058, DA9058_STATUSC_REG, &gpio_level);
> +	mutex_unlock(&gpio->lock);

regmap already does locking for you.

> +	ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG, &gpio_cntrl);
> +	if (ret)
> +		goto exit;
> +
> +	if (offset) {
> +		gpio_cntrl &= ~0xF0;
> +		gpio_cntrl |= 0xF0 & gpio->out_config;
> +
> +		ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);

Just use regmap_update_bits().
