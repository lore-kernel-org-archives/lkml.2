Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab1LLExH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 23:53:07 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59709 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254Ab1LLExE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 23:53:04 -0500
Date: Mon, 12 Dec 2011 12:52:59 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>,
        arnd@arndb.de, linaro-dev@lists.linaro.org, eric.miao@linaro.org
Subject: Re: [PATCH 02/06] MFD: DA9052/53 MFD core module v9 Added ADC support
Message-ID: <20111212045258.GD2806@opensource.wolfsonmicro.com>
References: <1323440166.23171.70.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323440166.23171.70.camel@dhruva>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 07:46:06PM +0530, Ashish Jangam wrote:

> +	req = kzalloc(sizeof(*req), GFP_KERNEL);
> +	if (!req)
> +		return -ENOMEM;

> +	init_completion(&req->done);
> +	req->input = channel;
> +
> +	if (channel > DA9052_ADC_VBBAT)
> +		return -EINVAL;

This will leak the request.

> +	list_del(&req->list);
> +err:
> +	mutex_unlock(&da9052->auxadc_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(da9052_adc_manual_read);

In fact is req freed at all?
