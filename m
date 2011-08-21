Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab1HUXDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 19:03:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:22807 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab1HUXDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 19:03:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,260,1312182000"; 
   d="scan'208";a="42421921"
Date: Mon, 22 Aug 2011 01:05:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: wni@nvidia.com
Cc: mike@compulab.co.il, gking@nvidia.com, nkumbhar@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps6586x: add api to power off tps6586x
Message-ID: <20110821230511.GA4607@sortiz-mobl>
References: <1311834636-15940-1-git-send-email-wni@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311834636-15940-1-git-send-email-wni@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Thu, Jul 28, 2011 at 02:30:36PM +0800, wni@nvidia.com wrote:
> +static struct i2c_client *tps6586x_i2c_client;
That's not vey nice. By doing so, you're preventing anyone to have more than
one of those chips in their boards.


> +int tps6586x_power_off(void)
> +{
> +	struct device *dev = NULL;
> +	int ret = -EINVAL;
> +
> +	if (!tps6586x_i2c_client)
> +		return ret;
> +
> +	dev = &tps6586x_i2c_client->dev;
> +
> +	ret = tps6586x_clr_bits(dev, TPS6586X_SUPPLYENE, EXITSLREQ_BIT);
> +	if (ret)
> +		return ret;
> +
> +	ret = tps6586x_set_bits(dev, TPS6586X_SUPPLYENE, SLEEP_MODE_BIT);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(tps6586x_power_off);
Who is going to call this one ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
