Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2LRLNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 06:13:25 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51730 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754011Ab2LRLNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 06:13:23 -0500
Message-ID: <1355829202.19706.28.camel@joe-AO722>
Subject: Re: [PATCH 1/8] Thermal: Create sensor level APIs
From: Joe Perches <joe@perches.com>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hongbo.zhang@linaro.org, wni@nvidia.com
Date: Tue, 18 Dec 2012 03:13:22 -0800
In-Reply-To: <1355822977-4804-2-git-send-email-durgadoss.r@intel.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
	 <1355822977-4804-2-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 14:59 +0530, Durgadoss R wrote:
> This patch creates sensor level APIs, in the
> generic thermal framework.

Just some trivial notes.

> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
[]
> +static ssize_t
> +sensor_temp_show(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	int ret;
> +	long val;
> +	struct thermal_sensor *ts = to_thermal_sensor(dev);
> +
> +	ret = ts->ops->get_temp(ts, &val);
> +
> +	return ret ? ret : sprintf(buf, "%ld\n", val);

I'd much prefer the form

	ret = ts->ops...
	if (ret)
		return ret;

	return sprintf(buf, "%ld\n", val);

Otherwise, maybe use gcc's pretty common ?: extension
	return ret ?: sprintf(...) 

[]

> +static int enable_sensor_thresholds(struct thermal_sensor *ts, int count)
> +{
> +	int i;
> +	int size = sizeof(struct thermal_attr) * count;
> +
> +	ts->thresh_attrs = kzalloc(size, GFP_KERNEL);

kcalloc

> +	if (!ts->thresh_attrs)
> +		return -ENOMEM;
> +
> +	if (ts->ops->get_hyst) {
> +		ts->hyst_attrs = kzalloc(size, GFP_KERNEL);

kcalloc here too



